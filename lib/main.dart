import 'dart:async';
import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/widgets/auth_gate.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
    } catch (e, st) {
      debugPrint('[BOOT] Firebase.init failed: $e\n$st');
    }

    FlutterError.onError = (details) {
      debugPrint('[FLUTTER_ERR] ${details.exceptionAsString()}');
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('[PLATFORM_ERR] $error\n$stack');
      return true;
    };

    runApp(
      const ProviderScope(
        child: GroceryApp(),
      ),
    );
  }, (e, st) {
    debugPrint('[ZONE_ERR] Top-level: $e\n$st');
  });
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
