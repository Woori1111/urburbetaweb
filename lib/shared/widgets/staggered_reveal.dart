import 'package:flutter/material.dart';

/// 위→아래 순차 카드 리빌 (Staggered Top-to-Bottom Card Reveal)
class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.children,
    this.staggerMs = 80,
    this.durationMs = 320,
    this.offsetY = 24,
  });

  final List<Widget> children;
  final int staggerMs;
  final int durationMs;
  final double offsetY;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _durationTotalMs;

  @override
  void initState() {
    super.initState();
    _durationTotalMs = widget.durationMs +
        (widget.children.length - 1) * widget.staggerMs;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationTotalMs.round()),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _durationTotalMs;
    final durationMs = widget.durationMs.toDouble();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.children.length, (i) {
        final start = (i * widget.staggerMs) / total;
        final end = start + durationMs / total;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = ((_controller.value - start) / (end - start)).clamp(0.0, 1.0);
            final curveT = Curves.easeOutCubic.transform(t);
            final opacity = curveT;
            final dy = (1 - curveT) * widget.offsetY;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, dy),
                child: widget.children[i],
              ),
            );
          },
        );
      }),
    );
  }
}
