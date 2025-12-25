import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Screen/login_screen.dart';
import 'Screen/my_garage_screen.dart';
import 'Screen/verify_email_screen.dart';
import 'Theme/theme.dart';
import 'firebase_options.dart';
import 'Utils/notification_service.dart';
import 'Providers/settings_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("HATA - Firebase Başlatılamadı: $e");
  }

  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  await initializeDateFormatting('tr_TR', null);

  await NotificationService().init();

  runApp(
    const ProviderScope(
      child: PocketGarageApp(),
    ),
  );
}

class PocketGarageApp extends ConsumerWidget {
  const PocketGarageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Pocket Garage',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      locale: settings.locale,
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;

          if (user.emailVerified) {
            return const MyGarageScreen();
          } else {
            return const VerifyEmailScreen();
          }
        }

        return const LoginScreen();
      },
    );
  }
}
