import 'package:flutter/material.dart';
import 'package:hr_plus/core/components/empty_widget.dart';
import 'package:hr_plus/data/model/notification_model.dart';
import 'package:hr_plus/presentation/main/bloc/main_cubit.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';
import 'package:hr_plus/presentation/notifications/widgets/notification_card.dart';
import 'package:hr_plus/presentation/notifications/widgets/read_confirm_dialog.dart';
import 'package:hr_plus/presentation/profile/bloc/permission/permission_cubit.dart';
import 'package:hr_plus/presentation/profile/pages/permissions_page.dart';
import 'package:hr_plus/presentation/profile/widgets/permission_detail_sheet.dart';

import '../../../core/core.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    context.read<NotificationCubit>().getNotifications(page: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBg,
      appBar: CustomAppBar(
        title: 'notifications'.tr(),
        isBackBtn: true,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (ctx, state) {
              if (state.unreadCount == 0) return SizedBox();
              return IconButton(
                onPressed: () {
                  showReadNotificationConfirmationDialog(
                    context,
                    icon: Assets.confirmRedNotificationIcon,
                    title: 'marking'.tr(),
                    subtitle: 'marking_desc'.tr(),
                    confirmTitle: 'marking'.tr(),
                  );
                },
                icon: Icon(Icons.check),
              );
            },
          ),
          8.g,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<NotificationCubit>().getNotifications(page: 1);
        },
        child: SafeArea(
          child: BlocBuilder<NotificationCubit, NotificationState>(
            bloc: context.read<NotificationCubit>(),
            builder: (context, state) {
              if (state.notifications.isNotEmpty) {
                return VerticalListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: state.notifications.length,
                  itemBuilder: (ctx, i) => NotificationCard(
                    state.notifications[i],
                    onRead: () {
                      context.read<NotificationCubit>().readNotification(
                        state.notifications[i].id ?? '',
                      );
                      _navigateToPage(state.notifications[i]);
                    },
                  ),
                  padding: AppUtils.kPaddingAll16,
                  onLoadMore: () {
                    context.read<NotificationCubit>().getNotifications(
                      page: state.page + 1,
                    );
                  },
                );
              } else if (state.status == BlocStatus.loading) {
                return Loader();
              }
              return EmptyWidget(
                title: 'notifications',
                subtitle: 'not_have_notification',
                icon: Assets.emptyNotification,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToPage(NotificationModel model) async {
    if (model.targetObject == "SCHEDULE") {
      context.push(PermissionsPage());
    }
    if (model.targetObject == "ATTENDANCE") {
      // AttendanceSheet.show(context, model:);
    }
  }
}
