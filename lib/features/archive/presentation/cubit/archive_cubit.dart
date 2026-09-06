import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warewatch/common/models/archive_clip_model.dart';
import 'package:warewatch/common/network/api_service.dart';

abstract class ArchiveState extends Equatable {
  @override
  List<Object> get props => [];
}

class ArchiveInitial extends ArchiveState {}

class ArchiveLoading extends ArchiveState {}

class ArchiveLoaded extends ArchiveState {
  final List<ArchiveClipModel> clips;
  ArchiveLoaded(this.clips);
  @override
  List<Object> get props => [clips];
}

class ArchiveError extends ArchiveState {
  final String message;
  ArchiveError(this.message);
  @override
  List<Object> get props => [message];
}

class ArchiveCubit extends Cubit<ArchiveState> {
  final ApiService _apiService;

  ArchiveCubit(this._apiService) : super(ArchiveInitial());

  Future<void> fetchClips() async {
    emit(ArchiveLoading());
    try {
      final clips = await _apiService.getArchiveClips();
      emit(ArchiveLoaded(clips));
    } catch (e) {
      emit(ArchiveError(e.toString()));
    }
  }
}
