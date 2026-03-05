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
  community(3, '커뮤니티', Icons.groups_rounded),
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

  static final List<Widget> _screens = [
    const HomeScreen(),
    const HallOfFameScreen(),
    const ReflectionScreen(),
    const CommunityScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: JellyBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: NavIndex.values
            .map((nav) => (icon: nav.icon, label: nav.label))
            .toList(),
      ),
    );
  }
}
