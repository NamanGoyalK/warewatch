import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/features/auth/presentation/widgets/auth_form_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AuthFormScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to continue',
      children: [
        const AuthFormField(
          label: 'Email',
          hintText: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AuthFormField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.pushNamed('forgot-password'),
            child: const Text(
              'Forgot password?',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () {},
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
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.pushNamed('signup'),
          child: const Text(
            'Create an account',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
