import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:warewatch/features/auth/presentation/cubits/auth_state.dart';

import 'cubits/settings_cubit.dart';
import 'cubits/settings_state.dart';
import 'widgets/account_info_card.dart';
import 'widgets/logout_confirm_dialog.dart';
import 'widgets/preference_switch_tile.dart';
import 'widgets/settings_group_card.dart';
import 'widgets/settings_info_tile.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/theme_selector_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final confirmed = await LogoutConfirmDialog.show(context);
    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backendUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';

    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  // Screen Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkSurfaceVar
                                : AppTheme.lightSurfaceVar,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            size: 24,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Warehouse Surveillance & Operator Preferences',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 11,
                                letterSpacing: 0.5,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 1. ACCOUNT SECTION
                  const SettingsSectionHeader(
                    title: 'Account Profile',
                    icon: Icons.person_outline_rounded,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, authState) {
                      final user = authState is AuthAuthenticated
                          ? authState.user
                          : null;
                      return AccountInfoCard(user: user);
                    },
                  ),

                  // 2. THEME & APPEARANCE SECTION
                  const SettingsSectionHeader(
                    title: 'Appearance',
                    icon: Icons.palette_outlined,
                  ),
                  const ThemeSelectorCard(),

                  // 3. SYSTEM & ALERTS
                  const SettingsSectionHeader(
                    title: 'Surveillance & Notifications',
                    icon: Icons.notifications_none_rounded,
                  ),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, settings) {
                      final cubit = context.read<SettingsCubit>();
                      return SettingsGroupCard(
                        children: [
                          PreferenceSwitchTile(
                            icon: Icons.notifications_active_outlined,
                            title: 'Security Alert Notifications',
                            subtitle:
                                'Push alerts on intrusion, breach, and safety events',
                            value: settings.notificationsEnabled,
                            onChanged: cubit.toggleNotifications,
                          ),
                          PreferenceSwitchTile(
                            icon: Icons.volume_up_outlined,
                            title: 'Audible Warning Chimes',
                            subtitle:
                                'Play sound siren on critical severity events',
                            value: settings.soundAlertsEnabled,
                            onChanged: cubit.toggleSound,
                          ),
                          PreferenceSwitchTile(
                            icon: Icons.vibration_rounded,
                            title: 'Haptic Feedback',
                            subtitle:
                                'Tactile response during control and emergency actions',
                            value: settings.hapticsEnabled,
                            onChanged: cubit.toggleHaptics,
                          ),
                          PreferenceSwitchTile(
                            icon: Icons.speed_rounded,
                            title: 'Low Latency Live Feed',
                            subtitle:
                                'Prioritize real-time stream sync over smooth playback',
                            value: settings.lowLatencyStream,
                            onChanged: cubit.toggleLowLatency,
                            showDivider: false,
                          ),
                        ],
                      );
                    },
                  ),

                  // 4. INFRASTRUCTURE & BACKEND
                  const SettingsSectionHeader(
                    title: 'Node & Infrastructure',
                    icon: Icons.lan_outlined,
                  ),
                  SettingsGroupCard(
                    children: [
                      SettingsInfoTile(
                        icon: Icons.cloud_done_outlined,
                        title: 'Backend Gateway',
                        subtitle: backendUrl,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.phosphor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.phosphor.withValues(alpha: 0.35),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'ONLINE',
                            style: GoogleFonts.shareTechMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: isDark
                                  ? AppTheme.phosphor
                                  : const Color(0xFF3F771A),
                            ),
                          ),
                        ),
                      ),
                      SettingsInfoTile(
                        icon: Icons.memory_rounded,
                        title: 'Surveillance Node',
                        subtitle: 'NODE-IND-BLR-04 • Primary Edge Unit',
                        trailing: Icon(
                          Icons.verified_outlined,
                          size: 18,
                          color: colorScheme.secondary,
                        ),
                      ),
                      SettingsInfoTile(
                        icon: Icons.info_outline_rounded,
                        title: 'WareWatch Engine',
                        subtitle: 'Godrej Security Platform',
                        trailing: Text(
                          'v0.1.0+1',
                          style: GoogleFonts.shareTechMono(
                            fontSize: 12,
                            color: colorScheme.secondary,
                          ),
                        ),
                        showDivider: false,
                      ),
                    ],
                  ),

                  // 5. SESSION / DANGER ZONE
                  const SettingsSectionHeader(
                    title: 'Session Management',
                    icon: Icons.security_outlined,
                  ),
                  SettingsGroupCard(
                    children: [
                      InkWell(
                        onTap: () => _handleSignOut(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: colorScheme.error.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.logout_rounded,
                                  color: colorScheme.error,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sign Out',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Disconnect active surveillance session',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: colorScheme.error.withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
