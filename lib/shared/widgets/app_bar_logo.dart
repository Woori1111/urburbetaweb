import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// AppBar 좌측 로고 (urbur_logo.png). 제목 없이 사용.
/// 웹: HTML과 동일 경로(images/urbur_logo.png)로 로드해 base href와 무관하게 표시.
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key, this.height = 36});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Center(
        child: kIsWeb
            ? Image.network(
                Uri.base.resolve('images/urbur_logo.png').toString(),
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _fallbackIcon(context),
              )
            : Image.asset(
                AppAssets.logo,
                height: height,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _fallbackIcon(context),
              ),
      ),
    );
  }

  Widget _fallbackIcon(BuildContext context) {
    return Icon(
      Icons.image_outlined,
      size: height,
      color: Theme.of(context).appBarTheme.foregroundColor,
    );
  }
}
