import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_shell.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WashupApp());
}

class WashupApp extends StatelessWidget {
  const WashupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..load(),
      child: MaterialApp(
        title: 'Washup',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const _AppRoot(),
      ),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final loading = context.select<AppState, bool>((s) => s.loading);
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const HomeShell();
  }
}
