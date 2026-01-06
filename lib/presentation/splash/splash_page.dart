import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/pages/login_page.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/report/bloc/reports_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../core/core.dart';
import '../main/main_page.dart';
import '../profile/bloc/profile_cubit.dart' show ProfileCubit;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();

    if (localeStorage.isLoggedIn) {
      _apiCalls();
    }
    Future.delayed(Duration(milliseconds: 1500)).then((e) {
      if (!localeStorage.isLoggedIn) {
        localeStorage.setFirstLaunch();
        pushAndRemoveAll(LoginPage());
      } else {
        pushAndRemoveAll(const MainPage());
      }
    });
    super.initState();
  }

  void _apiCalls() {
    context.read<ProfileCubit>().getMe();
    context.read<HomeCubit>().getAttendance();
    context.read<ReportsCubit>().getReports();
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  void dispose() {
    _animationController.dispose(); // <--- CRITICAL: Dispose the controller
    super.dispose(); // Call super.dispose() last
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(Assets.appLogo, height: 48, width: 48),
                ),
                16.g,
                Text(
                  'HR PULSE',
                  style: AppTypography.bold28.copyWith(
                    color: AppColors.neutral800,
                    height: 9 / 7,
                  ),
                ),
                64.g,
                // Image.asset(Assets.splash),
              ],
            ),
          ),

          Positioned(
            bottom: 120,
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
