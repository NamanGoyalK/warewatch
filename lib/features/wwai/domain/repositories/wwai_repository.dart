import '../entities/chat_message.dart';
import '../entities/chat_summary.dart';

abstract class WwaiRepository {
  Future<List<ChatSummary>> getRecentChats();

  Future<List<ChatSummary>> searchChats(String query);

  Future<List<ChatMessage>> getMessages({
    required String chatId,
    int limit = 20,
  });

  Future<ChatMessage> sendMessage({
    String? chatId,
    required String message,
    void Function(String)? onChunk,
  });

  Future<void> deleteChat({required String chatId});

  void dispose();
}
