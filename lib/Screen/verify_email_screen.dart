import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'my_garage_screen.dart';
import '../Theme/theme.dart';
import '../Widgets/custom_button.dart';
import '../Utils/snackbar_utils.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);

      if (mounted) {
        SnackBarUtils.showSuccess(
            context, 'Doğrulama maili tekrar gönderildi.');
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Mail gönderilemedi: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const MyGarageScreen();
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Mail Doğrulama"),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.mark_email_unread_outlined,
                size: 80,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Lütfen E-Postanızı Kontrol Edin",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "${FirebaseAuth.instance.currentUser?.email}",
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text:
                        " adresine bir doğrulama linki gönderdik. Linke tıkladıktan sonra bu sayfa otomatik güncellenecektir.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: "Maili Tekrar Gönder",
              onPressed: canResendEmail ? sendVerificationEmail : () {},
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout, color: AppColors.secondaryText),
              label: const Text(
                "İptal / Çıkış Yap",
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondaryText,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
