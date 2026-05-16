import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../logic/chat_provider.dart';

class ModelSelector extends ConsumerWidget {
  const ModelSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: chatState.selectedModel,
          dropdownColor: const Color(0xFF1A1A1A),
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
          onChanged: (value) {
            if (value != null) {
              ref.read(chatProvider.notifier).setModel(value);
            }
          },
          items: const [
            DropdownMenuItem(
              value: 'gemini-2.5-flash',
              child: Text('Gemini 2.5 Flash'),
            ),
            DropdownMenuItem(
              value: 'gemini-2.5-pro',
              child: Text('Gemini 2.5 Pro'),
            ),
          ],
        ),
      ),
    );
  }
}
