import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../logic/chat_provider.dart';
import 'widgets/chat_input.dart';
import 'widgets/message_bubble.dart';
import 'widgets/model_selector.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gemini AI',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          const Center(child: ModelSelector()),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white54),
            onPressed: () => _showClearConfirmation(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          if (chatState.errorMessage != null)
            Container(
              width: double.infinity,
              color: Colors.redAccent.withOpacity(0.2),
              padding: const EdgeInsets.all(8),
              child: Text(
                chatState.errorMessage!,
                style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    reverse: false,
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: chatState.messages[index]);
                    },
                  ),
          ),
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TypingIndicator(),
            ),
          const ChatInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            'Start a conversation with Gemini',
            style: GoogleFonts.inter(color: Colors.white24),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text('Clear Chat?', style: GoogleFonts.outfit(color: Colors.white)),
        content: Text('This will delete all messages permanently.',
            style: GoogleFonts.inter(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              Navigator.pop(context);
            },
            child: Text('Clear', style: GoogleFonts.inter(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            'Gemini is thinking',
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
