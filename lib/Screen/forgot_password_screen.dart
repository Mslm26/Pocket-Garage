import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Theme/theme.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import '../Utils/snackbar_utils.dart';
import '../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (mounted) {
        SnackBarUtils.showSuccess(
          context,
          AppLocalizations.of(context)!.translate('reset_email_sent'),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage =
              AppLocalizations.of(context)!.translate('user_not_found');
        } else if (e.code == 'invalid-email') {
          errorMessage =
              AppLocalizations.of(context)!.translate('invalid_email');
        } else {
          errorMessage =
              AppLocalizations.of(context)!.translate('error_occured');
        }
        SnackBarUtils.showError(context, errorMessage);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(
          context,
          AppLocalizations.of(context)!.translate('unknown_error') +
              e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            AppLocalizations.of(context)!.translate('forgot_password_title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!
                      .translate('forgot_password_header'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!
                      .translate('forgot_password_desc'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _emailController,
                  labelText:
                      AppLocalizations.of(context)!.translate('email_hint'),
                  hintText:
                      AppLocalizations.of(context)!.translate('email_hint'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('fill_required_fields');
                    }
                    if (!value.contains('@')) {
                      return AppLocalizations.of(context)!
                          .translate('invalid_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: AppLocalizations.of(context)!
                      .translate('send_reset_link'),
                  onPressed: _resetPassword,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
