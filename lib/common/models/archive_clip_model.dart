import 'package:equatable/equatable.dart';
import 'alert_model.dart';

class ArchiveClipModel extends Equatable {
  final String id;
  final String alertId;
  final String videoPath;
  final double duration;
  final int fileSize;
  final DateTime createdAt;
  final AlertModel? alert;

  const ArchiveClipModel({
    required this.id,
    required this.alertId,
    required this.videoPath,
    required this.duration,
    required this.fileSize,
    required this.createdAt,
    this.alert,
  });

  factory ArchiveClipModel.fromJson(Map<String, dynamic> json) {
    return ArchiveClipModel(
      id: json['id'],
      alertId: json['alertId'],
      videoPath: json['videoPath'],
      duration: (json['duration'] ?? 0).toDouble(),
      fileSize: json['fileSize'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      alert: json['alert'] != null ? AlertModel.fromJson(json['alert']) : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    alertId,
    videoPath,
    duration,
    fileSize,
    createdAt,
  ];
}
