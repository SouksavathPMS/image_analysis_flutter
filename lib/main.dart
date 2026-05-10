import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app.dart';

void main() {
  // Wrap the entire app in a ProviderScope to enable Riverpod
  runApp(const ProviderScope(child: ImageAnalysisApp()));
}
