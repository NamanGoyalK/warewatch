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

  bool get hasActiveChat => activeChatId != null && activeChatId!.isNotEmpty;

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
      ];
}