import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/wwai_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';
import 'wwai_state.dart';

class WwaiCubit extends Cubit<WwaiState> {
  WwaiCubit(this._repository) : super(WwaiState.initial());

  final WwaiRepositoryImpl _repository;

  Future<void> initialize() async {
    _safeEmit(state.copyWith(clearErrorMessage: true));
    await refreshRecentChats(openFirstChat: false);
  }

  Future<void> refreshRecentChats({bool openFirstChat = false}) async {
    _safeEmit(state.copyWith(isLoadingChats: true, clearErrorMessage: true));
    try {
      final chats = await _repository.getRecentChats();
      if (isClosed) return;
      final selectedChatId = _selectChatId(chats, openFirstChat: openFirstChat);

      if (selectedChatId == null) {
        _safeEmit(
          state.copyWith(
            recentChats: chats,
            clearActiveChatId: true,
            messages: const [],
            isLoadingChats: false,
            isLoadingMessages: false,
          ),
        );
        return;
      }

      final messages =
          selectedChatId == state.activeChatId && state.messages.isNotEmpty
          ? state.messages
          : await _repository.getMessages(chatId: selectedChatId);

      _safeEmit(
        state.copyWith(
          recentChats: chats,
          messages: messages,
          activeChatId: selectedChatId,
          isLoadingChats: false,
          isLoadingMessages: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          isLoadingChats: false,
          isLoadingMessages: false,
          clearErrorMessage: true,
          errorMessage: _friendlyMessage(error),
        ),
      );
    }
  }

  Future<void> selectChat(String chatId) async {
    _safeEmit(state.copyWith(isLoadingMessages: true, clearErrorMessage: true));
    try {
      final chats = await _repository.getRecentChats();
      final messages = await _repository.getMessages(chatId: chatId);

      _safeEmit(
        state.copyWith(
          recentChats: chats,
          messages: messages,
          activeChatId: chatId,
          isLoadingMessages: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      _safeEmit(
        state.copyWith(
          isLoadingMessages: false,
          clearErrorMessage: true,
          errorMessage: _friendlyMessage(error),
        ),
      );
    }
  }

  Future<void> startNewChat() async {
    _safeEmit(
      state.copyWith(
        clearActiveChatId: true,
        messages: const [],
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty || state.isSending) return;

    final optimisticUserMessage = ChatMessage(
      messageId: 'local-user-${DateTime.now().microsecondsSinceEpoch}',
      chatId: state.activeChatId ?? '',
      role: 'USER',
      content: trimmedMessage,
      createdAt: DateTime.now(),
    );

    final placeholderAiMessage = ChatMessage(
      messageId: 'local-ai-${DateTime.now().microsecondsSinceEpoch}',
      chatId: state.activeChatId ?? '',
      role: 'ASSISTANT',
      content: '',
      createdAt: DateTime.now(),
    );

    final previousMessages = List<ChatMessage>.of(state.messages);
    _safeEmit(
      state.copyWith(
        messages: [
          ...previousMessages,
          optimisticUserMessage,
          placeholderAiMessage,
        ],
        isSending: true,
        clearErrorMessage: true,
      ),
    );

    String aiContent = '';

    try {
      final assistantMessage = await _repository.sendMessage(
        chatId: state.activeChatId,
        message: trimmedMessage,
        onChunk: (chunk) {
          if (isClosed) return;
          aiContent += chunk;
          final currentMessages = List<ChatMessage>.of(state.messages);
          currentMessages.last = ChatMessage(
            messageId: placeholderAiMessage.messageId,
            chatId: placeholderAiMessage.chatId,
            role: placeholderAiMessage.role,
            content: aiContent,
            createdAt: placeholderAiMessage.createdAt,
          );
          _safeEmit(state.copyWith(messages: currentMessages));
        },
      );

      if (isClosed) return;

      final updatedMessages = List<ChatMessage>.of(state.messages);
      updatedMessages[updatedMessages.length - 1] = assistantMessage;

      _safeEmit(
        state.copyWith(
          messages: updatedMessages,
          activeChatId: assistantMessage.chatId,
          isSending: false,
          clearErrorMessage: true,
        ),
      );

      _repository.getRecentChats().then((chats) {
        if (!isClosed) {
          _safeEmit(state.copyWith(recentChats: chats));
        }
      }).ignore();
    } catch (error) {
      _safeEmit(
        state.copyWith(
          messages: [...previousMessages, optimisticUserMessage],
          isSending: false,
          clearErrorMessage: true,
          errorMessage: _friendlyMessage(error),
        ),
      );
    }
  }

  Future<void> deleteChat(String chatId) async {
    _safeEmit(state.copyWith(isDeleting: true, clearErrorMessage: true));
    try {
      await _repository.deleteChat(chatId: chatId);
      if (state.hasSearchQuery) {
        final updatedSearchResults = state.searchResults
            .where((c) => c.chatId != chatId)
            .toList();
        _safeEmit(state.copyWith(searchResults: updatedSearchResults));
      }
      await refreshRecentChats(openFirstChat: true);
      _safeEmit(state.copyWith(isDeleting: false, clearErrorMessage: true));
    } catch (error) {
      _safeEmit(
        state.copyWith(
          isDeleting: false,
          clearErrorMessage: true,
          errorMessage: _friendlyMessage(error),
        ),
      );
    }
  }

  Future<void> searchChats(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _safeEmit(
        state.copyWith(
          searchQuery: '',
          searchResults: const [],
          isSearching: false,
        ),
      );
      return;
    }

    _safeEmit(
      state.copyWith(
        searchQuery: query,
        isSearching: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final results = await _repository.searchChats(trimmed);
      if (isClosed) return;
      if (state.searchQuery != query) return;

      _safeEmit(
        state.copyWith(
          searchResults: results,
          isSearching: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      _safeEmit(
        state.copyWith(
          isSearching: false,
          errorMessage: _friendlyMessage(error),
        ),
      );
    }
  }

  void clearSearch() {
    _safeEmit(
      state.copyWith(
        searchQuery: '',
        searchResults: const [],
        isSearching: false,
      ),
    );
  }

  String? _selectChatId(
    List<ChatSummary> chats, {
    required bool openFirstChat,
  }) {
    final activeChatId = state.activeChatId;
    if (activeChatId != null &&
        chats.any((chat) => chat.chatId == activeChatId)) {
      return activeChatId;
    }
    if (openFirstChat && chats.isNotEmpty) {
      return chats.first.chatId;
    }
    return null;
  }

  void _safeEmit(WwaiState next) {
    if (isClosed) return;
    emit(next);
  }

  String _friendlyMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('FormatException')) {
      return 'The server returned an unexpected response.';
    }
    if (raw.contains('ClientException')) {
      const prefix = 'ClientException: ';
      final start = raw.indexOf(prefix);
      if (start != -1) {
        final rest = raw.substring(start + prefix.length);
        final uriSep = rest.indexOf(', uri=');
        final message = (uriSep == -1 ? rest : rest.substring(0, uriSep))
            .trim();
        if (message.isNotEmpty && !message.contains('failed with status')) {
          return message;
        }
      }
      return 'Unable to reach the chat API. Check the backend is running.';
    }
    return 'Something went wrong while loading WWAI.';
  }

  @override
  Future<void> close() {
    _repository.dispose();
    return super.close();
  }
}
