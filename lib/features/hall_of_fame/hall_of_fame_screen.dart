import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bar_logo.dart';
import '../../shared/widgets/scale_opacity_pressed.dart';
import '../../shared/widgets/screen_reveal_wrapper.dart';
import 'hall_of_fame_repository.dart';

class HallOfFameScreen extends StatefulWidget {
  const HallOfFameScreen({super.key, required this.currentIndex, required this.tabIndex});
  final int currentIndex;
  final int tabIndex;

  @override
  State<HallOfFameScreen> createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends State<HallOfFameScreen> {
  final HallOfFameRepository _repository = HallOfFameRepository();
  final ScrollController _scrollController = ScrollController();

  /// 스크롤 시 확장(알약형) / 축소(원형) 전환
  bool _isFabExtended = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final delta = offset - _lastScrollOffset;
    _lastScrollOffset = offset;

    if (delta > 8) {
      // 스크롤 다운 → FAB 축소
      if (_isFabExtended) setState(() => _isFabExtended = false);
    } else if (delta < -8 || offset < 80) {
      // 스크롤 업 또는 상단 근처 → FAB 확장
      if (!_isFabExtended) setState(() => _isFabExtended = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onFabPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text(
          '선정적이거나 선넘은 사진은 올리면 영구정지',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.grayOnSurface,
              ),
              child: const Text('확인'),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) await _pickAndUploadPhoto();
  }

  Future<void> _pickAndUploadPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty || result.files.single.bytes == null) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('업로드 중...')),
    );

    try {
      final file = result.files.single;
      final bytes = file.bytes!;
      final fileName = file.name;
      await _repository.addPhoto(fileName: fileName, bytes: bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진이 등록되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        child: StreamBuilder<List<HallOfFameItem>>(
          stream: _repository.watchPhotos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              final errorCard = Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: AppColors.grayMuted),
                          const SizedBox(height: 16),
                          Text('오류: ${snapshot.error}', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              return ScreenRevealWrapper(
                revealTrigger: widget.currentIndex == widget.tabIndex,
                skeletonCardCount: 1,
                contentCards: [errorCard],
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final items = snapshot.data!;
            if (items.isEmpty) {
              final emptyCard = Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events_rounded,
                                size: 64,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '아직 등록된 사진이 없어요',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '우측 하단에서 사진을 등록해보세요',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              return ScreenRevealWrapper(
                revealTrigger: widget.currentIndex == widget.tabIndex,
                skeletonCardCount: 1,
                contentCards: [emptyCard],
              );
            }
            final topByLikes = _topThreeByLikes(items);

            final contentCard = Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _PodiumSection(items: topByLikes),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = items[index];
                            return _PhotoTile(
                              item: item,
                              repository: _repository,
                              onLongPress: () => _confirmDelete(context, item.id),
                            );
                          },
                          childCount: items.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            return ScreenRevealWrapper(
              revealTrigger: widget.currentIndex == widget.tabIndex,
              skeletonCardCount: 1,
              contentCards: [contentCard],
            );
          },
        ),
      ),
      floatingActionButton: ScaleOpacityPressed(
        onPressed: _onFabPressed,
        child: IgnorePointer(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _isFabExtended
                ? FloatingActionButton.extended(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: const Text('사진 등록'),
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.grayOnSurface,
                    shape: const StadiumBorder(),
                  )
                : FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(Icons.photo_camera_rounded),
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.grayOnSurface,
                  ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// 좋아요 순 상위 3명 [2등, 1등, 3등] (포디움 순서: 왼쪽=2등, 가운데=1등, 오른쪽=3등)
  List<HallOfFameItem?> _topThreeByLikes(List<HallOfFameItem> items) {
    final sorted = List<HallOfFameItem>.from(items)
      ..sort((a, b) => b.likeCount.compareTo(a.likeCount));
    final top = sorted.take(3).toList();
    return [
      top.length > 1 ? top[1] : null, // 2등 왼쪽
      top.isNotEmpty ? top[0] : null,  // 1등 가운데
      top.length > 2 ? top[2] : null,  // 3등 오른쪽
    ];
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제'),
        content: const Text('이 사진을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok == true) await _repository.deletePhoto(id);
  }
}

/// 상단 포디움: 2등(왼쪽) 1등(가운데) 3등(오른쪽), 좌우는 작고 뒤에 보이게, 가로 스크롤
class _PodiumSection extends StatelessWidget {
  const _PodiumSection({required this.items});

  /// [2등, 1등, 3등] 순서 (nullable)
  final List<HallOfFameItem?> items;

  static const double _podiumHeight = 160;
  static const double _centerWidth = 120;
  static const double _sideWidth = 92;
  static const double _sideScale = 0.82;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _podiumHeight + 28,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _PodiumSlot(item: items[0], width: _sideWidth, scale: _sideScale, rank: 2),
            _PodiumSlot(item: items[1], width: _centerWidth, scale: 1.0, rank: 1),
            _PodiumSlot(item: items[2], width: _sideWidth, scale: _sideScale, rank: 3),
          ],
        ),
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  const _PodiumSlot({
    required this.item,
    required this.width,
    required this.scale,
    required this.rank,
  });

  final HallOfFameItem? item;
  final double width;
  final double scale;
  final int rank;

  static const double _podiumHeight = 160;

  @override
  Widget build(BuildContext context) {
    final content = item == null
        ? Container(
            width: width,
            height: _podiumHeight,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.emoji_events_rounded,
                size: 40, color: AppColors.grayMuted),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item!.imageUrl,
              width: width,
              height: _podiumHeight,
              fit: BoxFit.cover,
              cacheWidth: (width * 2).round(),
              cacheHeight: (_podiumHeight * 2).round(),
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rank등',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.yellowDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: scale < 1 ? 0.92 : 1,
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.item,
    required this.repository,
    required this.onLongPress,
  });

  final HallOfFameItem item;
  final HallOfFameRepository repository;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final isSuspended = item.isSuspended;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                  if (isSuspended) ...[
                    Container(
                      color: Colors.grey.withOpacity(0.65),
                      child: const Center(
                        child: Icon(
                          Icons.lock_rounded,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isSuspended ? null : () => repository.incrementLike(item.id),
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  label: Text('${item.likeCount}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.yellowDark,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isSuspended ? null : () => repository.incrementDislike(item.id),
                  icon: const Icon(Icons.thumb_down_alt_outlined, size: 18),
                  label: Text('${item.dislikeCount}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.yellowDark,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
          if (isSuspended) ...[
            const SizedBox(height: 4),
            Text(
              '정지되었습니다. 반성문을 작성하세요',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
