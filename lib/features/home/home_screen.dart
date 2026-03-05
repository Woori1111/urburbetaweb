import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bar_logo.dart';
import '../../shared/widgets/scale_opacity_pressed.dart';

/// 홈 아이콘 8개 제목 (4개씩 2줄)
const List<String> _homeIconTitles = [
  '아이콘1', '아이콘2', '아이콘3', '아이콘4',
  '아이콘5', '아이콘6', '아이콘7', '아이콘8',
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBanner(context),
              _buildIconGrid(context),
              _buildMemoriesSection(context),
              _buildSupportButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildIconGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) => _buildIconItem(context, i)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) => _buildIconItem(context, i + 4)),
          ),
        ],
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // webp 넣을 자리: assets/icons/icon_1.webp ~ icon_8.webp 추가 후 Image.asset 사용
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: AppColors.graySurfaceVariant,
                  child: Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: AppColors.grayMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _homeIconTitles[index],
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoriesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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

  Widget _buildSupportButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
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
    );
  }
}
