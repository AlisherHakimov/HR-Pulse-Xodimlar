import 'package:flutter/material.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/data/model/permission_model.dart';
import 'package:hr_plus/presentation/profile/bloc/permission/permission_cubit.dart';
import 'package:hr_plus/presentation/profile/pages/permissions_page.dart';
import 'package:hr_plus/presentation/profile/widgets/permission_card.dart';
import 'package:hr_plus/presentation/profile/widgets/update_permission_sheet.dart'
    show UpdatePermissionSheet;

class PermissionDetailSheet extends StatelessWidget {
  const PermissionDetailSheet({super.key, required this.permission});

  final PermissionModel permission;

  static void show(
    BuildContext context, {
    required PermissionModel permission,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    useSafeArea: true,
    builder: (context) => PermissionDetailSheet(permission: permission),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'more_details'.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.semibold18.copyWith(
                  color: AppColors.neutral800,
                ),
              ),
            ),
            12.g,
            if ((permission.status ?? '').toPermissionStatus !=
                PermissionStatus.PENDING)
              _permissionSheetItem('reason', permission.reason?.name ?? ""),
            _permissionSheetItem(
              'date',

              _formatDateRange(permission.start, permission.end),
            ),
            _permissionSheetItem('status'.tr(), null),
            _permissionSheetItem(
              'pay_salary'.tr(),
              permission.paySalary == true
                  ? "you_will_get_salary".tr()
                  : "you_will_not_get_salary".tr(),
            ),

            // _permissionSheetItem('quantity', '80,000 so’m'),
            _permissionSheetItem(
              'comment',
              permission.comment ?? '',
              latest: true,
            ),
            28.g,
            if ((permission.status ?? '').toPermissionStatus ==
                PermissionStatus.PENDING) ...[
              BlocBuilder<PermissionCubit, PermissionState>(
                builder: (context, state) {
                  return AppButton(
                    title: 'cancel'.tr(),
                    background: AppColors.destructive500,

                    onTap: () {
                      showDeletionDialog(
                        context,
                        title: 'delete_request'.tr(),
                        subtitle: 'do_you_want_delete_request'.tr(),
                        confirmTitle: 'confirm'.tr(),

                        onConfirm: () {
                          context.read<PermissionCubit>().deletePermission(
                            permission.id!,
                            onSuccess: () =>
                                context.popUntilWithName(PermissionsPage()),
                            onError: (err) => showError(context, err),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              10.g,
              AppButton(
                title: 'edit'.tr(),

                titleColor: AppColors.neutral700,
                background: AppColors.white,

                side: BorderSide(color: AppColors.neutral300, width: 1),
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.edit, color: AppColors.neutral500),
                ),
                onTap: () {
                  context.read<PermissionCubit>().getReasons();
                  context.pop();

                  UpdatePermissionSheet.show(context, permission);
                },
              ),
            ] else
              AppButton(
                title: 'close'.tr(),
                onTap: () => Navigator.pop(context),
              ),
            16.g,
          ],
        ),
      ),
    );
  }

  Column _permissionSheetItem(
    String title,
    String? value, {
    bool? latest,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.tr(),
        style: AppTypography.regular14.copyWith(color: AppColors.neutral500),
      ),
      8.g,
      if (value == null)
        Container(
          decoration: BoxDecoration(
            color: (permission.status ?? '').toPermissionStatus.backgroundColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Text(
            (permission.status ?? '').toPermissionStatus.tr,
            style: AppTypography.regular14.copyWith(
              color: (permission.status ?? '').toPermissionStatus.titleColor,
              height: 1.5,
            ),
          ),
        )
      else
        Text(
          value.tr(),

          style: AppTypography.medium16.copyWith(color: AppColors.neutral800),
        ),

      if (latest != true)
        Divider(height: 24, thickness: 1, color: AppColors.neutral100),
    ],
  );
}

String _formatDateRange(String? startStr, String? endStr) {
  if (startStr == null || endStr == null) return '';

  final DateTime start = DateTime.parse(startStr);
  final DateTime end = DateTime.parse(endStr);

  final DateFormat timeFormat = DateFormat('HH:mm');
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  final DateFormat fullDateTimeFormat = DateFormat('dd.MM.yyyy');

  // Agar yil, oy, kun bir xil bo'lsa
  if (start.year == end.year &&
      start.month == end.month &&
      start.day == end.day) {
    return '${dateFormat.format(start)}  ${timeFormat.format(start)} - ${timeFormat.format(end)}';
  } else {
    return '${fullDateTimeFormat.format(start)} - ${fullDateTimeFormat.format(end)}';
  }
}

void showDeletionDialog(
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
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.destructive50,
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.destructive100,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(icon, height: 24),
              ),
            ),
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
            BlocBuilder<PermissionCubit, PermissionState>(
              builder: (context, state) {
                return Expanded(
                  flex: 2,
                  child: AppButton(
                    onTap: () {
                      onConfirm?.call();
                    },
                    borderRadius: 8,

                    height: 48,
                    background: AppColors.destructive500,
                    title: confirmTitle.tr(),
                    isLoading: state.createStatus.isLoading,
                    titleTextStyle: AppTypography.medium16.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
