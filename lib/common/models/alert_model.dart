import 'package:equatable/equatable.dart';
import 'camera_model.dart';
import 'archive_clip_model.dart';

class AlertModel extends Equatable {
  final String id;
  final String cameraId;
  final String className;
  final double confidence;
  final String severity;
  final double bboxX1;
  final double bboxY1;
  final double bboxX2;
  final double bboxY2;
  final int imageWidth;
  final int imageHeight;
  final bool acknowledged;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final CameraModel? camera;
  final ArchiveClipModel? archiveClip;

  const AlertModel({
    required this.id,
    required this.cameraId,
    required this.className,
    required this.confidence,
    required this.severity,
    required this.bboxX1,
    required this.bboxY1,
    required this.bboxX2,
    required this.bboxY2,
    required this.imageWidth,
    required this.imageHeight,
    required this.acknowledged,
    this.thumbnailUrl,
    required this.createdAt,
    this.camera,
    this.archiveClip,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      cameraId: json['cameraId'],
      className: json['className'],
      confidence: (json['confidence'] ?? 0).toDouble(),
      severity: json['severity'],
      bboxX1: (json['bboxX1'] ?? 0).toDouble(),
      bboxY1: (json['bboxY1'] ?? 0).toDouble(),
      bboxX2: (json['bboxX2'] ?? 0).toDouble(),
      bboxY2: (json['bboxY2'] ?? 0).toDouble(),
      imageWidth: json['imageWidth'] ?? 0,
      imageHeight: json['imageHeight'] ?? 0,
      acknowledged: json['acknowledged'] ?? false,
      thumbnailUrl: json['thumbnailUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      camera: json['camera'] != null ? CameraModel.fromJson(json['camera']) : null,
      archiveClip: json['archiveClip'] != null ? ArchiveClipModel.fromJson(json['archiveClip']) : null,
    );
  }

  @override
  List<Object?> get props => [
        id, cameraId, className, confidence, severity, bboxX1, bboxY1, bboxX2, bboxY2,
        imageWidth, imageHeight, acknowledged, thumbnailUrl, createdAt, camera, archiveClip
      ];
}
