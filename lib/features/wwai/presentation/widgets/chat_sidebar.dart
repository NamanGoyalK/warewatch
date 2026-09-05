import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warewatch/common/widgets/atmospheric_background.dart';

import '../../domain/entities/chat_summary.dart';
import '../cubits/wwai_cubit.dart';
import '../cubits/wwai_state.dart';

class ChatSidebar extends StatefulWidget {
  const ChatSidebar({super.key, required this.state});

  final WwaiState state;

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  late final TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void didUpdateWidget(covariant ChatSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.searchQuery != _searchController.text &&
        widget.state.searchQuery.isEmpty) {
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<WwaiCubit>().searchChats(query);
      }
    });
    setState(() {});
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    context.read<WwaiCubit>().clearSearch();
    setState(() {});
  }

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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  if (MediaQuery.sizeOf(context).width < 900)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: colorScheme.surface,
                          foregroundColor: colorScheme.onSurface,
                          shape: const CircleBorder(),
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.5),
                            width: 1,
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
                        backgroundColor: colorScheme.surface,
                        foregroundColor: colorScheme.onSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      onPressed: widget.state.isSending
                          ? null
                          : () {
                              if (MediaQuery.sizeOf(context).width < 900) {
                                Navigator.of(context).pop();
                              }
                              _clearSearch();
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor:
                      colorScheme.surfaceContainerHighest.withAlpha(120),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.state.hasSearchQuery
                        ? 'SEARCH RESULTS'
                        : 'RECENT CHATS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (widget.state.hasSearchQuery &&
                      !widget.state.isSearching)
                    Text(
                      '${widget.state.searchResults.length} found',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: _buildChatsList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList(BuildContext context) {
    final state = widget.state;

    if (state.isSearching) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    if (state.hasSearchQuery) {
      if (state.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 32,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withAlpha(100),
              ),
              const SizedBox(height: 12),
              Text(
                'No chats found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }
      return _buildChatItems(context, state.searchResults);
    }

    if (state.isLoadingChats && state.recentChats.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
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

    return _buildChatItems(context, state.recentChats);
  }

  Widget _buildChatItems(BuildContext context, List<ChatSummary> chats) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final isSelected = chat.chatId == widget.state.activeChatId;
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
            selectedTileColor: colorScheme.surfaceContainerHighest.withAlpha(
              160,
            ),
            leading: Icon(
              Icons.chat_bubble_outline,
              size: 20,
              color: colorScheme.onSurface.withValues(
                alpha: isSelected ? 0.85 : 0.45,
              ),
            ),
            title: Text(
              chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: colorScheme.onSurface,
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
