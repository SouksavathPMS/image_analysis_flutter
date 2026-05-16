import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../models/chat_state.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState()) {
    _loadHistory();
  }

  GenerativeModel? _model;
  final _picker = ImagePicker();
  static const _historyKey = 'chat_history';

  void setModel(String modelName) {
    state = state.copyWith(selectedModel: modelName);
    _initModel();
  }

  void _initModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      state = state.copyWith(errorMessage: 'API Key not found');
      return;
    }

    _model = GenerativeModel(
      model: state.selectedModel,
      apiKey: apiKey,
      systemInstruction: Content.system(
        'You are a versatile and highly capable AI assistant powered by Google Gemini. \n'
        'Your goal is to be helpful, concise, and visually organized.\n'
        'Guidelines:\n'
        '1. Context: You can see images and read text. If an image is provided, analyze it thoroughly to answer the user\'s request.\n'
        '2. Formatting: Use Markdown for all responses. Use bold text for emphasis and clear code blocks for any technical snippets.\n'
        '3. Tone: Maintain a professional yet friendly persona. \n'
        '4. Constraints: If a user asks about your model, confirm you are running on the Gemini 1.5 infrastructure. If you are unsure about something in an image, state your observations clearly rather than hallucinating facts.\n'
        'System Identity: "Gemini Flutter Assistant"',
      ),
    );
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      final messages = decoded.map((item) => ChatMessage.fromJson(item)).toList();
      state = state.copyWith(messages: messages);
    }
    _initModel();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(state.messages.map((m) => m.toJson()).toList());
    await prefs.setString(_historyKey, historyJson);
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state = state.copyWith(pendingImagePath: image.path);
    }
  }

  void clearPendingImage() {
    state = state.copyWith(clearPendingImage: true);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty && state.pendingImagePath == null) return;

    final userMessage = ChatMessage(
      text: text,
      role: MessageRole.user,
      imagePath: state.pendingImagePath,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      errorMessage: null,
    );

    final currentImagePath = state.pendingImagePath;
    state = state.copyWith(clearPendingImage: true);

    try {
      if (_model == null) _initModel();

      final List<Content> history = state.messages.take(state.messages.length - 1).map((m) {
        if (m.role == MessageRole.user) {
          // Note: Multi-part history with images is tricky in some SDK versions, 
          // but usually we just send the text for previous turns if we don't store bytes.
          return Content.text(m.text);
        } else {
          return Content.model([TextPart(m.text)]);
        }
      }).toList();

      final List<Part> parts = [TextPart(text)];
      if (currentImagePath != null) {
        final bytes = await File(currentImagePath).readAsBytes();
        parts.add(DataPart('image/jpeg', bytes));
      }

      final chat = _model!.startChat(history: history);
      final response = await chat.sendMessage(Content.multi(parts));
      
      final assistantMessage = ChatMessage(
        text: response.text ?? 'No response',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );
      _saveHistory();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: ${e.toString()}',
      );
    }
  }

  Future<void> clearChat() async {
    state = state.copyWith(messages: []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
