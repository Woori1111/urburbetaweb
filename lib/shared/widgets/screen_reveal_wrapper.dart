import 'package:flutter/material.dart';

import 'skeleton_card.dart';
import 'staggered_reveal.dart';

/// 화면 입장 시: 스켈레톤 → 스태거드 카드 리빌
class ScreenRevealWrapper extends StatefulWidget {
  const ScreenRevealWrapper({
    super.key,
    required this.contentCards,
    this.skeletonCardCount = 2,
    this.skeletonDurationMs = 500,
  });

  /// 위에서 아래 순서의 카드(섹션) 위젯 목록
  final List<Widget> contentCards;
  final int skeletonCardCount;
  final int skeletonDurationMs;

  @override
  State<ScreenRevealWrapper> createState() => _ScreenRevealWrapperState();
}

class _ScreenRevealWrapperState extends State<ScreenRevealWrapper> {
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: widget.skeletonDurationMs),
      () {
        if (mounted) setState(() => _showSkeleton = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSkeleton) {
      return SkeletonScreenLayout(
        cardCount: widget.skeletonCardCount,
        padding: 12,
      );
    }
    return StaggeredReveal(
      children: widget.contentCards,
      staggerMs: 80,
      durationMs: 320,
      offsetY: 24,
    );
  }
}
