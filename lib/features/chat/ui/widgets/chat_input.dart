import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../logic/chat_provider.dart';

class ChatInput extends HookConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final chatState = ref.watch(chatProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chatState.pendingImagePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(chatState.pendingImagePath!),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () => ref.read(chatProvider.notifier).clearPendingImage(),
                    ),
                  ),
                ],
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.blueAccent),
                      onPressed: () => ref.read(chatProvider.notifier).pickImage(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: GoogleFonts.inter(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: GoogleFonts.inter(color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: chatState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: chatState.isLoading
                          ? null
                          : () {
                              final text = controller.text;
                              if (text.isNotEmpty || chatState.pendingImagePath != null) {
                                ref.read(chatProvider.notifier).sendMessage(text);
                                controller.clear();
                              }
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
