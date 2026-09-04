import 'package:flutter/material.dart';

class AtmosphericBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final bool showDots;
  final bool showGlow;
  final double glowHeight;

  const AtmosphericBackground({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.showDots = true,
    this.showGlow = true,
    this.glowHeight = 480,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Base Canvas
        ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),

        // 2. Micro-Dot Texture
        if (showDots)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _DotPainter(
                  dotColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.10),
                  spacing: 24,
                  radius: 1.3,
                ),
              ),
            ),
          ),

        // 3. Anchored Horizon Glow
        if (showGlow)
          Positioned(
            top: -120,
            left: -60,
            right: -60,
            height: glowHeight,
            child: RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.onSurface.withValues(
                        alpha: isDark ? 0.08 : 0.05,
                      ),
                      colorScheme.onSurface.withValues(
                        alpha: isDark ? 0.04 : 0.02,
                      ),
                      Colors.transparent,
                    ],
                    stops: const [0.3, 0.65, 1.0],
                  ),
                ),
              ),
            ),
          ),

        // 4. Foreground Content
        Positioned.fill(child: useSafeArea ? SafeArea(child: child) : child),
      ],
    );
  }
}

class _DotPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double radius;

  const _DotPainter({
    required this.dotColor,
    required this.spacing,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor ||
      oldDelegate.spacing != spacing ||
      oldDelegate.radius != radius;
}
