import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/permission_model.dart';

class PermissionCard extends StatelessWidget {
  PermissionCard({super.key, required this.permission, required this.onTap});

  final PermissionModel permission;
  final Function() onTap;

  final _dateFormat1 = DateFormat('dd.MM.yyyy');
  final _dateFormat2 = DateFormat('hh:mm');

  @override
  Widget build(BuildContext context) {
    final status = (permission.status ?? '').toPermissionStatus;
    DateTime start = DateTime.parse(permission.start ?? '');
    DateTime end = DateTime.parse(permission.end ?? '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColors.neutral100),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: SvgPicture.asset(Assets.permissions),
                ),
                Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (start.day == end.day &&
                                start.month == end.month &&
                                start.year == end.year)
                            ? '${_dateFormat2.format(start)} - ${_dateFormat2.format(end)} ${_dateFormat1.format(start)}'
                            : '${_dateFormat1.format(start)} - ${_dateFormat1.format(end)}',
                        style: AppTypography.medium16.copyWith(
                          color: AppColors.neutral800,
                          height: 1.5,
                        ),
                      ),
                      Gap(4),
                      Text(
                        '${permission.comment}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.regular14.copyWith(
                          color: AppColors.neutral500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8),
                SvgPicture.asset(Assets.arrowRightIos),
              ],
            ),
            Divider(height: 24, thickness: 1, color: AppColors.neutral100),
            Row(
              children: [
                SvgPicture.asset(Assets.calendar),
                Gap(4),
                Text(
                  DateFormat('dd.MM.yyyy').format(
                    DateTime.parse(
                      permission.updatedAt ?? permission.createdAt ?? '',
                    ),
                  ),

                  style: AppTypography.regular14.copyWith(
                    color: AppColors.neutral500,
                    height: 1.5,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: status.backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Text(
                    status.tr,
                    style: AppTypography.regular14.copyWith(
                      color: status.titleColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension PermissionStatusExtention on String {
  PermissionStatus get toPermissionStatus => switch (this) {
    'PENDING' || 'REVIEW' => PermissionStatus.PENDING,
    'REJECTED' || 'AI_REJECTED' => PermissionStatus.REJECTED,
    'APPROVED' || 'AI_APPROVED' => PermissionStatus.APPROVED,
    'CREATED' => PermissionStatus.CREATED,

    _ => PermissionStatus.PENDING,
  };
}
