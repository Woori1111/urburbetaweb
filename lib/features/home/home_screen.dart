import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bar_logo.dart';
import '../../shared/widgets/scale_opacity_pressed.dart';
import '../../shared/widgets/screen_reveal_wrapper.dart';

/// 홈 아이콘 8개 (4개씩 2줄) — 아이콘 크기 고정, 여백만 반응형 (iPhone 15 Pro 393pt 기준)
const List<({IconData icon, String label})> _homeIconItems = [
  (icon: Icons.volunteer_activism_rounded, label: '지원'),
  (icon: Icons.emoji_events_rounded, label: '명예의전당'),
  (icon: Icons.people_rounded, label: '임원진'),
  (icon: Icons.photo_library_rounded, label: '추억'),
  (icon: Icons.forest_rounded, label: '대나무숲'),
  (icon: Icons.edit_note_rounded, label: '반성문'),
  (icon: Icons.person_off_rounded, label: '배신자'),
  (icon: Icons.music_note_rounded, label: '음원'),
];

const double _homeIconSize = 40;
const double _homeIconBoxSize = 64;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.currentIndex, required this.tabIndex});
  final int currentIndex;
  final int tabIndex;

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
        child: SingleChildScrollView(
          child: ScreenRevealWrapper(
            revealTrigger: currentIndex == tabIndex,
            skeletonCardCount: 4,
            contentCards: [
              _buildBannerCard(context),
              _buildIconGridCard(context),
              _buildMemoriesCard(context),
              _buildSupportCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 2.2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.graySurfaceVariant,
                  AppColors.graySurfaceVariant.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Text(
                '배너',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.grayMuted,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconGridCard(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final width = MediaQuery.sizeOf(context).width - padding.horizontal - 24;
    final horizontalPadding = (width / 4 - _homeIconBoxSize).clamp(8.0, 24.0) / 2;
    final verticalSpacing = 20.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                children: List.generate(4, (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _buildIconItem(context, i),
                  ),
                )),
              ),
              SizedBox(height: verticalSpacing),
              Row(
                children: List.generate(4, (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _buildIconItem(context, i + 4),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, int index) {
    final item = _homeIconItems[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _homeIconBoxSize,
          height: _homeIconBoxSize,
          decoration: BoxDecoration(
            color: AppColors.graySurfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(
            item.icon,
            size: _homeIconSize,
            color: AppColors.grayMuted,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMemoriesCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Card(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Icon(
                  Icons.photo_library_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '우리들의 추억',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '함께한 순간들을 모아봐요',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.grayMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ScaleOpacityPressed(
            onPressed: () {},
            child: IgnorePointer(
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.grayOnSurface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text('지원하기'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
