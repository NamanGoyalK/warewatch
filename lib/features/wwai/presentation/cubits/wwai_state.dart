import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';

class WwaiState extends Equatable {
  const WwaiState({
    required this.userId,
    required this.recentChats,
    required this.messages,
    required this.isLoadingChats,
    required this.isLoadingMessages,
    required this.isSending,
    required this.isDeleting,
    required this.activeChatId,
    required this.errorMessage,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isSearching = false,
  });

  factory WwaiState.initial({String userId = ''}) {
    return WwaiState(
      userId: userId,
      recentChats: const [],
      messages: const [],
      isLoadingChats: false,
      isLoadingMessages: false,
      isSending: false,
      isDeleting: false,
      activeChatId: null,
      errorMessage: null,
      searchQuery: '',
      searchResults: const [],
      isSearching: false,
    );
  }

  final String userId;
  final List<ChatSummary> recentChats;
  final List<ChatMessage> messages;
  final bool isLoadingChats;
  final bool isLoadingMessages;
  final bool isSending;
  final bool isDeleting;
  final String? activeChatId;
  final String? errorMessage;
  final String searchQuery;
  final List<ChatSummary> searchResults;
  final bool isSearching;

  bool get hasActiveChat => activeChatId != null && activeChatId!.isNotEmpty;
  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  WwaiState copyWith({
    String? userId,
    List<ChatSummary>? recentChats,
    List<ChatMessage>? messages,
    bool? isLoadingChats,
    bool? isLoadingMessages,
    bool? isSending,
    bool? isDeleting,
    String? activeChatId,
    bool clearActiveChatId = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? searchQuery,
    List<ChatSummary>? searchResults,
    bool? isSearching,
  }) {
    return WwaiState(
      userId: userId ?? this.userId,
      recentChats: recentChats ?? this.recentChats,
      messages: messages ?? this.messages,
      isLoadingChats: isLoadingChats ?? this.isLoadingChats,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSending: isSending ?? this.isSending,
      isDeleting: isDeleting ?? this.isDeleting,
      activeChatId: clearActiveChatId ? null : activeChatId ?? this.activeChatId,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        recentChats,
        messages,
        isLoadingChats,
        isLoadingMessages,
        isSending,
        isDeleting,
        activeChatId,
        errorMessage,
        searchQuery,
        searchResults,
        isSearching,
      ];
}