import 'package:flutter/material.dart';

class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
              ],
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -80,
          child: _GlowBlob(color: scheme.secondary.withAlpha(164)),
        ),
        Positioned(
          bottom: -140,
          left: -60,
          child: _GlowBlob(color: scheme.tertiary.withAlpha(156)),
        ),
        Positioned(
          top: 120,
          left: -90,
          child: _GlowBlob(color: scheme.primary.withAlpha(146)),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final Color color;

  const _GlowBlob({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color, blurRadius: 320, spreadRadius: 200),
        ],
      ),
    );
  }
}
