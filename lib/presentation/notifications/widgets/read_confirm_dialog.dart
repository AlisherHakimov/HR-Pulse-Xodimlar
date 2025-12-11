import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/presentation/notifications/bloc/notification_cubit.dart';

void showReadNotificationConfirmationDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String confirmTitle,

  String? unConfirmTitle,
  VoidCallback? onConfirm,
  String? icon,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) SvgPicture.asset(icon!, height: 80, width: 80),

          const SizedBox(height: 16),
          Text(
            title ?? 'success'.tr(),
            style: AppTypography.semibold18.copyWith(
              color: AppColors.neutral800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle ?? '',
            style: AppTypography.regular14.copyWith(
              color: AppColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppButton(
                onTap: () => Navigator.of(context).pop(),
                background: AppColors.neutral100,
                title: (unConfirmTitle ?? 'cancel').tr(),
                borderRadius: 8,
                height: 48,
                titleTextStyle: AppTypography.medium16.copyWith(
                  color: AppColors.neutral900,
                ),
              ),
            ),
            12.g,
            Expanded(
              flex: 2,
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  return AppButton(
                    onTap: () {
                      context.read<NotificationCubit>().readAllNotifications(
                        onError: (err) => showError(context, err),
                        onSuccess: () => context.pop(),
                      );
                    },
                    borderRadius: 8,

                    height: 48,
                    background: AppColors.primary,
                    title: confirmTitle.tr(),
                    isLoading: state.readStatus.isLoading,
                    titleTextStyle: AppTypography.medium16.copyWith(
                      color: AppColors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
