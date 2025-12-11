import 'package:flutter/cupertino.dart';
import 'package:hr_plus/data/model/notification_model.dart';
import 'package:hr_plus/main.dart';

import '../../../core/core.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(this.notification, {super.key, this.onRead});

  final NotificationModel notification;
  final void Function()? onRead;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: () {
        // if (notification.unread == true) {
        onRead?.call();
        // }
      },
      color: AppColors.white,
      borderRadius: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(width: 1, color: AppColors.neutral100),
      ),
      padding: AppUtils.kPaddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.notification1),
              8.g,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeStorage.language == 'ru'
                          ? notification.titleRu ?? ''
                          : notification.titleUz ?? '',
                      style: AppTypography.medium16.copyWith(
                        color: AppColors.neutral800,
                      ),
                    ),
                    if (notification.contentUz != null &&
                        notification.contentRu != null) ...[
                      4.g,
                      Text(
                        localeStorage.language == 'ru'
                            ? notification.contentRu ?? ''
                            : notification.contentUz ?? '',
                        style: AppTypography.regular14.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (notification.unread == false)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning500,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          6.g,
          Row(
            children: [
              44.g,
              Text(
                DateFormat(
                  'dd.MM.yyyy HH:mm',
                ).format(DateTime.parse(notification.createdAt ?? '')),
                textAlign: TextAlign.end,
                style: AppTypography.regular14.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
