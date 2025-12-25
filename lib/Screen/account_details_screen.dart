import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Theme/theme.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import '../Utils/snackbar_utils.dart';
import '../l10n/app_localizations.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _nameController.text = _user?.displayName ?? '';
    _emailController.text = _user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      if (_nameController.text.trim() != _user?.displayName) {
        await _user?.updateDisplayName(_nameController.text.trim());
      }

      if (_emailController.text.trim().isNotEmpty &&
          _emailController.text.trim() != _user?.email) {
        await _user?.verifyBeforeUpdateEmail(_emailController.text.trim());
        if (mounted) {
          SnackBarUtils.showSuccess(
              context,
              AppLocalizations.of(context)!
                  .translate('email_verification_sent'));
        }
      }

      if (_passwordController.text.isNotEmpty) {
        await _user?.updatePassword(_passwordController.text);
        if (mounted) {
          SnackBarUtils.showSuccess(context,
              AppLocalizations.of(context)!.translate('password_updated'));
        }
        _passwordController.clear();
      }

      await _user?.reload();
      if (mounted) {
        setState(() {
          _user = FirebaseAuth.instance.currentUser;
        });
        SnackBarUtils.showSuccess(context,
            AppLocalizations.of(context)!.translate('profile_updated'));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'requires-recent-login') {
          SnackBarUtils.showError(context,
              AppLocalizations.of(context)!.translate('relogin_required'));
        } else {
          SnackBarUtils.showError(context, 'Hata: ${e.message}');
        }
      }
    } catch (e) {
      if (mounted) SnackBarUtils.showError(context, 'Bilinmeyen hata: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('account_details')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF2C2C2C),
              child: Icon(Icons.person, size: 40, color: AppColors.accent),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(
                AppLocalizations.of(context)!.translate('profile_info')),
            CustomTextField(
              controller: _nameController,
              hintText:
                  AppLocalizations.of(context)!.translate('full_name_hint'),
              textCapitalization: TextCapitalization.words,
            ),
            _buildSectionHeader(
                AppLocalizations.of(context)!.translate('email_header')),
            CustomTextField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.translate('email_hint'),
              keyboardType: TextInputType.emailAddress,
            ),
            _buildSectionHeader(
                AppLocalizations.of(context)!.translate('password_header')),
            CustomTextField(
              controller: _passwordController,
              hintText:
                  AppLocalizations.of(context)!.translate('password_hint'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppLocalizations.of(context)!.translate('save_changes'),
              onPressed: _updateProfile,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
      ),
    );
  }
}
