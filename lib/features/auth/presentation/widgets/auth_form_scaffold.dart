import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/common/widgets/cctv_background.dart';

class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.titleStyle,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360 || screenHeight < 700;
    final cardPadding = isCompact ? 18.0 : 24.0;
    final outerPadding = isCompact ? 10.0 : 24.0;
    final headerSpacing = isCompact ? 10.0 : 18.0;
    final titleFontSize = isCompact ? 26.0 : 32.0;
    final sectionGap = isCompact ? 16.0 : 28.0;

    return Scaffold(
      body: Stack(
        children: [
          const CctvBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(outerPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isCompact ? 22 : 28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        padding: EdgeInsets.all(cardPadding),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.surface.withValues(alpha: 0.16),
                              colorScheme.surface.withValues(alpha: 0.08),
                              colorScheme.surface.withValues(alpha: 0.12),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            isCompact ? 22 : 28,
                          ),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.28),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 8 : 12,
                                vertical: isCompact ? 5 : 8,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: isCompact ? 16 : 24,
                                      height: 1,
                                      color: colorScheme.tertiary.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                    SizedBox(width: isCompact ? 5 : 10),
                                    Text(
                                      'ACCESS PANEL',
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.8,
                                        ),
                                        letterSpacing: isCompact ? 1.2 : 2.2,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: isCompact ? 5 : 10),
                                    Container(
                                      width: isCompact ? 16 : 24,
                                      height: 1,
                                      color: colorScheme.tertiary.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: headerSpacing),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style:
                                  titleStyle ??
                                  GoogleFonts.montserrat(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                    letterSpacing: isCompact ? 0.6 : 1.2,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.75,
                                ),
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: sectionGap),
                            ...children,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).height < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: isCompact ? 6 : 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            filled: true,
            fillColor: colorScheme.surface.withValues(alpha: 0.07),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isCompact ? 12 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.18),
                width: 1.1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.tertiary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
