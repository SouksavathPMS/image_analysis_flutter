import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/constants.dart';
import '../logic/analysis_provider.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final notifier = ref.read(analysisProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.googleBlue),
            const SizedBox(width: AppSizes.sm),
            Text(
              AppStrings.appTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.sm),
            const Text(
              AppStrings.workshopTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Image Area - Card Style
            _ImageArea(imagePath: state.imagePath),
            const SizedBox(height: AppSizes.lg),

            // Action Buttons - Outlined/Elevated mix
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text(AppStrings.takePhoto),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => notifier.pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image_outlined),
                    label: const Text(AppStrings.chooseFromGallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Prompt Input
            const Text(
              'Input Prompt',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              decoration: InputDecoration(
                hintText: AppStrings.promptPlaceholder,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: const BorderSide(color: Color(0xFFDADCE0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide: const BorderSide(color: Color(0xFFDADCE0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  borderSide:
                      const BorderSide(color: AppColors.googleBlue, width: 2),
                ),
              ),
              onChanged: notifier.updatePrompt,
            ),
            const SizedBox(height: AppSizes.lg),

            // Analyze Button - Google Blue
            state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: notifier.analyzeImage,
                    icon: const Icon(Icons.auto_awesome, size: 20),
                    label: const Text(AppStrings.analyzeImage),
                  ),
            const SizedBox(height: AppSizes.xl),

            // Response Area
            if (state.response.isNotEmpty || state.isLoading) ...[
              const Row(
                children: [
                  Icon(Icons.assistant, color: AppColors.googleBlue, size: 20),
                  SizedBox(width: AppSizes.sm),
                  Text(
                    'Gemini Insights',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                  border: Border.all(color: const Color(0xFFDADCE0)),
                ),
                child: Text(
                  state.response,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImageArea extends StatelessWidget {
  final String? imagePath;

  const _ImageArea({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.imagePlaceholderHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: const Color(0xFFDADCE0)),
      ),
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              child: Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 48,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Capture or select an image',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
    );
  }
}
