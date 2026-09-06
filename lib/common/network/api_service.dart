import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/camera_model.dart';
import '../models/alert_model.dart';
import '../models/archive_clip_model.dart';

class ApiService {
  String get baseUrl => dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080';

  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<CameraModel>> getCameras() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cameras'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 1 && json['cameras'] != null) {
        return (json['cameras'] as List).map((c) => CameraModel.fromJson(c)).toList();
      }
    }
    throw Exception('Failed to load cameras');
  }

  Future<List<AlertModel>> getAlerts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/alerts'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 1 && json['alerts'] != null) {
        return (json['alerts'] as List).map((a) => AlertModel.fromJson(a)).toList();
      }
    }
    throw Exception('Failed to load alerts');
  }

  Future<void> acknowledgeAlert(String id) async {
    final response = await http.post(Uri.parse('$baseUrl/api/alerts/$id/acknowledge'), headers: await _getHeaders());
    if (response.statusCode != 200) {
      throw Exception('Failed to acknowledge alert');
    }
  }

  Future<List<ArchiveClipModel>> getArchiveClips() async {
    final response = await http.get(Uri.parse('$baseUrl/api/archive'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 1 && json['clips'] != null) {
        return (json['clips'] as List).map((c) => ArchiveClipModel.fromJson(c)).toList();
      }
    }
    throw Exception('Failed to load archive clips');
  }
}
