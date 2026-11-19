import 'package:flutter/material.dart';

import 'chat/chat_list_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'profile/profile_screen.dart';
import 'shop/shop_home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/common.dart';

void main() => runApp(const UiKitsApp());

class UiKitsApp extends StatelessWidget {
  const UiKitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Flutter UI Kits',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: const GalleryScreen(),
        );
      },
    );
  }
}

class _Kit {
  const _Kit(this.title, this.subtitle, this.emoji, this.hue, this.builder);

  final String title;
  final String subtitle;
  final String emoji;
  final double hue;
  final WidgetBuilder builder;
}

/// Home screen that lists every kit. Tap one to open it.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kits = <_Kit>[
      _Kit(
        'Onboarding',
        '4 swipeable intro pages with skip and animated dots',
        '🚀',
        250,
        (ctx) => OnboardingScreen(onFinished: () => Navigator.of(ctx).pop()),
      ),
      _Kit(
        'Shop',
        'Home, product details, cart with promo code and checkout',
        '🛍️',
        30,
        (ctx) => const ShopHomeScreen(),
      ),
      _Kit(
        'Chat',
        'Conversation list, stories row and a live chat screen',
        '💬',
        160,
        (ctx) => const ChatListScreen(),
      ),
      _Kit(
        'Profile',
        'Profile, edit form and a full settings screen',
        '👤',
        330,
        (ctx) => const ProfileScreen(),
      ),
    ];
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Flutter UI Kits',
                    style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  tooltip: 'Toggle dark mode',
                  onPressed: () {
                    themeMode.value = context.isDark ? ThemeMode.light : ThemeMode.dark;
                  },
                  icon: Icon(context.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Free, copy-and-paste screens for your next app. No packages needed.',
              style: text.bodyMedium?.copyWith(color: context.muted),
            ),
            const SizedBox(height: 24),
            for (final kit in kits) ...[
              AppCard(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: kit.builder));
                },
                child: Row(
                  children: [
                    GradientTile(
                      hue: kit.hue,
                      width: 64,
                      height: 64,
                      child: Text(kit.emoji, style: const TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kit.title,
                            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            kit.subtitle,
                            style: text.bodySmall?.copyWith(color: context.muted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
