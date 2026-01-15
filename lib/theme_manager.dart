import 'package:flutter/material.dart';

// Simple global theme manager using ValueNotifier so we don't add any
// extra package dependencies. The app listens to `themeModeNotifier` and
// updates its ThemeMode accordingly.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.dark);

void toggleThemeMode() {
  themeModeNotifier.value = themeModeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

void setThemeMode(ThemeMode mode) {
  themeModeNotifier.value = mode;
}

bool isDarkMode() => themeModeNotifier.value == ThemeMode.dark;