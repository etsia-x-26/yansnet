import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yansnet/app/router/app_router.dart';
import 'package:yansnet/app/theme/app_theme.dart';
import 'package:yansnet/authentication/cubit/authentication_cubit.dart';
import 'package:yansnet/l10n/l10n.dart';
import 'package:yansnet/template/api/authentication_client.dart';

class AppDev extends StatelessWidget {
  const AppDev({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = AuthenticationCubit(authClient: AuthenticationClient());
    final router = AppRouter.createRouter(authCubit);
    return MultiBlocProvider(
      providers: [BlocProvider<AuthenticationCubit>.value(value: authCubit)],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Yansnet Dev',
          theme: AppTheme.getLightTheme(),
          themeMode: ThemeMode.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  }
}
