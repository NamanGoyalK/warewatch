import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:warewatch/features/home/presentation/cubits/home_navigation_cubit.dart';
import 'package:warewatch/features/home/presentation/cubits/home_navigation_state.dart';

import '../data/datasources/wwai_remote_data_source.dart';
import '../data/repositories/wwai_repository_impl.dart';
import 'cubits/wwai_cubit.dart';
import 'cubits/wwai_state.dart';
import 'widgets/chat_sidebar.dart';
import 'widgets/composer.dart';
import 'widgets/empty_chat_state.dart';
import 'widgets/message_bubble.dart';

class WwaiScreen extends StatefulWidget {
  const WwaiScreen({super.key});

  @override
  State<WwaiScreen> createState() => _WwaiScreenState();
}

class _WwaiScreenState extends State<WwaiScreen> {
  late final TextEditingController _messageController;
  late final FocusNode _composerFocusNode;
  late final ScrollController _messagesScrollController;
  late final WwaiCubit _cubit;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _composerFocusNode = FocusNode(canRequestFocus: true, skipTraversal: true);
    _messagesScrollController = ScrollController();
    _cubit = WwaiCubit(
      WwaiRepositoryImpl(remoteDataSource: WwaiRemoteDataSource()),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _dismissComposerKeyboard(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit.initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _composerFocusNode.dispose();
    _messagesScrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _dismissComposerKeyboard() {
    if (!mounted) return;
    _composerFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _scrollToBottom({required bool isStreaming}) {
    if (!_messagesScrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_messagesScrollController.hasClients) return;

      final position = _messagesScrollController.position;

      if (position.maxScrollExtent - position.pixels <= 300) {
        if (isStreaming) {
          _messagesScrollController.jumpTo(position.maxScrollExtent);
        } else {
          _messagesScrollController.animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messagesScrollController.hasClients) {
        _messagesScrollController.jumpTo(
          _messagesScrollController.position.maxScrollExtent,
        );
      }
    });

    await _cubit.sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final colorScheme = Theme.of(context).colorScheme;
    final isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<HomeNavigationCubit, HomeNavigationState>(
        listenWhen: (previous, current) =>
            previous.currentIndex != current.currentIndex,
        listener: (context, state) => _dismissComposerKeyboard(),
        child: BlocConsumer<WwaiCubit, WwaiState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              _showMessage(state.errorMessage!);
            }
            if (state.messages.isNotEmpty) {
              _scrollToBottom(isStreaming: state.isSending);
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: isDesktop
                  ? null
                  : AppBar(
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      scrolledUnderElevation: 0,
                      elevation: 0,
                      forceMaterialTransparency: true,
                      centerTitle: true,
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.memory,
                            color: colorScheme.tertiary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'WW/AI',
                            style: GoogleFonts.shareTechMono(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
              drawer: isDesktop
                  ? null
                  : Drawer(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      width: double.infinity,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ChatSidebar(state: state),
                    ),
              body: SafeArea(
                bottom: !isKeyboardOpen,
                child: Row(
                  children: [
                    if (isDesktop)
                      SizedBox(
                        width: 320,
                        child: Material(
                          color: colorScheme.surface.withAlpha(150),
                          child: ChatSidebar(state: state),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          if (isDesktop) _buildDesktopHeader(),
                          Expanded(
                            child: _buildChatArea(state, isKeyboardOpen),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.memory,
            color: Theme.of(context).colorScheme.tertiary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Godrej Warehouse Intelligence',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(WwaiState state, bool isKeyboardOpen) {
    return Column(
      children: [
        Expanded(
          child: state.messages.isEmpty
              ? const EmptyChatState()
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: ListView.separated(
                      controller: _messagesScrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: state.messages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 28),
                      itemBuilder: (context, index) {
                        return MessageBubble(message: state.messages[index]);
                      },
                    ),
                  ),
                ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, isKeyboardOpen ? 8 : 16),
              child: Composer(
                controller: _messageController,
                focusNode: _composerFocusNode,
                isBusy: state.isSending,
                onSend: _sendMessage,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
