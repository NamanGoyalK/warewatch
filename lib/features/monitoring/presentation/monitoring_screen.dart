import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/common/network/api_service.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'cubit/monitoring_cubit.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  late MonitoringCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = MonitoringCubit(ApiService())..fetchCameras();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 110.0),
          child: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: () => _showAddCameraDialog(context),
              child: const Icon(Icons.add),
            ),
          ),
        ),
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
                          onPressed: () =>
                              context.read<MonitoringCubit>().fetchCameras(),
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
                              style: GoogleFonts.inter(
                                color: colorScheme.secondary,
                              ),
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
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              color: isDark
                                  ? AppTheme.darkSurfaceVar
                                  : Colors.white,
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: camera.isActive
                                                ? (isDark
                                                      ? Colors.green.withValues(
                                                          alpha: 0.2,
                                                        )
                                                      : Colors.green.shade100)
                                                : (isDark
                                                      ? Colors.red.withValues(
                                                          alpha: 0.2,
                                                        )
                                                      : Colors.red.shade100),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: camera.isActive
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 8,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                camera.isActive
                                                    ? 'ONLINE'
                                                    : 'OFFLINE',
                                                style:
                                                    GoogleFonts.shareTechMono(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: camera.isActive
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: colorScheme.error,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<MonitoringCubit>()
                                                .deleteCamera(camera.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 180,
                                    color: isDark
                                        ? Colors.black26
                                        : Colors.black12,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: _LiveStreamWidget(
                                            cameraId: camera.id,
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          bottom: 8,
                                          child: IconButton.filled(
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.black54,
                                              foregroundColor: Colors.white,
                                            ),
                                            icon: const Icon(Icons.fullscreen),
                                            onPressed: () => _showLiveStream(
                                              context,
                                              camera.id,
                                              camera.name,
                                            ),
                                          ),
                                        ),
                                      ],
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

  void _showLiveStream(
    BuildContext context,
    String cameraId,
    String cameraName,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            _FullScreenLiveStream(cameraId: cameraId, cameraName: cameraName),
      ),
    );
  }

  void _showAddCameraDialog(BuildContext context) {
    final nameController = TextEditingController();
    final streamUrlController = TextEditingController();
    final locationController = TextEditingController();
    final cubit = context.read<MonitoringCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Camera',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Camera Name (e.g. Dock 1)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: streamUrlController,
                decoration: const InputDecoration(
                  labelText: 'Stream URL (RTSP/MJPEG)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final streamUrl = streamUrlController.text.trim();
              final location = locationController.text.trim();

              if (name.isNotEmpty && streamUrl.isNotEmpty) {
                cubit.createCamera(
                  name,
                  streamUrl,
                  location.isEmpty ? null : location,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add Camera'),
          ),
        ],
      ),
    );
  }
}

class _LiveStreamWidget extends StatefulWidget {
  final String cameraId;

  const _LiveStreamWidget({required this.cameraId});

  @override
  State<_LiveStreamWidget> createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<_LiveStreamWidget> {
  late Timer _timer;
  int _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _baseUrl = '';
  String? _token;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';
    _initAuth();
    _timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      if (mounted && _isInit) {
        setState(() {
          _timestamp = DateTime.now().millisecondsSinceEpoch;
        });
      }
    });
  }

  Future<void> _initAuth() async {
    _token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (mounted) {
      setState(() {
        _isInit = true;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return Container(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Image.network(
      '$_baseUrl/api/monitoring/snapshot/${widget.cameraId}?t=$_timestamp',
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : const {},
      gaplessPlayback: true,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.black12,
          child: const Center(child: Text('Loading feed...')),
        );
      },
    );
  }
}

class _FullScreenLiveStream extends StatefulWidget {
  final String cameraId;
  final String cameraName;

  const _FullScreenLiveStream({
    required this.cameraId,
    required this.cameraName,
  });

  @override
  State<_FullScreenLiveStream> createState() => _FullScreenLiveStreamState();
}

class _FullScreenLiveStreamState extends State<_FullScreenLiveStream> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: _LiveStreamWidget(cameraId: widget.cameraId)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.cameraName,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        shadows: const [
                          Shadow(color: Colors.black, blurRadius: 4),
                        ],
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
  }
}
