import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/session_manager.dart';
import '../../../domain/entity/conversation/message.dart';
import '../../bloc/conversation/conversation_bloc.dart';
import '../../bloc/auth/guest_auth/guest_auth_bloc.dart';

class ChatPage extends StatefulWidget {
  static const String ROUTE_NAME = '/chat_page';

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String? _sessionId;
  final List<Message> _messages = [];
  bool _isAuthenticated = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final token = await SessionManager.getToken();

    if (token == null || token.isEmpty) {
      if (mounted) {
        setState(() => _isInitializing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login first'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    _startOrResumeConversation();
  }

  Future<void> _startOrResumeConversation() async {
    setState(() => _isAuthenticated = true);

    final sessionId = await SessionManager.getSessionId();

    if (sessionId != null && sessionId.isNotEmpty) {
      setState(() => _sessionId = sessionId);
      if (mounted) {
        context.read<ConversationBloc>().add(
          LoadConversationHistory(sessionId: sessionId),
        );
      }
    } else {
      if (mounted) {
        context.read<ConversationBloc>().add(const StartConversation());
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty || _sessionId == null) return;

    setState(() {
      _messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch,
          role: 'user',
          content: message,
          createdAt: DateTime.now(),
        ),
      );
    });

    context.read<ConversationBloc>().add(
      SendMessage(sessionId: _sessionId!, message: message),
    );

    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/robot.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 4),
            const Text(
              'Aira',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<ConversationBloc, ConversationState>(
        listener: (context, state) {
          if (state is ConversationStarted) {
            setState(() {
              _sessionId = state.conversation.sessionId;
              _isInitializing = false;
              _messages.add(
                Message(
                  id: DateTime.now().millisecondsSinceEpoch,
                  role: 'assistant',
                  content: state.conversation.message,
                  createdAt: DateTime.now(),
                ),
              );
            });
            _scrollToBottom();
          }

          if (state is MessageReceived) {
            setState(() {
              _messages.add(
                Message(
                  id: DateTime.now().millisecondsSinceEpoch,
                  role: 'assistant',
                  content: state.response.assistantMessage,
                  createdAt: DateTime.now(),
                ),
              );
            });
            _scrollToBottom();
          }

          if (state is ConversationHistoryLoaded) {
            setState(() {
              _isInitializing = false;
              _messages.clear();
              _messages.addAll(state.history.messages);
            });
            _scrollToBottom();
          }

          if (state is ConversationCompleted) {
            SessionManager.setConversationCompleted(true);
            Navigator.pushReplacementNamed(
              context,
              '/budget_loading_page',
              arguments: state.response.budgets,
            );
          }

          if (state is ConversationError) {
            setState(() => _isInitializing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        // Show typing bubble for initial loading instead of spinner
        if (_isInitializing ||
            (state is ConversationLoading && _messages.isEmpty)) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [_buildTypingIndicator()],
          );
        }

        if (_messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mulai percakapan dengan Aira',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length + (state is MessageSending ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _messages.length && state is MessageSending) {
              return _buildTypingIndicator();
            }

            final message = _messages[index];
            final isUser = message.role == 'user';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isUser ? null : const Color(0xFF6B7A99),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isUser
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                    bottomRight: isUser
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
                  ),
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF6B7A99),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(),
            const SizedBox(width: 4),
            _buildDot(),
            const SizedBox(width: 4),
            _buildDot(),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1A1B2E),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3B4E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) {
                          _sendMessage();
                          _focusNode.requestFocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                final isSending = state is MessageSending;
                final hasText = _messageController.text.trim().isNotEmpty;

                return GestureDetector(
                  onTap: (isSending || !hasText) ? null : _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: (isSending || !hasText)
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: (isSending || !hasText)
                          ? const Color(0xFF3A3B4E)
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white54,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: hasText
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              size: 20,
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
