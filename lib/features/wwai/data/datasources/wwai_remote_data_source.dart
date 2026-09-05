import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/chat_message_model.dart';
import '../models/chat_summary_model.dart';

class WwaiRemoteDataSource {
  WwaiRemoteDataSource({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri =
          baseUri ??
          Uri.parse(dotenv.env['BACKEND_URL'] ?? 'http://localhost:8080');

  final http.Client _client;
  final Uri _baseUri;

  Future<Map<String, String>> _getHeaders({bool isStream = false}) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Accept': isStream ? 'text/event-stream' : 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ChatSummaryModel>> getRecentChats() async {
    final response = await _client.get(
      _baseUri.resolve('/api/chat/recent'),
      headers: await _getHeaders(),
    );
    _throwIfNeeded(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final chats = decoded['chats'] as List<dynamic>;
    return chats
        .map((item) => ChatSummaryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatSummaryModel>> searchChats(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final response = await _client.get(
      _baseUri.resolve(
        '/api/chat/search?q=${Uri.encodeQueryComponent(trimmed)}',
      ),
      headers: await _getHeaders(),
    );
    _throwIfNeeded(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final chats = decoded['chats'] as List<dynamic>? ?? const [];
    return chats
        .map((item) => ChatSummaryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessageModel>> getMessages({
    required String chatId,
    int limit = 20,
  }) async {
    final response = await _client.get(
      _baseUri.resolve('/api/chat/$chatId/messages?limit=$limit'),
      headers: await _getHeaders(),
    );
    _throwIfNeeded(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final messages = decoded['messages'] as List<dynamic>;
    return messages
        .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessageModel> sendMessage({
    String? chatId,
    required String message,
    void Function(String)? onChunk,
  }) async {
    final request = http.Request('POST', _baseUri.resolve('/api/chat/'))
      ..headers.addAll(await _getHeaders(isStream: true))
      ..body = jsonEncode({
        if (chatId != null && chatId.isNotEmpty) 'chatId': chatId,
        'message': message,
      });

    final streamedResponse = await _client.send(request);
    if (streamedResponse.statusCode < 200 ||
        streamedResponse.statusCode >= 300) {
      final body = await streamedResponse.stream.bytesToString();
      throw http.ClientException(
        'Chat request failed with status ${streamedResponse.statusCode}: $body',
        request.url,
      );
    }

    ChatMessageModel? doneMessage;
    await for (final line
        in streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || !trimmed.startsWith('data:')) continue;

      final payload = trimmed.substring(5).trim();
      if (payload.isEmpty) continue;

      final decoded = jsonDecode(payload) as Map<String, dynamic>;

      if (decoded['type'] == 'chunk' && onChunk != null) {
        onChunk(decoded['content'] as String);
      } else if (decoded['type'] == 'done') {
        doneMessage = ChatMessageModel.fromJson(decoded);
      } else if (decoded['type'] == 'error') {
        throw http.ClientException(
          decoded['message']?.toString() ?? 'Server error',
          request.url,
        );
      }
    }

    if (doneMessage == null) {
      throw const FormatException('Chat stream ended without a final response');
    }

    return doneMessage;
  }

  Future<void> deleteChat({required String chatId}) async {
    final request = http.Request(
      'DELETE',
      _baseUri.resolve('/api/chat/$chatId'),
    )..headers.addAll(await _getHeaders());

    final response = await _client.send(request);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      throw http.ClientException(
        'Delete chat failed with status ${response.statusCode}: $body',
        request.url,
      );
    }
  }

  void dispose() => _client.close();

  void _throwIfNeeded(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Request failed with status ${response.statusCode}: ${response.body}',
        response.request?.url,
      );
    }
  }
}
