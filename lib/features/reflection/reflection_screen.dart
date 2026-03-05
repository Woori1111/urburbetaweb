import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bar_logo.dart';
import '../../shared/widgets/scale_opacity_pressed.dart';
import '../../shared/widgets/screen_reveal_wrapper.dart';
import '../hall_of_fame/hall_of_fame_repository.dart';
import 'reflection_repository.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key, required this.currentIndex, required this.tabIndex});
  final int currentIndex;
  final int tabIndex;

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final ReflectionRepository _reflectionRepo = ReflectionRepository();
  final HallOfFameRepository _hallOfFameRepo = HallOfFameRepository();

  final TextEditingController _contentController = TextEditingController();
  String? _selectedHallOfFameId;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitReflection(List<HallOfFameItem> suspendedList) async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('반성문 내용을 입력해주세요.')),
      );
      return;
    }
    final hallOfFameId = _selectedHallOfFameId;
    if (hallOfFameId == null || hallOfFameId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정지된 게시글을 선택해주세요.')),
      );
      return;
    }

    try {
      await _reflectionRepo.addReflection(hallOfFameId: hallOfFameId, content: content);
      _contentController.clear();
      setState(() => _selectedHallOfFameId = null);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('반성문이 등록되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('등록 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const AppBarLogo(),
        title: const SizedBox.shrink(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ScreenRevealWrapper(
          revealTrigger: widget.currentIndex == widget.tabIndex,
          skeletonCardCount: 2,
          contentCards: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Card(child: _buildInputSection()),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: _buildReflectionList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return StreamBuilder<List<HallOfFameItem>>(
      stream: _hallOfFameRepo.watchPhotos(),
      builder: (context, photoSnapshot) {
        final allPhotos = photoSnapshot.data ?? [];
        final suspendedList = allPhotos.where((p) => p.isSuspended).toList();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (suspendedList.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '정지된 게시글이 없습니다. 명예의 전당에서 싫어요 5개 이상 받으면 반성문을 작성할 수 있어요.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                )
              else ...[
                DropdownButtonFormField<String>(
                  value: _selectedHallOfFameId,
                  decoration: const InputDecoration(
                    labelText: '정지된 게시글 선택',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: suspendedList
                      .map((p) => DropdownMenuItem(
                            value: p.id,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    p.imageUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    cacheWidth: 80,
                                    cacheHeight: 80,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '사진 (${p.dislikeCount}표 정지)',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: suspendedList.isEmpty
                      ? null
                      : (id) => setState(() => _selectedHallOfFameId = id),
                ),
                const SizedBox(height: 8),
              ],
              TextField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '반성문을 작성해주세요...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 8),
              ScaleOpacityPressed(
                onPressed: suspendedList.isEmpty
                    ? null
                    : () => _submitReflection(suspendedList),
                child: IgnorePointer(
                  child: FilledButton.icon(
                    onPressed: suspendedList.isEmpty ? null : () {},
                    icon: const Icon(Icons.send_rounded, size: 20),
                    label: const Text('등록'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReflectionList() {
    return StreamBuilder<List<ReflectionItem>>(
      stream: _reflectionRepo.watchReflections(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('오류: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final list = snapshot.data!;
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 12),
                Text(
                  '등록된 반성문이 없어요',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = list[index];
            return _ReflectionCard(
              item: item,
              onReleaseTap: () => _reflectionRepo.incrementReleaseVote(item.id),
            );
          },
        );
      },
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({
    required this.item,
    required this.onReleaseTap,
  });

  final ReflectionItem item;
  final VoidCallback onReleaseTap;

  @override
  Widget build(BuildContext context) {
    final isReleased = item.isReleased;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ScaleOpacityPressed(
                  onPressed: isReleased ? null : onReleaseTap,
                  child: IgnorePointer(
                    child: OutlinedButton.icon(
                      onPressed: isReleased ? null : () {},
                      icon: Icon(
                        isReleased ? Icons.lock_open_rounded : Icons.favorite_rounded,
                        size: 18,
                      ),
                      label: Text(isReleased ? '석방됨' : '석방시켜주기 (${item.releaseVoteCount}/${ReflectionItem.releaseThreshold})'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.yellowDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
