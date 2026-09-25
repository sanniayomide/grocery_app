import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_providers.dart';
import '../../domain/models/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_shared.dart';
import 'sign_up_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authStateNotifierProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authStateNotifierProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        final user = next.user;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back, ${user?.displayName ?? user?.email}!',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue shopping for fresh groceries.',
                ),
                AuthErrorMessage(message: authState.errorMessage),
                if (authState.errorMessage != null &&
                    authState.errorMessage!.isNotEmpty)
                  const SizedBox(height: AppDimensions.spaceLg),
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textMuted,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppColors.textMuted,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Password reset coming soon! Check back later.'),
                              ),
                            );
                          },
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                PrimaryButton(
                  text: 'Sign In',
                  onPressed: isLoading ? null : _onSubmit,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                const AuthDivider(),
                const SizedBox(height: AppDimensions.spaceXl),
                Row(
                  children: [
                    Expanded(
                      child: _GooglePlaceholderButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Google Sign-In coming soon! Use email/password for now.'),
                                    ),
                                  );
                                }),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: _ApplePlaceholderButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Apple Sign-In coming soon! Use email/password for now.'),
                                    ),
                                  );
                                }),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXxl * 1.5),
                AuthFooterLink(
                  questionText: "Don't have an account?",
                  actionText: 'Sign Up',
                  onTap: isLoading
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                ),
                const SizedBox(height: AppDimensions.spaceXl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GooglePlaceholderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _GooglePlaceholderButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        icon: const Icon(Icons.g_mobiledata_outlined, size: 22),
        label: Text(
          'Google',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _ApplePlaceholderButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _ApplePlaceholderButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        icon: const Icon(Icons.apple_outlined, size: 22),
        label: Text(
          'Apple',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
