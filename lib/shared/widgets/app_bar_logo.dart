import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// AppBar 좌측 로고 (urbur_logo.png). 제목 없이 사용.
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key, this.height = 36});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Center(
        child: Image.asset(
          AppAssets.logo,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_outlined,
            size: height,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ),
    );
  }
}
