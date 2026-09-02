import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/features/auth/presentation/widgets/auth_form_scaffold.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_state.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompact = MediaQuery.sizeOf(context).height < 960;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // navigate to home or root
          context.goNamed('home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: AuthFormScaffold(
        title: 'Welcome back',
        subtitle: 'Sign in to continue',
        children: [
          AuthFormField(
            controller: emailController,
            label: 'Email',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: isCompact ? 8 : 14),
          AuthFormField(
            controller: passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
          ),
          SizedBox(height: isCompact ? 6 : 10),
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
          SizedBox(height: isCompact ? 4 : 6),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        final email = emailController.text.trim();
                        final password = passwordController.text;
                        context.read<AuthCubit>().signInWithEmail(
                          email,
                          password,
                        );
                      },
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
              );
            },
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
            onPressed: () {
              context.read<AuthCubit>().signInWithGoogle();
            },
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
            onPressed: () => context.pushNamed('signup'),
            child: const Text(
              'Create an account',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
