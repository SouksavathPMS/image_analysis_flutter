import 'package:flutter/foundation.dart';
import 'chat_message.dart';

@immutable
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;
  final String selectedModel;
  final String? pendingImagePath;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedModel = 'gemini-2.5-flash',
    this.pendingImagePath,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
    String? selectedModel,
    String? pendingImagePath,
    bool clearPendingImage = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedModel: selectedModel ?? this.selectedModel,
      pendingImagePath: clearPendingImage ? null : (pendingImagePath ?? this.pendingImagePath),
    );
  }
}
