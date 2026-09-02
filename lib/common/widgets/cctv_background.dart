import 'dart:async';
import 'package:flutter/material.dart';

class CctvBackground extends StatefulWidget {
  final Widget? child;

  const CctvBackground({super.key, this.child});

  @override
  State<CctvBackground> createState() => _CctvBackgroundState();
}

class _CctvBackgroundState extends State<CctvBackground>
    with TickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final AnimationController _sweepController;
  late final Timer _timer;

  DateTime _now = DateTime.now();
  bool _isNightVision = false;

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _sweepController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatDigits(int n) => n.toString().padLeft(2, '0');

  void _toggleNightVision() {
    setState(() {
      _isNightVision = !_isNightVision;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Hook directly into your AppTheme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 2. Map HUD colors to theme tokens
    final themeColor = _isNightVision
        ? colorScheme.primary
        : colorScheme.onSurface;
    final recColor = _isNightVision ? colorScheme.primary : colorScheme.error;

    // 3. Create a vignette using your scaffold and surface colors
    final bgCenter = theme.scaffoldBackgroundColor;
    final bgEdge = Color.alphaBlend(
      colorScheme.onSurface.withAlpha(15),
      theme.scaffoldBackgroundColor,
    );

    final rasterColor = colorScheme.onSurface.withAlpha(
      _isNightVision ? 40 : 15,
    );

    final timestamp =
        '${_now.year}-${_formatDigits(_now.month)}-${_formatDigits(_now.day)} '
        '${_formatDigits(_now.hour)}:${_formatDigits(_now.minute)}:${_formatDigits(_now.second)}';

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Monitor Base with Theme Vignette
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [bgCenter, bgEdge],
                ),
              ),
            ),

            // Static CRT Raster scanlines
            Positioned.fill(
              child: CustomPaint(
                painter: _CctvRasterPainter(rasterColor: rasterColor),
              ),
            ),

            // Animated Sweeping Scanline
            AnimatedBuilder(
              animation: _sweepController,
              builder: (context, child) {
                return Positioned(
                  top: constraints.maxHeight * _sweepController.value - 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          themeColor.withAlpha(0),
                          themeColor.withAlpha(20),
                          themeColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Safe Area constrained HUD and Telemetry
            SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Viewfinder brackets & crosshair
                  CustomPaint(painter: _CctvHudPainter(color: themeColor)),

                  // Telemetry Overlay
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 12, 36, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Telemetry (Aligned Centers)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FadeTransition(
                                  opacity: _blinkController,
                                  child: Icon(
                                    Icons.fiber_manual_record,
                                    color: recColor,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'REC',
                                  style: TextStyle(
                                    color: themeColor,
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'CAM 01 [LIVE]',
                                  style: TextStyle(
                                    color: themeColor.withAlpha(179),
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    _isNightVision
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: themeColor.withAlpha(204),
                                    size: 20,
                                  ),
                                  onPressed: _toggleNightVision,
                                  tooltip: 'Toggle Night Vision',
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Bottom Telemetry
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _isNightVision
                                  ? 'IR MODE // ON'
                                  : 'HD 1080P // 30FPS',
                              style: TextStyle(
                                color: themeColor.withAlpha(128),
                                fontFamily: 'monospace',
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              timestamp,
                              style: TextStyle(
                                color: themeColor.withAlpha(179),
                                fontFamily: 'monospace',
                                fontSize: 12,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Optional foreground content passed through child
            if (widget.child != null) widget.child!,
          ],
        );
      },
    );
  }
}

class _CctvRasterPainter extends CustomPainter {
  final Color rasterColor;

  const _CctvRasterPainter({required this.rasterColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rasterPaint = Paint()
      ..color = rasterColor
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.height; i += 4.0) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), rasterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CctvRasterPainter oldDelegate) {
    return rasterColor != oldDelegate.rasterColor;
  }
}

class _CctvHudPainter extends CustomPainter {
  final Color color;

  const _CctvHudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final hudPaint = Paint()
      ..color = color.withAlpha(128)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const margin = 16.0;
    const bracketLen = 22.0;

    // Top-Left
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin + bracketLen, margin),
      hudPaint,
    );
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin, margin + bracketLen),
      hudPaint,
    );

    // Top-Right
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - bracketLen, margin),
      hudPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + bracketLen),
      hudPaint,
    );

    // Bottom-Left
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + bracketLen, size.height - margin),
      hudPaint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - bracketLen),
      hudPaint,
    );

    // Bottom-Right
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - bracketLen, size.height - margin),
      hudPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - bracketLen),
      hudPaint,
    );

    // Center Crosshair
    final center = Offset(size.width / 2, size.height / 2);
    const crossSize = 10.0;
    const gap = 4.0;

    canvas.drawLine(
      Offset(center.dx - crossSize, center.dy),
      Offset(center.dx - gap, center.dy),
      hudPaint,
    );
    canvas.drawLine(
      Offset(center.dx + gap, center.dy),
      Offset(center.dx + crossSize, center.dy),
      hudPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - crossSize),
      Offset(center.dx, center.dy - gap),
      hudPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + gap),
      Offset(center.dx, center.dy + crossSize),
      hudPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CctvHudPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
