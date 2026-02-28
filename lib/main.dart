import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection.dart';
import 'routing/app_router.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const WinBoostAdminApp());
}

class WinBoostAdminApp extends StatelessWidget {
  const WinBoostAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: MaterialApp.router(
        title: 'WinBoost Admin',
        theme: AppTheme.darkTheme,
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
