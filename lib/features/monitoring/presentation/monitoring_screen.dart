import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/common/network/api_service.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'cubit/monitoring_cubit.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => MonitoringCubit(ApiService())..fetchCameras(),
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
                          Icons.videocam_outlined,
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
                              'Live Monitoring',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Warehouse camera streams and snapshots',
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
                          onPressed: () => context.read<MonitoringCubit>().fetchCameras(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<MonitoringCubit, MonitoringState>(
                    builder: (context, state) {
                      if (state is MonitoringLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MonitoringError) {
                        return Center(child: Text(state.message));
                      } else if (state is MonitoringLoaded) {
                        final cameras = state.cameras;
                        if (cameras.isEmpty) {
                          return Center(
                            child: Text(
                              'No cameras configured',
                              style: GoogleFonts.inter(color: colorScheme.secondary),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: cameras.length,
                          itemBuilder: (context, index) {
                            final camera = cameras[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                              color: isDark ? AppTheme.darkSurfaceVar : Colors.white,
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    title: Text(
                                      camera.name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      camera.location ?? 'Unknown location',
                                      style: GoogleFonts.shareTechMono(
                                        fontSize: 12,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: camera.isActive 
                                          ? (isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.shade100) 
                                          : (isDark ? Colors.red.withValues(alpha: 0.2) : Colors.red.shade100),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.circle, color: camera.isActive ? Colors.green : Colors.red, size: 8),
                                          const SizedBox(width: 4),
                                          Text(
                                            camera.isActive ? 'ONLINE' : 'OFFLINE',
                                            style: GoogleFonts.shareTechMono(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: camera.isActive ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 180,
                                    color: isDark ? Colors.black26 : Colors.black12,
                                    child: Center(
                                      child: FilledButton.icon(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: colorScheme.primary.withValues(alpha: 0.8),
                                        ),
                                        icon: const Icon(Icons.camera_alt_outlined),
                                        label: const Text('View Stream Snapshot'),
                                        onPressed: () => _showSnapshot(context, camera.id, camera.name),
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

  void _showSnapshot(BuildContext context, String cameraId, String cameraName) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Snapshot: $cameraName',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            '$baseUrl/api/monitoring/snapshot/$cameraId',
            headers: {'Authorization': 'Bearer $token'},
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                color: Colors.black12,
                child: const Center(child: Text('Failed to load snapshot')),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
