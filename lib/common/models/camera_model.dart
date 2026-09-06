import 'package:equatable/equatable.dart';

class CameraModel extends Equatable {
  final String id;
  final String name;
  final String streamUrl;
  final String? location;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CameraModel({
    required this.id,
    required this.name,
    required this.streamUrl,
    this.location,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'],
      name: json['name'],
      streamUrl: json['streamUrl'],
      location: json['location'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [id, name, streamUrl, location, isActive, createdAt, updatedAt];
}
