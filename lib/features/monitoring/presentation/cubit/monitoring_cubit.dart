import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warewatch/common/models/camera_model.dart';
import 'package:warewatch/common/network/api_service.dart';

abstract class MonitoringState extends Equatable {
  @override
  List<Object> get props => [];
}

class MonitoringInitial extends MonitoringState {}

class MonitoringLoading extends MonitoringState {}

class MonitoringLoaded extends MonitoringState {
  final List<CameraModel> cameras;
  MonitoringLoaded(this.cameras);
  @override
  List<Object> get props => [cameras];
}

class MonitoringError extends MonitoringState {
  final String message;
  MonitoringError(this.message);
  @override
  List<Object> get props => [message];
}

class MonitoringCubit extends Cubit<MonitoringState> {
  final ApiService _apiService;

  MonitoringCubit(this._apiService) : super(MonitoringInitial());

  Future<void> fetchCameras() async {
    emit(MonitoringLoading());
    try {
      final cameras = await _apiService.getCameras();
      emit(MonitoringLoaded(cameras));
    } catch (e) {
      emit(MonitoringError(e.toString()));
    }
  }

  Future<void> createCamera(
    String name,
    String streamUrl,
    String? location,
  ) async {
    try {
      await _apiService.createCamera(name, streamUrl, location);
      await fetchCameras();
    } catch (e) {
      emit(MonitoringError(e.toString()));
    }
  }

  Future<void> deleteCamera(String id) async {
    try {
      await _apiService.deleteCamera(id);
      await fetchCameras();
    } catch (e) {
      emit(MonitoringError(e.toString()));
    }
  }
}
