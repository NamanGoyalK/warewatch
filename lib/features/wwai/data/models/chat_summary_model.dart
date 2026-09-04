import '../../domain/entities/chat_summary.dart';

class ChatSummaryModel extends ChatSummary {
  const ChatSummaryModel({
    required super.chatId,
    required super.title,
    super.createdAt,
    super.updatedAt,
  });

  factory ChatSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChatSummaryModel(
      chatId: json['chatId']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled chat',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }
}