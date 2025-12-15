import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hr_plus/core/services/notification_service.dart';
import 'package:hr_plus/data/api/auth_api.dart';
import 'package:hr_plus/presentation/home/pages/home_page.dart';
import 'package:hr_plus/presentation/main/update_dialog.dart';
import 'package:hr_plus/presentation/profile/pages/profile_page.dart';
import 'package:hr_plus/presentation/report/pages/report_page.dart';

import '../../core/core.dart';
import '../../main.dart';
import 'bloc/main_cubit.dart' show MainCubit;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    if (shouldUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showUpdateDialog(context);
      });
    }
    NotificationService.getFcmToken().then((fcm) {
      if (fcm != null) {
        sl<AuthApi>().updateFcm(fcmToken: fcm, lang: localeStorage.language);
        showFcm(fcm);
      }
      log(fcm ?? '');
    });

    super.initState();
  }

  showFcm(String fcm) =>
      showAboutDialog(context: context, children: [SelectableText(fcm)]);

  final List<Widget> _screens = [
    HomePage(),
    ReportPage(),
    // AttendancePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, int>(
      builder: (context, state) {
        return PopScope(
          canPop: state == 0,
          onPopInvokedWithResult: (didPop, result) async {
            if (state != 0) {
              context.read<MainCubit>().changeIndex(0);
            }
          },
          child: Scaffold(
            extendBody: true,
            body: IndexedStack(
              key: ValueKey(localeStorage.language),
              index: state,
              children: _screens,
            ),
            bottomNavigationBar: Localizations.override(
              context: context,
              locale: context.savedLocale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.woodSmoke50,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: BottomNavigationBar(
                      showSelectedLabels: true,
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: state,
                      backgroundColor: AppColors.white,
                      items: [
                        item(
                          icon: Assets.home,
                          activeIcon: Assets.homeActive,
                          label: 'home',
                        ),
                        item(
                          icon: Assets.report,
                          activeIcon: Assets.reportActive,
                          label: 'report',
                        ),

                        // item(
                        //   icon: Assets.attendance,
                        //   activeIcon: Assets.attendanceActive,
                        //   label: 'attendance',
                        // ),
                        item(
                          icon: Assets.profile,
                          activeIcon: Assets.profileActive,
                          label: 'profile',
                        ),
                      ],
                      onTap: (index) {
                        context.read<MainCubit>().changeIndex(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  BottomNavigationBarItem item({
    required String icon,
    required String activeIcon,
    required String label,
    int? badgeCount,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(icon),

      label: label.tr(),
      activeIcon: SvgPicture.asset(activeIcon),
    );
  }
}
