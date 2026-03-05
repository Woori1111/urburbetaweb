import 'package:flutter/material.dart';

import 'features/community/community_screen.dart';
import 'features/hall_of_fame/hall_of_fame_screen.dart';
import 'features/home/home_screen.dart';
import 'features/menu/menu_screen.dart';
import 'features/reflection/reflection_screen.dart';
import 'shared/widgets/jelly_bottom_nav.dart';

/// 하단 네비게이션 인덱스
enum NavIndex {
  home(0, '홈', Icons.home_rounded),
  hallOfFame(1, '명예의전당', Icons.emoji_events_rounded),
  reflection(2, '반성문', Icons.edit_note_rounded),
  community(3, '대나무숲', Icons.forest_rounded),
  menu(4, '메뉴', Icons.menu_rounded);

  const NavIndex(this.tabIndex, this.label, this.icon);
  final int tabIndex;
  final String label;
  final IconData icon;
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  static final _navItems = NavIndex.values
      .map((nav) => (icon: nav.icon, label: nav.label))
      .toList();

  List<Widget> _buildScreens() => [
    RepaintBoundary(child: HomeScreen(currentIndex: _currentIndex, tabIndex: 0)),
    RepaintBoundary(child: HallOfFameScreen(currentIndex: _currentIndex, tabIndex: 1)),
    RepaintBoundary(child: ReflectionScreen(currentIndex: _currentIndex, tabIndex: 2)),
    RepaintBoundary(child: CommunityScreen(currentIndex: _currentIndex, tabIndex: 3)),
    RepaintBoundary(child: MenuScreen(currentIndex: _currentIndex, tabIndex: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: JellyBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}
