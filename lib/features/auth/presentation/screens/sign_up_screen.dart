import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_providers.dart';
import '../../domain/models/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_shared.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please agree to the Terms of Service and Privacy Policy.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await ref.read(authStateNotifierProvider.notifier).signUp(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
        );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters.';
    }
    return null;
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
      return 'Please create a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
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
              'Account created! Welcome, ${user?.displayName ?? user?.email}!',
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
                  title: 'Create Account',
                  subtitle:
                      'Join us today and start shopping for fresh, quality groceries.',
                ),
                AuthErrorMessage(message: authState.errorMessage),
                if (authState.errorMessage != null &&
                    authState.errorMessage!.isNotEmpty)
                  const SizedBox(height: AppDimensions.spaceLg),
                AuthTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  prefixIcon: Icon(
                    Icons.person_outlined,
                    color: AppColors.textMuted,
                    size: AppDimensions.iconMd,
                  ),
                ),
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
                  hint: 'At least 6 characters',
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppColors.textMuted,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                AuthTextField(
                  controller: _confirmController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirm,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: AppDimensions.iconMd,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        onChanged: isLoading
                            ? null
                            : (v) => setState(() => _agreeToTerms = v ?? false),
                        activeColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 1.4,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium,
                          children: [
                            const TextSpan(
                              text: 'I agree to the ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXl),
                PrimaryButton(
                  text: 'Create Account',
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
                                          'Google Sign-Up coming soon! Use email/password for now.'),
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
                                          'Apple Sign-Up coming soon! Use email/password for now.'),
                                    ),
                                  );
                                }),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXxl * 1.5),
                AuthFooterLink(
                  questionText: 'Already have an account?',
                  actionText: 'Sign In',
                  onTap: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
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
