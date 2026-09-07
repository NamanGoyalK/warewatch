import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warewatch/common/network/api_service.dart';
import 'package:warewatch/core/theme/app_theme.dart';
import 'cubit/archive_cubit.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ArchiveCubit(ApiService())..fetchClips(),
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
                          Icons.archive_outlined,
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
                              'Incident Archive',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Historical video clips and records',
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
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              final state = context.read<ArchiveCubit>().state;
                              if (state is ArchiveLoaded) {
                                context.read<ArchiveCubit>().fetchClips(
                                  cameraId: state.cameraId,
                                  date: state.date,
                                );
                              } else {
                                context.read<ArchiveCubit>().fetchClips();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                BlocBuilder<ArchiveCubit, ArchiveState>(
                  builder: (context, state) {
                    if (state is ArchiveLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Camera',
                                ),
                                value: state.cameraId,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('All Cameras'),
                                  ),
                                  ...state.cameras.map(
                                    (cam) => DropdownMenuItem(
                                      value: cam.id,
                                      child: Text(cam.name),
                                    ),
                                  ),
                                ],
                                onChanged: (val) => context
                                    .read<ArchiveCubit>()
                                    .filterByCamera(val),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: state.date != null
                                        ? DateTime.parse(state.date!)
                                        : DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null && context.mounted) {
                                    final dateStr = picked
                                        .toIso8601String()
                                        .split('T')[0];
                                    context.read<ArchiveCubit>().filterByDate(
                                      dateStr,
                                    );
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    border: const OutlineInputBorder(),
                                    labelText: 'Date',
                                    suffixIcon: state.date != null
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 16,
                                            ),
                                            onPressed: () => context
                                                .read<ArchiveCubit>()
                                                .filterByDate(null),
                                          )
                                        : const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                          ),
                                  ),
                                  child: Text(state.date ?? 'Any Date'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Expanded(
                  child: BlocBuilder<ArchiveCubit, ArchiveState>(
                    builder: (context, state) {
                      if (state is ArchiveLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ArchiveError) {
                        return Center(child: Text(state.message));
                      } else if (state is ArchiveLoaded) {
                        final clips = state.clips;
                        if (clips.isEmpty) {
                          return Center(
                            child: Text(
                              'No archive clips found',
                              style: GoogleFonts.inter(
                                color: colorScheme.secondary,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          itemCount: clips.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == clips.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () => context
                                        .read<ArchiveCubit>()
                                        .fetchMore(),
                                    child: const Text('Load More'),
                                  ),
                                ),
                              );
                            }
                            final clip = clips[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16.0),
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
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.video_library_rounded,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    title: Text(
                                      'Camera: ${clip.alert?.camera?.name ?? 'Unknown Camera'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Time: ${clip.createdAt.toLocal().toString().split('.')[0]}',
                                      style: GoogleFonts.shareTechMono(
                                        fontSize: 12,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${clip.duration.toStringAsFixed(1)}s',
                                        style: GoogleFonts.shareTechMono(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 250,
                                    child: VideoPlayerWidget(clipId: clip.id),
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

class VideoPlayerWidget extends StatefulWidget {
  final String clipId;
  const VideoPlayerWidget({super.key, required this.clipId});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      final baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';
      final videoUrl =
          '$baseUrl/api/archive/${widget.clipId}/video?token=$token';

      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Video player initialization error: $e');
      if (!mounted) return;
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Container(
        color: Colors.black12,
        child: const Center(child: Text('Error loading video')),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        IconButton(
          iconSize: 56,
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _controller!.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          onPressed: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            });
          },
        ),
      ],
    );
  }
}
