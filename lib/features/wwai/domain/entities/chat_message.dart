class ChatMessage {
  final String messageId;
  final String chatId;
  final String role;
  final String content;
  final DateTime? createdAt;

  const ChatMessage({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.content,
    this.createdAt,
  });

  bool get isUser => role.toUpperCase() == 'USER';
}
