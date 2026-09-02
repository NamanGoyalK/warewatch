import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/features/auth/presentation/widgets/auth_form_scaffold.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompact = MediaQuery.sizeOf(context).height < 960;

    return AuthFormScaffold(
      title: 'Create account',
      subtitle: 'Join WareWatch and get started',
      children: [
        const AuthFormField(
          label: 'Full name',
          hintText: 'Enter your full name',
        ),
        SizedBox(height: isCompact ? 4 : 16),
        const AuthFormField(
          label: 'Email',
          hintText: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: isCompact ? 4 : 16),
        const AuthFormField(
          label: 'Password',
          hintText: 'Create a password',
          obscureText: true,
        ),
        SizedBox(height: isCompact ? 4 : 16),
        const AuthFormField(
          label: 'Confirm password',
          hintText: 'Repeat your password',
          obscureText: true,
        ),
        SizedBox(height: isCompact ? 8 : 20),
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
            'Sign up',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        SizedBox(height: isCompact ? 4 : 12),
        TextButton(
          onPressed: () => context.goNamed('login'),
          child: const Text(
            'Already have an account? Sign in',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
