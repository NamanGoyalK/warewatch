import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutConfirmDialog extends StatelessWidget {
  const LogoutConfirmDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const LogoutConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      backgroundColor: Theme.of(context).cardTheme.color,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.error.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Sign Out',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to end your current session? You will be disconnected from active surveillance monitoring until you log back in.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: TextStyle(color: colorScheme.onSurface)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
