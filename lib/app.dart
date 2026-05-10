import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/image_analysis/ui/analysis_screen.dart';

class ImageAnalysisApp extends StatelessWidget {
  const ImageAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Analysis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AnalysisScreen(),
    );
  }
}
