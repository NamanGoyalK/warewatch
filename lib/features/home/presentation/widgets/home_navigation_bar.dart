import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface.withValues(alpha: 0.22),
                    colorScheme.surface.withValues(alpha: 0.10),
                    colorScheme.surface.withValues(alpha: 0.16),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.22),
                  width: 1.1,
                ),
              ),
              child: Row(
                children: [
                  _NavItem(
                    label: 'Monitoring',
                    icon: Icons.videocam_outlined,
                    activeIcon: Icons.videocam,
                    isSelected: navigationShell.currentIndex == 0,
                    onTap: () => _onItemTapped(0),
                  ),
                  _NavItem(
                    label: 'Alerts',
                    icon: Icons.notifications_outlined,
                    activeIcon: Icons.notifications,
                    isSelected: navigationShell.currentIndex == 1,
                    onTap: () => _onItemTapped(1),
                  ),
                  _NavItem(
                    label: 'WW/AI',
                    icon: Icons.memory_outlined,
                    activeIcon: Icons.memory,
                    isSelected: navigationShell.currentIndex == 2,
                    onTap: () => _onItemTapped(2),
                  ),
                  _NavItem(
                    label: 'Archive',
                    icon: Icons.archive_outlined,
                    activeIcon: Icons.archive,
                    isSelected: navigationShell.currentIndex == 3,
                    onTap: () => _onItemTapped(3),
                  ),
                  _NavItem(
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    activeIcon: Icons.settings,
                    isSelected: navigationShell.currentIndex == 4,
                    onTap: () => _onItemTapped(4),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final activeColor = colorScheme.primary;
    final inactiveColor = colorScheme.onSurface.withValues(alpha: 0.52);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: 22,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  style:
                      textTheme.labelSmall?.copyWith(
                        color: isSelected ? activeColor : inactiveColor,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.2,
                        height: 1.0,
                      ) ??
                      TextStyle(
                        color: isSelected ? activeColor : inactiveColor,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        letterSpacing: 0.2,
                        height: 1.0,
                      ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
