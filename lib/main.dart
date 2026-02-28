import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const WinBoostAdminApp());
}

class WinBoostAdminApp extends StatelessWidget {
  const WinBoostAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WinBoost Admin',
      theme: AppTheme.darkTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
