import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warewatch/common/widgets/atmospheric_background.dart';

import '../cubits/wwai_cubit.dart';
import '../cubits/wwai_state.dart';

class ChatSidebar extends StatelessWidget {
  const ChatSidebar({super.key, required this.state});

  final WwaiState state;

  Future<void> _confirmDeleteChat(BuildContext context, String chatId) async {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<WwaiCubit>();

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Chat'),
          content: const Text(
            'Are you sure you want to delete this conversation? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      cubit.deleteChat(chatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: AtmosphericBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                children: [
                  if (MediaQuery.sizeOf(context).width < 900)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: colorScheme.primary.withAlpha(45),
                          foregroundColor: colorScheme.primary,
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: colorScheme.primary.withAlpha(150),
                            width: 1.5,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.primary.withAlpha(45),
                        foregroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        side: BorderSide(
                          color: colorScheme.primary.withAlpha(150),
                          width: 1.5,
                        ),
                      ),
                      onPressed: state.isSending
                          ? null
                          : () {
                              if (MediaQuery.sizeOf(context).width < 900) {
                                Navigator.of(context).pop();
                              }
                              context.read<WwaiCubit>().startNewChat();
                            },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(
                        'New chat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                'RECENT CHATS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: _buildRecentChatsList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChatsList(BuildContext context) {
    if (state.isLoadingChats && state.recentChats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.recentChats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 32,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withAlpha(100),
            ),
            const SizedBox(height: 12),
            Text(
              'No recent chats',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.recentChats.length,
      itemBuilder: (context, index) {
        final chat = state.recentChats[index];
        final isSelected = chat.chatId == state.activeChatId;
        final colorScheme = Theme.of(context).colorScheme;

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            selected: isSelected,
            selectedTileColor: colorScheme.primary.withAlpha(25),
            leading: Icon(
              Icons.chat_bubble_outline,
              size: 20,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            title: Text(
              chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
            trailing: isSelected
                ? IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    onPressed: () => _confirmDeleteChat(context, chat.chatId),
                    color: colorScheme.onSurfaceVariant.withAlpha(180),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest
                          .withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  )
                : null,
            onTap: () {
              context.read<WwaiCubit>().selectChat(chat.chatId);
              if (MediaQuery.sizeOf(context).width < 900) {
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
