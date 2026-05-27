// lib/features/chatbot/chatbot_screen.dart
//
// Chat UI: message bubbles, input field, suggested starter questions,
// loading indicator, error retry, and a permanent disclaimer banner.

import 'package:flutter/material.dart';
import '../../services/chat_service.dart';

class ChatbotScreen extends StatefulWidget {
  final ChatService chatService;
  const ChatbotScreen({super.key, required this.chatService});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _sending = false;
  String? _error;

  Future<void> _send([String? prefilled]) async {
    final text = (prefilled ?? _input.text).trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _error = null;
      _input.clear();
    });
    _scrollToBottom();

    try {
      await widget.chatService.sendMessage(text);
      if (mounted) setState(() => _sending = false);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        setState(() {
          _sending = false;
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _newChat() {
    setState(() {
      widget.chatService.clearHistory();
      _error = null;
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.chatService.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CerviAI Assistant'),
        backgroundColor: const Color(0xFF1F3864),
        foregroundColor: Colors.white,
        actions: [
          if (messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'New chat',
              onPressed: _newChat,
            ),
        ],
      ),
      body: Column(
        children: [
          // Disclaimer banner — always visible, always at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.amber.shade50,
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 16, color: Colors.amber.shade800),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'AI-generated educational info. Not medical advice — '
                    'consult a doctor for personal health concerns.',
                    style: TextStyle(
                        fontSize: 11, color: Colors.amber.shade900),
                  ),
                ),
              ],
            ),
          ),

          // Messages list (or starter screen if empty)
          Expanded(
            child: messages.isEmpty
                ? _StarterView(onPick: _send)
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length + (_sending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == messages.length) {
                        return const _TypingBubble();
                      }
                      return _MessageBubble(message: messages[i]);
                    },
                  ),
          ),

          // Error banner (with retry option)
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  Icon(Icons.error_outline,
                      size: 16, color: Colors.red.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(_error!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.red.shade900)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _error = null),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ),

          // Input row
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      enabled: !_sending,
                      decoration: InputDecoration(
                        hintText: 'Ask about cervical cancer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    color: const Color(0xFF1F3864),
                    onPressed: _sending ? null : _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Empty-state view: greeting + suggested starter questions
// =====================================================================
class _StarterView extends StatelessWidget {
  final void Function(String) onPick;
  const _StarterView({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFF1F3864),
            child: Icon(Icons.medical_services_outlined,
                color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Ask me about cervical cancer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'I can explain Pap smears, HPV, screening, prevention, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
        const SizedBox(height: 28),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Try asking:',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        ...ChatService.suggestedQuestions.map((q) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onPick(q),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(q,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Icon(Icons.arrow_forward,
                          size: 16, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

// =====================================================================
// Single message bubble
// =====================================================================
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF1F3864),
              child: Icon(Icons.medical_services_outlined,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF1F3864)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: SelectableText(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// =====================================================================
// "Typing..." animated bubble shown while waiting for API response
// =====================================================================
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFF1F3864),
            child: Icon(Icons.medical_services_outlined,
                color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final t = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
                    final scale = 0.5 + 0.5 *
                        (1 - (2 * t - 1).abs()).clamp(0.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1F3864),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
