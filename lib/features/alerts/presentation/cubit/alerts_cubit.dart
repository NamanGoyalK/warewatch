import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warewatch/common/models/alert_model.dart';
import 'package:warewatch/common/network/api_service.dart';

abstract class AlertsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AlertsInitial extends AlertsState {}

class AlertsLoading extends AlertsState {}

class AlertsLoaded extends AlertsState {
  final List<AlertModel> alerts;
  AlertsLoaded(this.alerts);
  @override
  List<Object> get props => [alerts];
}

class AlertsError extends AlertsState {
  final String message;
  AlertsError(this.message);
  @override
  List<Object> get props => [message];
}

class AlertsCubit extends Cubit<AlertsState> {
  final ApiService _apiService;

  AlertsCubit(this._apiService) : super(AlertsInitial());

  Future<void> fetchAlerts() async {
    emit(AlertsLoading());
    try {
      final alerts = await _apiService.getAlerts();
      emit(AlertsLoaded(alerts));
    } catch (e) {
      emit(AlertsError(e.toString()));
    }
  }

  Future<void> acknowledgeAlert(String id) async {
    if (state is AlertsLoaded) {
      final currentAlerts = (state as AlertsLoaded).alerts;
      try {
        await _apiService.acknowledgeAlert(id);
        // Optimistic update
        final updatedAlerts = currentAlerts.map((a) {
          if (a.id == id) {
            return AlertModel(
              id: a.id,
              cameraId: a.cameraId,
              className: a.className,
              confidence: a.confidence,
              severity: a.severity,
              bboxX1: a.bboxX1,
              bboxY1: a.bboxY1,
              bboxX2: a.bboxX2,
              bboxY2: a.bboxY2,
              imageWidth: a.imageWidth,
              imageHeight: a.imageHeight,
              acknowledged: true,
              thumbnailUrl: a.thumbnailUrl,
              createdAt: a.createdAt,
              camera: a.camera,
              archiveClip: a.archiveClip,
            );
          }
          return a;
        }).toList();
        emit(AlertsLoaded(updatedAlerts));
      } catch (e) {
        // Handle error, maybe show a snackbar
      }
    }
  }
}
