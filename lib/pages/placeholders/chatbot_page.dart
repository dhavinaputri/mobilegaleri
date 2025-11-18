import 'package:flutter/material.dart';
import '../../data/app_services.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
      _messages.add(_ChatMessage(role: 'user', content: text));
      _controller.clear();
    });

    try {
      final contextHistory = _messages
          .map((m) => {'role': m.role == 'assistant' ? 'assistant' : 'user', 'content': m.content})
          .toList();
      final answer = await apiService.chatbotAsk(text, context: contextHistory);
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: answer.toString()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghubungi chatbot: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot Eduspot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isUser ? scheme.primary : scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isUser ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tanyakan tentang SMKN 4 Bogor atau pendidikan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  color: scheme.primary,
                  onPressed: _isSending ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String role; // 'user' atau 'assistant'
  final String content;

  _ChatMessage({required this.role, required this.content});
}
