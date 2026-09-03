import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warewatch/common/widgets/atmospheric_background.dart';
import 'package:warewatch/features/home/presentation/cubits/home_navigation_cubit.dart';
import 'package:warewatch/features/home/presentation/widgets/home_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeNavigationCubit(initialIndex: navigationShell.currentIndex),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            const AtmosphericBackground(child: SizedBox.expand()),
            SafeArea(bottom: false, child: navigationShell),
          ],
        ),
        bottomNavigationBar: HomeNavigationBar(
          navigationShell: navigationShell,
        ),
      ),
    );
  }
}
