import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bar_logo.dart';
import '../../shared/widgets/scale_opacity_pressed.dart';
import '../../shared/widgets/screen_reveal_wrapper.dart';
import '../auth/login_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final profileCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.graySurfaceVariant,
              backgroundImage: user?.userMetadata?['avatar_url'] != null
                  ? NetworkImage(user!.userMetadata!['avatar_url'] as String)
                  : null,
              child: user == null
                  ? Icon(Icons.person_rounded, size: 40, color: AppColors.grayMuted)
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              user != null
                  ? (user.userMetadata?['name'] as String? ?? user.email ?? '사용자')
                  : '로그인이 필요해요',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (user?.email != null) ...[
              const SizedBox(height: 4),
              Text(
                user!.email!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            if (user == null)
              ScaleOpacityPressed(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: IgnorePointer(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login_rounded, size: 20),
                    label: const Text('로그인'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: AppColors.grayOnSurface,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              )
            else
              ScaleOpacityPressed(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut();
                },
                child: IgnorePointer(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text('로그아웃'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.yellowDark,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const AppBarLogo(),
        title: const SizedBox.shrink(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ScreenRevealWrapper(
          skeletonCardCount: 2,
          contentCards: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: profileCard,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOfficersCard(context),
                  const SizedBox(height: 16),
                  _buildMenuList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfficersCard(BuildContext context) {
    // 임원진 목록 (이미지 URL·이름은 추후 연동)
    const officers = [
      _Officer(name: '임원1', imageUrl: null),
      _Officer(name: '임원2', imageUrl: null),
      _Officer(name: '임원3', imageUrl: null),
      _Officer(name: '임원4', imageUrl: null),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                '임원진',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: officers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final o = officers[index];
                  return _OfficerChip(name: o.name, imageUrl: o.imageUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final items = [
      _MenuItem(icon: Icons.people_rounded, title: '역대 임원진', onTap: () {}),
      _MenuItem(icon: Icons.music_note_rounded, title: '음원', onTap: () {}),
      _MenuItem(icon: Icons.play_circle_rounded, title: '유튜브', onTap: () {}),
    ];

    return Card(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            ListTile(
              leading: Icon(items[i].icon, color: AppColors.yellowDark, size: 24),
              title: Text(items[i].title),
              trailing: Icon(Icons.chevron_right_rounded, color: AppColors.grayMuted),
              onTap: items[i].onTap,
            ),
          ],
        ],
      ),
    );
  }
}

class _Officer {
  const _Officer({required this.name, this.imageUrl});
  final String name;
  final String? imageUrl;
}

class _OfficerChip extends StatelessWidget {
  const _OfficerChip({required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.graySurfaceVariant,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : null,
          child: imageUrl == null || imageUrl!.isEmpty
              ? Icon(Icons.person_rounded, size: 28, color: AppColors.grayMuted)
              : null,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 56,
          child: Text(
            name,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
}
