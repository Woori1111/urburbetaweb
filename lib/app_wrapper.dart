import 'package:flutter/material.dart';

import 'app.dart';
import 'features/splash/loading_screen.dart';

/// 로딩 화면 표시 후 메인 앱(하단 네비)으로 전환
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showApp = false;

  void _onLoadingDone() {
    if (mounted) setState(() => _showApp = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showApp) return const App();
    return LoadingScreen(
      duration: const Duration(seconds: 2),
      onDone: _onLoadingDone,
    );
  }
}
