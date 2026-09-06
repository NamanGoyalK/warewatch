import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/core/theme/app_theme.dart';

class SettingsInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsInfoTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurfaceVar
                  : AppTheme.lightSurfaceVar,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 20, color: colorScheme.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );

    return Column(
      children: [
        if (onTap != null)
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: content,
          )
        else
          content,
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
      ],
    );
  }
}
