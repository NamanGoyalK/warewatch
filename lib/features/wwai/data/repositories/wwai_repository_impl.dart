import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';
import '../../domain/repositories/wwai_repository.dart';
import '../datasources/wwai_remote_data_source.dart';

class WwaiRepositoryImpl implements WwaiRepository {
  WwaiRepositoryImpl({WwaiRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? WwaiRemoteDataSource();

  final WwaiRemoteDataSource _remoteDataSource;

  @override
  Future<List<ChatSummary>> getRecentChats() {
    return _remoteDataSource.getRecentChats();
  }

  @override
  Future<List<ChatMessage>> getMessages({
    required String chatId,
    int limit = 20,
  }) {
    return _remoteDataSource.getMessages(chatId: chatId, limit: limit);
  }

  @override
  Future<ChatMessage> sendMessage({
    String? chatId,
    required String message,
    void Function(String)? onChunk,
  }) {
    return _remoteDataSource.sendMessage(
      chatId: chatId,
      message: message,
      onChunk: onChunk,
    );
  }

  @override
  Future<void> deleteChat({required String chatId}) {
    return _remoteDataSource.deleteChat(chatId: chatId);
  }

  @override
  void dispose() {
    _remoteDataSource.dispose();
  }
}
