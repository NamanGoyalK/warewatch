import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:warewatch/common/network/api_service.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'cubit/alerts_cubit.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _getSeverityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
        return Colors.purple;
      case 'HIGH':
        return Colors.red;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => AlertsCubit(ApiService())..startPolling(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                          Icons.warning_amber_rounded,
                          size: 24,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Real-time Alerts',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Active security and operational notifications',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 11,
                                letterSpacing: 0.2,
                                color: colorScheme.secondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () =>
                              context.read<AlertsCubit>().fetchAlerts(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AlertsCubit, AlertsState>(
                    builder: (context, state) {
                      if (state is AlertsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AlertsError) {
                        return Center(child: Text(state.message));
                      } else if (state is AlertsLoaded) {
                        final alerts = state.alerts;
                        if (alerts.isEmpty) {
                          return Center(
                            child: Text(
                              'No recent alerts!',
                              style: GoogleFonts.inter(
                                color: colorScheme.secondary,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: alerts.length,
                          itemBuilder: (context, index) {
                            final alert = alerts[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: alert.acknowledged ? 0 : 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              color: alert.acknowledged
                                  ? (isDark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade50)
                                  : (isDark
                                        ? AppTheme.darkSurfaceVar
                                        : Colors.white),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (alert.thumbnailUrl != null)
                                    Builder(
                                      builder: (context) {
                                        final baseUrl =
                                            dotenv.env['BACKEND_URL'] ??
                                            'http://localhost:8080';
                                        var path = alert.thumbnailUrl!;
                                        if (path.startsWith('/app/clips/')) {
                                          path = path.replaceFirst(
                                            '/app/clips/',
                                            '$baseUrl/clips/',
                                          );
                                        } else if (path.startsWith('http')) {
                                          // keep it
                                        } else {
                                          path =
                                              '$baseUrl/clips/thumbnails/${path.split('/').last}';
                                        }
                                        return SizedBox(
                                          height: 160,
                                          child: Image.network(
                                            path,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) {
                                                  return Container(
                                                    color: Colors.black12,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      title: Text(
                                        '${alert.className} detected',
                                        style: GoogleFonts.inter(
                                          fontWeight: alert.acknowledged
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          'Camera: ${alert.camera?.name ?? alert.cameraId ?? 'Deleted Camera'}\nTime: ${alert.createdAt.toLocal().toString().split('.')[0]}',
                                          style: GoogleFonts.shareTechMono(
                                            fontSize: 12,
                                            color: colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                      isThreeLine: true,
                                      trailing: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          alert.acknowledged
                                              ? Text(
                                                  'Ack\'d',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () => context
                                                      .read<AlertsCubit>()
                                                      .acknowledgeAlert(
                                                        alert.id,
                                                      ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 22,
                                                  ),
                                                ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getSeverityColor(
                                                alert.severity,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: _getSeverityColor(
                                                  alert.severity,
                                                ).withValues(alpha: 0.5),
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Text(
                                              alert.severity.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                color: _getSeverityColor(
                                                  alert.severity,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 9,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
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
