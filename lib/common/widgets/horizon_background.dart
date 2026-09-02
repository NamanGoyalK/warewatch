import 'package:flutter/material.dart';

class HorizonBackground extends StatelessWidget {
  final Widget child;
  const HorizonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? const Color(0xFFE6196E) : const Color(0xFFBE0959);
    final secondary = isDark
        ? const Color(0xFF00A3FF)
        : const Color(0xFF0089CF);

    return Stack(
      children: [
        // Solid base canvas
        Container(color: Theme.of(context).scaffoldBackgroundColor),

        // Atmospheric top glow
        Positioned(
          top: -80,
          left: -40,
          right: -40,
          height: 320,
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.6),
                  radius: 1.1,
                  colors: [
                    primary.withAlpha(isDark ? 45 : 30),
                    secondary.withAlpha(isDark ? 20 : 15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
