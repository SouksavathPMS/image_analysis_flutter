import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analysis_provider.g.dart';

@riverpod
class Analysis extends _$Analysis {
  final ImagePicker _picker = ImagePicker();
  late String apiKey;
  late String model;

  @override
  AnalysisState build() {
    apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    model = 'gemini-2.5-flash';

    return const AnalysisState();
  }

  Future<bool> checkConnectivity() async {
    try {
      final result =
          await InternetAddress.lookup('generativelanguage.googleapis.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false; // DNS failed — network or region issue
    }
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

  /// Simulates analyzing the image with Gemini
  Future<void> analyzeImage() async {
    if (state.imagePath == null) {
      state = state.copyWith(response: 'Please select an image first.');
      return;
    }

    if (apiKey.isEmpty) {
      state =
          state.copyWith(response: 'Please set your API key in the .env file.');
      return;
    }

    state = state.copyWith(isLoading: true, response: '');

    try {
      final result = await checkConnectivity();
      if (!result) {
        state =
            state.copyWith(response: 'Please check your internet connection.');
        return;
      }
      final generativeModel = GenerativeModel(
        model: model,
        apiKey: apiKey,
        systemInstruction: Content.system(
          'You are a helpful and creative AI assistant in a Build with AI workshop. '
          'Your goal is to analyze images accurately and provide engaging, informative responses. '
          'Always keep your tone professional yet friendly.',
        ),
      );
      final bytes = await File(state.imagePath!).readAsBytes();
      final content = [
        Content.multi([
          TextPart(state.prompt),
          DataPart('image/jpeg', bytes),
        ])
      ];
      final response = await generativeModel.generateContent(content);
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
