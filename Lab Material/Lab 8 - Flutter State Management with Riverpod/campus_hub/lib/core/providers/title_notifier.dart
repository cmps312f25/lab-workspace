import 'package:flutter_riverpod/flutter_riverpod.dart';

// Title Notifier for dynamic app bar titles
class TitleNotifier extends Notifier<String> {
  @override
  String build() {
    return 'Campus Hub';
  }

  void setTitle(String title) {
    state = title;
  }
}

// Global provider
final titleNotifierProvider = NotifierProvider<TitleNotifier, String>(
  () => TitleNotifier(),
);
