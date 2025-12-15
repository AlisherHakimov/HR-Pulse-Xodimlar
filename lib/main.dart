import 'dart:async';
import 'package:hr_plus/core/services/notification_service.dart';
import 'package:hr_plus/presentation/auth/bloc/reset_password/reset_password_cubit.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/language/bloc/language_cubit.dart';
import 'package:hr_plus/presentation/main/update_dialog.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/profile/bloc/permission/permission_cubit.dart';
import 'package:hr_plus/presentation/report/bloc/reports_cubit.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_plus/presentation/main/bloc/main_cubit.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';
import 'package:hr_plus/presentation/splash/splash_page.dart';
import 'core/theme/theme.dart';
import 'data/di/di_container.dart';
import 'data/storage/local_storage.dart';
import 'package:flutter_alice/alice.dart';

LocalStorage localeStorage = LocalStorage();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final alice = Alice(
  navigatorKey: navigatorKey,
  showNotification: true,
  showInspectorOnShake: true,
);

Future<void> main() async {
  await localeStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  await initDi();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('uz', 'UZ'),
        Locale('ru', 'RU'),
        Locale('uz', 'Cyrl'),
      ],
      fallbackLocale: const Locale('uz', 'UZ'),
      path: 'assets/translations',
      startLocale: const Locale('uz', 'UZ'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getAppUpdateResponse();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => ReportsCubit()),
        BlocProvider(create: (context) => ResetPasswordCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => NotificationCubit()),
        BlocProvider(create: (context) => PermissionCubit()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,

          locale: context.locale,
          title: 'HR PULSE',
          home: const SplashPage(),
          initialRoute: '/',
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
