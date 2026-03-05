import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';

/// 로딩 화면: 가운데 로고 + "로딩중." (점 1~3개 반복 애니메이션)
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({
    super.key,
    this.onDone,
    this.duration = const Duration(seconds: 2),
  });

  final VoidCallback? onDone;
  final Duration duration;

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _dotCount = 1;
  Timer? _dotTimer;
  Timer? _doneTimer;

  @override
  void initState() {
    super.initState();
    _dotTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (mounted) setState(() => _dotCount = (_dotCount % 3) + 1);
    });
    _doneTimer = Timer(widget.duration, () {
      _dotTimer?.cancel();
      widget.onDone?.call();
    });
  }

  @override
  void dispose() {
    _dotTimer?.cancel();
    _doneTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.logo,
                width: 240,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_outlined,
                  size: 120,
                  color: AppColors.grayMuted,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '로딩중${'.' * _dotCount}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grayOnSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
