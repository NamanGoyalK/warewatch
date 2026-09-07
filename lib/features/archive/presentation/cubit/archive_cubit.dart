import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warewatch/common/models/archive_clip_model.dart';
import 'package:warewatch/common/models/camera_model.dart';
import 'package:warewatch/common/network/api_service.dart';

abstract class ArchiveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArchiveInitial extends ArchiveState {}

class ArchiveLoading extends ArchiveState {}

class ArchiveLoaded extends ArchiveState {
  final List<ArchiveClipModel> clips;
  final List<CameraModel> cameras;
  final int skip;
  final bool hasMore;
  final String? cameraId;
  final String? date;

  ArchiveLoaded({
    required this.clips,
    required this.cameras,
    required this.skip,
    required this.hasMore,
    this.cameraId,
    this.date,
  });

  @override
  List<Object?> get props => [clips, cameras, skip, hasMore, cameraId, date];
}

class ArchiveError extends ArchiveState {
  final String message;
  ArchiveError(this.message);
  @override
  List<Object?> get props => [message];
}

class ArchiveCubit extends Cubit<ArchiveState> {
  final ApiService _apiService;
  static const int _take = 20;

  ArchiveCubit(this._apiService) : super(ArchiveInitial());

  Future<void> fetchClips({String? cameraId, String? date}) async {
    List<CameraModel> currentCameras = [];
    if (state is ArchiveLoaded) {
      currentCameras = (state as ArchiveLoaded).cameras;
    }

    emit(ArchiveLoading());
    try {
      if (currentCameras.isEmpty) {
        currentCameras = await _apiService.getCameras();
      }
      final clips = await _apiService.getArchiveClips(
        skip: 0,
        take: _take,
        cameraId: cameraId,
        date: date,
      );
      emit(
        ArchiveLoaded(
          clips: clips,
          cameras: currentCameras,
          skip: 0,
          hasMore: clips.length == _take,
          cameraId: cameraId,
          date: date,
        ),
      );
    } catch (e) {
      emit(ArchiveError(e.toString()));
    }
  }

  Future<void> fetchMore() async {
    if (state is! ArchiveLoaded) return;
    final currentState = state as ArchiveLoaded;
    if (!currentState.hasMore) return;

    final nextSkip = currentState.skip + _take;

    try {
      final moreClips = await _apiService.getArchiveClips(
        skip: nextSkip,
        take: _take,
        cameraId: currentState.cameraId,
        date: currentState.date,
      );

      emit(
        ArchiveLoaded(
          clips: [...currentState.clips, ...moreClips],
          cameras: currentState.cameras,
          skip: nextSkip,
          hasMore: moreClips.length == _take,
          cameraId: currentState.cameraId,
          date: currentState.date,
        ),
      );
    } catch (e) {
      // Keep old state if it fails
    }
  }

  Future<void> filterByCamera(String? cameraId) async {
    final currentDate = state is ArchiveLoaded
        ? (state as ArchiveLoaded).date
        : null;
    await fetchClips(cameraId: cameraId, date: currentDate);
  }

  Future<void> filterByDate(String? date) async {
    final currentCameraId = state is ArchiveLoaded
        ? (state as ArchiveLoaded).cameraId
        : null;
    await fetchClips(cameraId: currentCameraId, date: date);
  }
}
