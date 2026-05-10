import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  /// Simulates analyzing the image with Gemini
  Future<void> analyzeImage() async {
    if (state.imagePath == null) {
      state = state.copyWith(response: 'Please select an image first.');
      return;
    }

    state = state.copyWith(isLoading: true, response: '');

    // TODO: Add Gemini API logic here
    // For now, we simulate a delay to show the loading indicator
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      isLoading: false,
      response:
          'This is a placeholder response. Attendees will implement Gemini logic here!',
    );
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
