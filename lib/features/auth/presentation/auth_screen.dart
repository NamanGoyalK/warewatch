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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
        return 'Welcome back';
      case AuthMode.signUp:
        return 'Create account';
      case AuthMode.forgotPassword:
        return 'Reset password';
    }
  }

  String _subtitleForMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.signIn:
        return 'Sign in to continue';
      case AuthMode.signUp:
        return 'Join WareWatch and get started';
      case AuthMode.forgotPassword:
        return 'We will send a reset link to your email';
    }
  }

  Widget _buildAuthBody(BuildContext context, AuthState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = state is AuthLoading;
    final isCompact = MediaQuery.sizeOf(context).height < 960;

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
            SizedBox(height: isCompact ? 8 : 14),
            AuthFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
            ),
            SizedBox(height: isCompact ? 6 : 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => _setMode(AuthMode.forgotPassword),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: isCompact ? 4 : 6),
            ElevatedButton(
              onPressed: isLoading ? null : _submitSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
            SizedBox(height: isCompact ? 10 : 16),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
            SizedBox(height: isCompact ? 10 : 16),
            OutlinedButton(
              onPressed: isLoading
                  ? null
                  : () => context.read<AuthCubit>().signInWithGoogle(),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.onSurface.withValues(alpha: 0.28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Image(
                    image: AssetImage('assets/icons/google_logo.png'),
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 12),
                  Text('Continue with Google'),
                ],
              ),
            ),
            SizedBox(height: isCompact ? 6 : 10),
            TextButton(
              onPressed: isLoading ? null : () => _setMode(AuthMode.signUp),
              child: const Text(
                'Create an account',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
            SizedBox(height: isCompact ? 4 : 16),
            AuthFormField(
              controller: _emailController,
              label: 'Email',
              hintText: 'name@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: isCompact ? 4 : 16),
            AuthFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Create a password',
              obscureText: true,
            ),
            SizedBox(height: isCompact ? 4 : 16),
            AuthFormField(
              controller: _confirmPasswordController,
              label: 'Confirm password',
              hintText: 'Repeat your password',
              obscureText: true,
            ),
            SizedBox(height: isCompact ? 8 : 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submitSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
            SizedBox(height: isCompact ? 4 : 12),
            TextButton(
              onPressed: isLoading ? null : () => _setMode(AuthMode.signIn),
              child: const Text(
                'Already have an account? Sign in',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submitForgotPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Text(
                      'Send reset link',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: isLoading ? null : () => _setMode(AuthMode.signIn),
              child: const Text(
                'Back to sign in',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
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
