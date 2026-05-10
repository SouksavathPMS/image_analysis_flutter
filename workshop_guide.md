# 🎓 Workshop Guide: Image Analysis with Gemini & Flutter

Welcome to the hands-on portion of our workshop! This guide will walk you through the three main steps to transform this starter UI into a fully functional AI-powered application.

---

## ⏱️ Workshop Schedule (60 Mins)
- **00-10m:** Intro & Demo
- **10-20m:** Project Setup & API Keys
- **20-45m:** Hands-on Integration (The Core Build)
- **45-55m:** Customization & Polish
- **55-60m:** Q&A & Wrap-up

---

## 🛠️ Step 1: Project Setup (10-20m)

### 1.1 Generate your Gemini API Key
To use Gemini, you need an API Key. 
1. Go to [Google AI Studio](https://aistudio.google.com/).
2. Click on **"Get API key"**.
3. Create a new API key in a new project.
4. **Copy the key** and keep it safe!

### 1.2 Initialize the Project
If you haven't already, run these commands in your terminal:
```bash
flutter pub get
flutter pub run build_runner build
```

---

## 🧠 Step 2: The Core Build (20-45m)
*Branch: `step-2-core-build`*

In this section, we will implement the logic to send our image to Gemini.

### 2.1 Locate the Provider
Open `lib/features/image_analysis/logic/analysis_provider.dart`. You will see the `analyzeImage()` function.

### 2.2 Add the Gemini Logic
Replace the simulated delay with the real Gemini API call. You will need to:
1. Initialize the `GenerativeModel`.
2. Prepare the `Content` (Text prompt + Image bytes).
3. Call `model.generateContent()`.

> **Implementation Hint:**
> ```dart
> final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'YOUR_API_KEY');
> final content = [
>   Content.multi([
>     TextPart(state.prompt),
>     DataPart('image/jpeg', await File(state.imagePath!).readAsBytes()),
>   ])
> ];
> final response = await model.generateContent(content);
> ```

---

## ✨ Step 3: Customization & Polish (45-55m)
*Branch: `step-3-polish`*

Now that it works, let's make it better!

### 3.1 System Instructions
You can give Gemini a "personality" or specific instructions on how to respond.
*Example: "You are a professional art critic. Analyze this image and provide a sophisticated critique."*

### 3.2 Error Handling
Add try-catch blocks to handle network issues or invalid images gracefully.

### 3.3 UI Micro-animations
Improve the transition when the AI response appears.

---

## 🏁 Wrap-up (55-60m)

Congratulations! You've built a multimodal AI app in under an hour. 

### Useful Links:
- [Google AI SDK for Dart](https://pub.dev/packages/google_generative_ai)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)

---
*Built for Build with AI 2026*
