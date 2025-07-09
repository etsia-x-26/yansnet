import 'package:flutter/material.dart';
import 'package:yansnet/app/router/app_router.dart';
import 'package:yansnet/counter/counter.dart';
import 'package:yansnet/l10n/l10n.dart';

class AppDev extends StatelessWidget {
  const AppDev({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter();
    return MaterialApp.router(
      title: 'Yansnet Dev',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
