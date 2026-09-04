class ChatSummary {
  final String chatId;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatSummary({
    required this.chatId,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });
}