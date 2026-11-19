import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Editable profile data shared by the profile screens.
class ProfileData {
  ProfileData({required this.name, required this.email, required this.bio, required this.city});

  String name;
  String email;
  String bio;
  String city;
}

/// Profile page with stats, quick actions and links to edit and settings.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileData _data = ProfileData(
    name: 'Leni Junior',
    email: 'leni@example.com',
    bio: 'Mobile developer. I build and share free UI kits.',
    city: 'Jaboatão dos Guararapes, PE',
  );

  Future<void> _edit() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EditProfileScreen(data: _data)),
    );
    if (!mounted) return;
    setState(() {});
  }

  void _settings() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(tooltip: 'Settings', onPressed: _settings, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Center(child: Avatar(name: _data.name, size: 96, hue: 260)),
          const SizedBox(height: 14),
          Text(
            _data.name,
            textAlign: TextAlign.center,
            style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            _data.email,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: context.muted),
          ),
          const SizedBox(height: 10),
          Text(
            _data.bio,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(height: 1.4),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place_outlined, size: 16, color: context.muted),
              const SizedBox(width: 4),
              Text(_data.city, style: TextStyle(color: context.muted)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: _Stat('128', 'Posts')),
              SizedBox(width: 10),
              Expanded(child: _Stat('4.2k', 'Followers')),
              SizedBox(width: 10),
              Expanded(child: _Stat('312', 'Following')),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _edit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit profile'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader('Account'),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(icon: Icons.favorite_border, label: 'Saved items', onTap: () {}),
                const Divider(height: 1),
                _MenuTile(icon: Icons.receipt_long_outlined, label: 'Orders', onTap: () {}),
                const Divider(height: 1),
                _MenuTile(icon: Icons.credit_card, label: 'Payment methods', onTap: () {}),
                const Divider(height: 1),
                _MenuTile(icon: Icons.help_outline, label: 'Help center', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: context.muted)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// Form to edit the profile with validation.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.data});

  final ProfileData data;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.data.name);
  late final TextEditingController _email = TextEditingController(text: widget.data.email);
  late final TextEditingController _city = TextEditingController(text: widget.data.city);
  late final TextEditingController _bio = TextEditingController(text: widget.data.bio);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _city.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_form.currentState?.validate() ?? false)) return;
    widget.data.name = _name.text.trim();
    widget.data.email = _email.text.trim();
    widget.data.city = _city.text.trim();
    widget.data.bio = _bio.text.trim();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Center(child: Avatar(name: _name.text, size: 88, hue: 260)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your name' : null,
              decoration: fieldDecoration(context, 'Name', Icons.person_outline),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                final value = (v ?? '').trim();
                return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value) ? null : 'Enter a valid email';
              },
              decoration: fieldDecoration(context, 'Email', Icons.mail_outline),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _city,
              textInputAction: TextInputAction.next,
              decoration: fieldDecoration(context, 'City', Icons.place_outlined),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bio,
              maxLines: 3,
              maxLength: 120,
              decoration: fieldDecoration(context, 'Bio', Icons.notes),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings with a working dark mode switch and a few demo toggles.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;
  bool _email = false;
  bool _biometric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const SectionHeader('Appearance'),
          AppCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              title: const Text('Dark mode', style: TextStyle(fontWeight: FontWeight.w600)),
              secondary: const Icon(Icons.dark_mode_outlined),
              value: context.isDark,
              onChanged: (v) => themeMode.value = v ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader('Notifications'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: const Icon(Icons.notifications_none),
                  value: _push,
                  onChanged: (v) => setState(() => _push = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Email updates', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: const Icon(Icons.mail_outline),
                  value: _email,
                  onChanged: (v) => setState(() => _email = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader('Security'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Biometric unlock', style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: const Icon(Icons.fingerprint),
                  value: _biometric,
                  onChanged: (v) => setState(() => _biometric = v),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change password', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
