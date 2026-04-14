import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RafeeqApp(),
    ),
  );
}

class RafeeqApp extends StatelessWidget {
  const RafeeqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rafeeq',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
