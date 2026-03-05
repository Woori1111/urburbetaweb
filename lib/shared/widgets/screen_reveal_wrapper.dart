import 'package:flutter/material.dart';

import 'skeleton_card.dart';
import 'staggered_reveal.dart';

/// 화면 입장 시마다: 스켈레톤 → 스태거드 카드 리빌 (revealTrigger가 true일 때마다 재생)
class ScreenRevealWrapper extends StatefulWidget {
  const ScreenRevealWrapper({
    super.key,
    required this.contentCards,
    this.skeletonCardCount = 2,
    this.skeletonDurationMs = 500,
    this.revealTrigger = true,
  });

  /// 위에서 아래 순서의 카드(섹션) 위젯 목록
  final List<Widget> contentCards;
  final int skeletonCardCount;
  final int skeletonDurationMs;
  /// true가 될 때마다 스켈레톤 → 스태거드 리빌 재생 (탭 입장 시 true 전달)
  final bool revealTrigger;

  @override
  State<ScreenRevealWrapper> createState() => _ScreenRevealWrapperState();
}

class _ScreenRevealWrapperState extends State<ScreenRevealWrapper> {
  bool _showSkeleton = true;
  bool _previousTrigger = false;

  void _startReveal() {
    _showSkeleton = true;
    Future.delayed(
      Duration(milliseconds: widget.skeletonDurationMs),
      () {
        if (mounted) setState(() => _showSkeleton = false);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _previousTrigger = widget.revealTrigger;
    if (widget.revealTrigger) {
      _startReveal();
    } else {
      _showSkeleton = false;
    }
  }

  @override
  void didUpdateWidget(covariant ScreenRevealWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealTrigger && !_previousTrigger) {
      _previousTrigger = true;
      _startReveal();
    } else if (!widget.revealTrigger) {
      _previousTrigger = false;
    }
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
