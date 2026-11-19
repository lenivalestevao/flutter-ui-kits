import 'package:flutter/material.dart';

/// Small color helpers so cards, borders and muted text look right in both
/// light and dark mode.
extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get card => isDark ? const Color(0xFF1A1C33) : Colors.white;
  Color get border => isDark ? const Color(0xFF2B2E4F) : const Color(0xFFE7E8F1);
  Color get muted => isDark ? const Color(0xFFA5A9C8) : const Color(0xFF6B6F85);
  Color get soft => isDark ? const Color(0xFF23264A) : const Color(0xFFEEEFF8);
}

/// Up to two initials from a name, for avatars.
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

/// A soft gradient block used in place of photos, so the kits need no assets.
/// Swap it for an Image widget when you have real pictures.
class GradientTile extends StatelessWidget {
  const GradientTile({
    super.key,
    required this.hue,
    this.child,
    this.radius = 16,
    this.height,
    this.width,
  });

  final double hue;
  final Widget? child;
  final double radius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final a = HSLColor.fromAHSL(1, hue % 360, 0.7, dark ? 0.32 : 0.86).toColor();
    final b = HSLColor.fromAHSL(1, (hue + 40) % 360, 0.7, dark ? 0.22 : 0.78).toColor();
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [a, b],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

/// Circle avatar with initials and an optional online dot.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.name,
    this.size = 44,
    this.hue = 250,
    this.online = false,
  });

  final String name;
  final double size;
  final double hue;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final a = HSLColor.fromAHSL(1, hue % 360, 0.65, 0.5).toColor();
    final b = HSLColor.fromAHSL(1, (hue + 40) % 360, 0.65, 0.4).toColor();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [a, b],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              initialsOf(name),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.36,
              ),
            ),
          ),
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.card, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Rounded surface with a thin border. Pass [onTap] to make it tappable.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Material(
      color: context.card,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: context.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Small colored label, for example a category or a status.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withAlpha(30),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Section title with an optional action on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

/// Round icon button that sits on top of images.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.card,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

/// Rounded filled text field decoration used by the forms and search bars.
InputDecoration fieldDecoration(BuildContext context, String label, IconData icon) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: context.border),
  );
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: context.card,
    border: border,
    enabledBorder: border,
  );
}
