import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_state.dart';
import 'package:warewatch/features/auth/presentation/widgets/auth_form_scaffold.dart';

enum AuthMode { signIn, signUp, forgotPassword }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signIn});

  final AuthMode initialMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthMode _mode;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _setMode(AuthMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> _submitSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    await context.read<AuthCubit>().signInWithEmail(email, password);
  }

  Future<void> _submitSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final fullName = _fullNameController.text.trim();

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    await context.read<AuthCubit>().registerWithEmail(
      email,
      password,
      displayName: fullName.isEmpty ? null : fullName,
    );
  }

  Future<void> _submitForgotPassword() async {
    final email = _emailController.text.trim();
    await context.read<AuthCubit>().sendPasswordResetEmail(email);
  }

  String _titleForMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.signIn:
        return 'Sign in';
      case AuthMode.signUp:
        return 'Create account';
      case AuthMode.forgotPassword:
        return 'Reset password';
    }
  }

  String _subtitleForMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.signIn:
        return 'Continue to your warehouse console.';
      case AuthMode.signUp:
        return 'Set up access for your facility.';
      case AuthMode.forgotPassword:
        return 'We’ll email a reset link to your inbox.';
    }
  }

  Widget _buildAuthBody(BuildContext context, AuthState state) {
    final isLoading = state is AuthLoading;

    switch (_mode) {
      case AuthMode.signIn:
        return Column(
          key: const ValueKey(AuthMode.signIn),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthFormField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: _AuthTextAction(
                label: 'Forgot password?',
                onPressed: isLoading
                    ? null
                    : () => _setMode(AuthMode.forgotPassword),
              ),
            ),
            const SizedBox(height: 16),
            _AuthPrimaryButton(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: _submitSignIn,
            ),
            const SizedBox(height: 20),
            const _AuthDivider(),
            const SizedBox(height: 20),
            _AuthGoogleButton(
              isLoading: isLoading,
              onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
            ),
            const SizedBox(height: 8),
            _AuthTextAction(
              label: 'Create an account',
              onPressed: isLoading ? null : () => _setMode(AuthMode.signUp),
            ),
          ],
        );
      case AuthMode.signUp:
        return Column(
          key: const ValueKey(AuthMode.signUp),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthFormField(
              controller: _fullNameController,
              label: 'Full name',
              hintText: 'Enter your full name',
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Create a password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AuthFormField(
              controller: _confirmPasswordController,
              label: 'Confirm password',
              hintText: 'Repeat your password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _AuthPrimaryButton(
              label: 'Create account',
              isLoading: isLoading,
              onPressed: _submitSignUp,
            ),
            const SizedBox(height: 8),
            _AuthTextAction(
              label: 'Already have an account? Sign in',
              onPressed: isLoading ? null : () => _setMode(AuthMode.signIn),
            ),
          ],
        );
      case AuthMode.forgotPassword:
        return Column(
          key: const ValueKey(AuthMode.forgotPassword),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthFormField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            _AuthPrimaryButton(
              label: 'Send reset link',
              isLoading: isLoading,
              onPressed: _submitForgotPassword,
            ),
            const SizedBox(height: 8),
            _AuthTextAction(
              label: 'Back to sign in',
              onPressed: isLoading ? null : () => _setMode(AuthMode.signIn),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed('home');
          return;
        }

        if (state is AuthPasswordResetSent) {
          _showMessage('Reset link sent. Check your email inbox.');
          _setMode(AuthMode.signIn);
          return;
        }

        if (state is AuthError) {
          _showMessage(state.message);
        }
      },
      child: AuthFormScaffold(
        title: _titleForMode(_mode),
        subtitle: _subtitleForMode(_mode),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
            child: _buildAuthBody(context, context.watch<AuthCubit>().state),
          ),
        ],
      ),
    );
  }
}

class _AuthPrimaryButton extends StatelessWidget {
  const _AuthPrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.45),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: colorScheme.onPrimary,
              ),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}

class _AuthGoogleButton extends StatelessWidget {
  const _AuthGoogleButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/icons/google_logo.png'),
            width: 18,
            height: 18,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10),
          Text(
            'Continue with Google',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Divider(color: colorScheme.outline.withValues(alpha: 0.55)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: colorScheme.outline.withValues(alpha: 0.55)),
        ),
      ],
    );
  }
}

class _AuthTextAction extends StatelessWidget {
  const _AuthTextAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.1),
      ),
    );
  }
}
