import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Theme/theme.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import 'login_screen.dart';
import 'package:flutter/gestures.dart';
import '../l10n/app_localizations.dart';
import 'legal_document_screen.dart';
import '../Utils/snackbar_utils.dart';
import '../Providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_acceptedTerms) {
      SnackBarUtils.showError(
          context, 'Lütfen kullanım şartlarını kabul ediniz.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential =
          await ref.read(authRepositoryProvider).signUpWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text.trim(),
                _nameController.text.trim(),
              );

      if (userCredential.user != null) {
        if (mounted) {
          SnackBarUtils.showSuccess(context,
              'Kayıt başarılı! Hoş geldiniz, ${_nameController.text.trim()}');
          Navigator.of(context).pop();
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Bu email zaten kullanılıyor.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Şifre çok zayıf.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Geçersiz email adresi.';
      } else {
        errorMessage =
            'Kayıt sırasında bir hata oluştu. Lütfen tekrar deneyin.';
      }
      if (mounted) {
        SnackBarUtils.showError(context, errorMessage);
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(
            context, 'Kayıt sırasında bir hata oluştu. Lütfen tekrar deneyin.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Pocket Garage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Adınızı giriniz',
                      labelText: 'Ad',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adınızı giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email adresinizi giriniz',
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Lütfen geçerli bir email adresi giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Şifrenizi giriniz',
                      labelText: 'Şifre',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        } else if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Şifre en az bir büyük harf içermelidir';
                        } else if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Şifre en az bir rakam içermelidir';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Şifrenizi doğrulayın',
                      labelText: 'Şifre Tekrar',
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != _passwordController.text) {
                          return 'Şifreler uyuşmuyor';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          activeColor: AppColors.accent,
                          side:
                              const BorderSide(color: AppColors.secondaryText),
                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: AppColors.secondaryText, fontSize: 12),
                              children: [
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('accept_terms')),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .translate('terms_of_use'),
                                  style: const TextStyle(
                                    color: AppColors.primaryText,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LegalDocumentScreen(
                                            title: AppLocalizations.of(context)!
                                                .translate('terms_of_use'),
                                            content:
                                                AppLocalizations.of(context)!
                                                    .translate('terms_content'),
                                          ),
                                        ),
                                      );
                                    },
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('and')),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .translate('privacy_policy'),
                                  style: const TextStyle(
                                    color: AppColors.primaryText,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LegalDocumentScreen(
                                            title: AppLocalizations.of(context)!
                                                .translate('privacy_policy'),
                                            content: AppLocalizations.of(
                                                    context)!
                                                .translate('privacy_content'),
                                          ),
                                        ),
                                      );
                                    },
                                ),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate('accept_terms_suffix')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Kayıt Ol',
                      onPressed: _signUp,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hesabınız var mı? ',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryText,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                          child: const Text(
                            'Giriş Yap',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
