import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'analysis_provider.g.dart';

@riverpod
class Analysis extends _$Analysis {
  final ImagePicker _picker = ImagePicker();

  @override
  AnalysisState build() {
    return const AnalysisState();
  }

  /// Picks an image from the specified source (camera or gallery)
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        state = state.copyWith(imagePath: image.path, response: '');
      }
    } catch (e) {
      state = state.copyWith(response: 'Error picking image: $e');
    }
  }

  /// Updates the prompt text
  void updatePrompt(String prompt) {
    state = state.copyWith(prompt: prompt);
  }

  /// Analyzes the image using Gemini API
  Future<void> analyzeImage() async {
    if (state.imagePath == null) {
      state = state.copyWith(response: 'Please select an image first.');
      return;
    }

    state = state.copyWith(isLoading: true, response: '');

    try {
      // 1. Initialize the model
      // TODO: In a real app, don't hardcode your API key!
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      );

      // 2. Prepare the content (Prompt + Image)
      final bytes = await File(state.imagePath!).readAsBytes();
      final content = [
        Content.multi([
          TextPart(state.prompt),
          DataPart('image/jpeg', bytes),
        ])
      ];

      // 3. Generate content
      final response = await model.generateContent(content);
      
      state = state.copyWith(
        isLoading: false,
        response: response.text ?? 'No response from Gemini.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        response: 'Error: $e',
      );
    }
  }
}

/// The state class for our Image Analysis feature
class AnalysisState {
  final String? imagePath;
  final String prompt;
  final String response;
  final bool isLoading;

  const AnalysisState({
    this.imagePath,
    this.prompt = 'What is in this picture?',
    this.response = '',
    this.isLoading = false,
  });

  AnalysisState copyWith({
    String? imagePath,
    String? prompt,
    String? response,
    bool? isLoading,
  }) {
    return AnalysisState(
      imagePath: imagePath ?? this.imagePath,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
