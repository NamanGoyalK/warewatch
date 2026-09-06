import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:warewatch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'package:warewatch/core/theme/theme_cubit.dart';
import 'package:warewatch/routes/app_router.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthRepositoryImpl _authRepository;
  late final AuthCubit _authCubit;
  late final ThemeCubit _themeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl();
    _authCubit = AuthCubit(_authRepository);
    _themeCubit = ThemeCubit();
    _router = createAppRouter(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    _themeCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final platformBrightness =
              MediaQuery.maybePlatformBrightnessOf(context) ?? Brightness.dark;
          final isDark =
              themeMode == ThemeMode.dark ||
              (themeMode == ThemeMode.system &&
                  platformBrightness == Brightness.dark);

          final systemOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarDividerColor: Colors.transparent,
            systemStatusBarContrastEnforced: false,
            systemNavigationBarContrastEnforced: false,
          );

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: systemOverlayStyle,
            child: MaterialApp.router(
              title: 'WareWatch',
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeMode,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}
