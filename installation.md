# 🚀 Installation Guide

Welcome to the **Image Analysis** workshop! Follow these steps to set up your Flutter project with the necessary dependencies for state management and Gemini AI integration.

## 1. Add Dependencies

Run the following commands in your terminal (at the root of your project) to add the required packages.

### Core State Management (Riverpod + Hooks)

We use **Riverpod** for state management and **Flutter Hooks** for simplified widget life cycles.

```bash
flutter pub add hooks_riverpod
flutter pub add flutter_hooks
flutter pub add riverpod_annotation
```

### Development Tools (Code Generation)

These tools help generate the necessary boilerplate code for Riverpod and other services.

```bash
flutter pub add dev:riverpod_generator
flutter pub add dev:build_runner
```

## 2. Initialize Dependencies

After adding the packages, ensure everything is downloaded and linked correctly:

```bash
flutter pub get
```

## 3. Code Generation

Since we are using `riverpod_generator`, you will need to run the build runner whenever you create or modify a provider. You can run this command to generate the code once:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> **Tip:** If you are actively developing, you can use `watch` to automatically regenerate code on every save:
>
> ```bash
> flutter pub run build_runner watch --delete-conflicting-outputs
> ```

---

## 📦 What are these packages?

- **hooks_riverpod**: Combines Riverpod (state management) with Flutter Hooks.
- **flutter_hooks**: A Flutter implementation of React Hooks, making it easier to manage widget state and animations.
- **riverpod_annotation**: Provides the `@riverpod` annotation for code generation.
- **riverpod_generator**: The engine that generates the Riverpod providers for you.
- **build_runner**: A standard Flutter tool used to run code generators.
