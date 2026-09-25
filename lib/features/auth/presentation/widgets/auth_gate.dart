import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../../domain/models/auth_state.dart';
import '../screens/sign_in_screen.dart';
import '../../../app_shell/app_shell.dart';
import '../../../../core/theme/theme.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const _SplashLoader();
      case AuthStatus.authenticated:
        return const AppShell();
      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const SignInScreen();
    }
  }
}

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                color: AppColors.textOnPrimary,
                size: 44,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXl),
            Text(
              'Grocery App',
              style: AppTypography.h1,
            ),
            const SizedBox(height: AppDimensions.spaceXl),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
