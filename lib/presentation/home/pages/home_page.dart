import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/home/bloc/home_cubit.dart';
import 'package:hr_plus/presentation/home/widgets/home_top_card.dart';
import 'package:hr_plus/presentation/home/widgets/attendance_section.dart';
import 'package:hr_plus/presentation/home/widgets/user_info_widget.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/notifications/pages/notifications_page.dart';
import 'package:hr_plus/presentation/profile/bloc/profile_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary100,

      // appBar:
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProfileCubit>().getMe();
          context.read<HomeCubit>().getAttendance();
        },
        color: AppColors.primary,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.attendances.isEmpty && state.status.isLoading) {
              return Container(
                height: context.height,
                width: double.infinity,
                color: Colors.white,
                child: Loader(),
              );
            }
            // return SizedBox();
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: 'home'.tr(),
                      centerTitle: false,
                      backgroundColor: AppColors.primary100,
                      hasBottom: false,
                      actions: [
                        BlocBuilder<NotificationCubit, NotificationState>(
                          builder: (context, state) {
                            return Badge(
                              label: Text(state.unreadCount.toString()),
                              isLabelVisible: state.unreadCount != 0,
                              backgroundColor: AppColors.warning500,
                              child: CustomMaterialButton(
                                height: 36,
                                width: 36,
                                color: AppColors.primary50,
                                borderRadius: 8,
                                padding: EdgeInsets.all(8),
                                child: SvgPicture.asset(Assets.notification),
                                onTap: () => context.push(NotificationsPage()),
                              ),
                            );
                          },
                        ),
                        16.g,
                      ],
                    ),
                    UserInfoWidget(),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      width: context.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          HomeTopCard(),
                          Stack(
                            children: [
                              Container(
                                color: AppColors.white,
                                height: context.height - 450,
                              ),

                              AttendanceSection(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
