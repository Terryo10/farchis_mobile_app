import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/theme/theme_cubit.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/router/app_router.dart';

class FarchisApp extends StatefulWidget {
  const FarchisApp({super.key});

  @override
  State<FarchisApp> createState() => _FarchisAppState();
}

class _FarchisAppState extends State<FarchisApp> {
  late DIContainer _diContainer;

  @override
  void initState() {
    super.initState();
    _diContainer = DIContainer();
    _diContainer.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _diContainer.getRepositoryProviders(),
      child: MultiBlocProvider(
        providers: _diContainer.getBlocProviders(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDark = themeState is ThemeDarkState;

            return MaterialApp.router(
              title: 'Farchis',
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
