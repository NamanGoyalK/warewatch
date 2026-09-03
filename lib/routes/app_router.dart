import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_state.dart';
import 'package:warewatch/features/auth/presentation/auth_screen.dart';
import 'package:warewatch/features/home/presentation/home_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isLoggedIn = authCubit.state is AuthAuthenticated;
      final location = state.matchedLocation;
      final isAuthRoute =
          location == '/login' ||
          location == '/signup' ||
          location == '/forgot-password';

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      if (!isLoggedIn && location == '/home') {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) =>
            const AuthScreen(initialMode: AuthMode.signUp),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) =>
            const AuthScreen(initialMode: AuthMode.forgotPassword),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Something went wrong.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
