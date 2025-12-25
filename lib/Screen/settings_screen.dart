import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providers/settings_provider.dart';
import '../Theme/theme.dart';
import 'account_details_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final isDark = settingsState.themeMode == ThemeMode.dark;
    final isTr = settingsState.locale.languageCode == 'tr';

    return Scaffold(
      appBar: AppBar(
        title: Text(isTr ? 'Ayarlar' : 'Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, isTr ? 'Görünüm' : 'Appearance'),
          _buildSettingsTile(
            context,
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            title: isTr ? 'Karanlık Mod' : 'Dark Mode',
            trailing: Switch(
              value: isDark,
              activeThumbColor: AppColors.accent,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).toggleTheme(val);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, isTr ? 'Dil' : 'Language'),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: isTr ? 'Türkçe' : 'English',
            subtitle: isTr
                ? 'Dili değiştirmek için dokunun'
                : 'Tap to change language',
            trailing: Switch(
              value: isTr,
              activeThumbColor: AppColors.accent,
              onChanged: (val) {
                ref
                    .read(settingsProvider.notifier)
                    .setLanguage(val ? 'tr' : 'en');
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, isTr ? 'Hesap' : 'Account'),
          _buildSettingsTile(
            context,
            icon: Icons.person,
            title: isTr ? 'Hesap Detayları' : 'Account Details',
            subtitle:
                isTr ? 'Ad, Şifre vb. değiştir' : 'Change Name, Password etc.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AccountDetailsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(height: 48),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: isTr ? 'Çıkış Yap' : 'Log Out',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? theme.primaryColor).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor ?? theme.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
