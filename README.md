# Build with AI: Seeing the World through AI: Image Analysis in Flutter 🚀

Welcome to the **"Seeing the World through AI: Image Analysis in Flutter"** workshop! In this session, you will learn how to build a smart Flutter application that uses the **Google Gemini Multimodal Vision API** to analyze images and answer questions about them.

## 🌟 Project Overview

This is a starter project designed to get you up and running quickly. We have provided a polished, Google-branded User Interface so you can focus on the most exciting part: **Integrating Gemini AI**.

### Features

- 📸 **Capture Photos**: Use the camera to take a picture for analysis.
- 🖼️ **Gallery Selection**: Choose existing photos from your device.
- 💬 **Interactive Prompts**: Ask specific questions about your images.
- 🤖 **Gemini AI Integration**: (Your Task!) Connect the app to Gemini Pro Vision.

---

## 🛠️ Tech Stack

- **Flutter**: Cross-platform UI framework.
- **Riverpod**: Modern state management with code generation.
- **Google Generative AI SDK**: The bridge to Gemini.
- **Image Picker**: For handling camera and gallery access.

---

## 🚀 Getting Started

### 1. Prerequisites

Before you begin, ensure you have the Flutter SDK installed and your development environment set up.

### 2. Installation

Follow the detailed steps in [installation.md](./installation.md) to install dependencies and set up the project.

```bash
flutter pub get
flutter pub run build_runner build
```

### 3. Obtain a Gemini API Key

You will need an API key to use Gemini. Head over to [Google AI Studio](https://aistudio.google.com/) to create your free API key.

---

## 🎯 Your Workshop Goal

Your mission today is to implement the backend logic that sends the selected image and user prompt to Gemini and displays the response.

**Where to write your code:**
Open `lib/features/image_analysis/logic/analysis_provider.dart` and look for the following comment:

```dart
// TODO: Add Gemini API logic here
```

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/    # Colors (Google branding) and Strings
│   └── theme/        # Material 3 theme configuration
├── features/
│   └── image_analysis/
│       ├── logic/    # Riverpod providers (Your logic goes here!)
│       └── ui/       # Screen and widget layouts
├── app.dart          # Root Material App
└── main.dart         # Entry point
```

---

## 🤝 Need Help?

If you get stuck, don't hesitate to ask the workshop mentors. Happy coding!

_Built for Build with AI 2026_
