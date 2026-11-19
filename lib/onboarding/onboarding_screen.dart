import 'package:flutter/material.dart';

import '../widgets/common.dart';

/// A swipeable onboarding flow with skip, animated dots and a final
/// "Get started" button. Edit [_pages] to change the content.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onFinished});

  /// Called when the user taps "Skip" or "Get started".
  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _PageData {
  const _PageData(this.emoji, this.hue, this.title, this.body);

  final String emoji;
  final double hue;
  final String title;
  final String body;
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<_PageData> _pages = [
    _PageData(
      '🚀',
      250,
      'Welcome aboard',
      'Everything you need to plan, track and finish your work, in one simple app.',
    ),
    _PageData(
      '📊',
      160,
      'See your progress',
      'Beautiful charts and summaries show how far you have come each week.',
    ),
    _PageData(
      '🔔',
      30,
      'Stay on track',
      'Gentle reminders keep you moving, and you decide when to hear from us.',
    ),
    _PageData(
      '🎉',
      330,
      'Ready when you are',
      'Create your free account in under a minute and start right away.',
    ),
  ];

  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      widget.onFinished();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 12, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLast ? 0 : 1,
                  child: TextButton(
                    onPressed: _isLast ? null : widget.onFinished,
                    child: const Text('Skip'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardingPage(data: _pages[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: i == _index ? 26 : 8,
                    decoration: BoxDecoration(
                      color: i == _index ? primary : context.border,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _isLast ? 'Get started' : 'Continue',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientTile(
              hue: data.hue,
              height: 260,
              radius: 36,
              child: Text(data.emoji, style: const TextStyle(fontSize: 96)),
            ),
            const SizedBox(height: 32),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Text(
              data.body,
              textAlign: TextAlign.center,
              style: text.bodyLarge?.copyWith(color: context.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
