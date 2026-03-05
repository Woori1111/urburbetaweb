import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 스켈레톤 플레이스홀더 카드 (쉼머 효과)
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({
    super.key,
    this.height = 120,
    this.borderRadius = 12,
  });

  final double height;
  final double borderRadius;

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmer = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: AppColors.surfaceVariant,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _shimmer,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _ShimmerPainter(
                    progress: _shimmer.value,
                    baseColor: AppColors.surfaceVariant,
                    highlightColor: Colors.white.withOpacity(0.4),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  _ShimmerPainter({
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
  });

  final double progress;
  final Color baseColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = baseColor);
    final gradient = LinearGradient(
      begin: Alignment(-1 + progress, 0),
      end: Alignment(progress, 0),
      colors: [Colors.transparent, highlightColor, Colors.transparent],
      stops: const [0.0, 0.5, 1.0],
    );
    canvas.save();
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width * 2, size.height),
        ),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// 화면별 스켈레톤 레이아웃 (카드 N개)
class SkeletonScreenLayout extends StatelessWidget {
  const SkeletonScreenLayout({
    super.key,
    this.cardCount = 2,
    this.padding = 12,
  });

  final int cardCount;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(cardCount, (i) {
          final isLast = i == cardCount - 1;
          final isFirst = i == 0;
          final card = SkeletonCard(
            height: isFirst ? 140 : 200,
          );
          if (cardCount == 1) {
            return card;
          }
          if (!isLast) {
            return Padding(
              padding: EdgeInsets.only(bottom: padding / 2),
              child: card,
            );
          }
          return card;
        }),
      ),
    );
  }
}
