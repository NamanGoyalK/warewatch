import 'package:equatable/equatable.dart';

class ArchiveClipModel extends Equatable {
  final String id;
  final String alertId;
  final String videoPath;
  final double duration;
  final int fileSize;
  final DateTime createdAt;

  const ArchiveClipModel({
    required this.id,
    required this.alertId,
    required this.videoPath,
    required this.duration,
    required this.fileSize,
    required this.createdAt,
  });

  factory ArchiveClipModel.fromJson(Map<String, dynamic> json) {
    return ArchiveClipModel(
      id: json['id'],
      alertId: json['alertId'],
      videoPath: json['videoPath'],
      duration: (json['duration'] ?? 0).toDouble(),
      fileSize: json['fileSize'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [id, alertId, videoPath, duration, fileSize, createdAt];
}
