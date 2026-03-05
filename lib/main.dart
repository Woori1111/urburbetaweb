import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_wrapper.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

/// 콘텐츠가 비어 있어도 스크롤 가능 + 바깥으로 당겼다 놓으면 탄성 있게 복귀 (웹 포함)
class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      scrollBehavior: _AppScrollBehavior(),
      home: ScrollConfiguration(
        behavior: _AppScrollBehavior(),
        child: const AppWrapper(),
      ),
    );
  }
}
