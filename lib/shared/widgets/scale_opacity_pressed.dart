import 'package:flutter/material.dart';

/// Scale + Opacity pressed interaction (눌렀을 때 축소 + 투명도)
/// 플로팅 버튼, 글쓰기/등록 버튼 등에 통일 적용
class ScaleOpacityPressed extends StatefulWidget {
  const ScaleOpacityPressed({
    super.key,
    required this.onPressed,
    required this.child,
    this.scaleDown = 0.94,
    this.opacityDown = 0.88,
    this.duration = const Duration(milliseconds: 80),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double scaleDown;
  final double opacityDown;
  final Duration duration;

  @override
  State<ScaleOpacityPressed> createState() => _ScaleOpacityPressedState();
}

class _ScaleOpacityPressedState extends State<ScaleOpacityPressed> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? widget.scaleDown : 1.0;
    final opacity = _pressed ? widget.opacityDown : 1.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: opacity,
          duration: widget.duration,
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}
