import 'package:flutter/material.dart';
import '../core.dart';

void showSuccessDialog(
  BuildContext context, {
  String? title,
  String? message,
  VoidCallback? onTap,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.malachite50,
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 32,
                width: 32,
                padding: const EdgeInsets.all(2.7),
                decoration: BoxDecoration(
                  color: AppColors.malachite500,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: AppColors.white, size: 24),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? 'success'.tr(),
              style: AppTypography.medium18.copyWith(
                color: AppColors.woodSmoke950,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? '',
              style: AppTypography.regular14.copyWith(
                color: AppColors.woodSmoke400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}

void showConfirmationDialog(
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
              child: AppButton(
                onTap: () {
                  onConfirm?.call();
                },
                borderRadius: 8,

                height: 48,
                background: AppColors.destructive500,
                title: confirmTitle.tr(),

                titleTextStyle: AppTypography.medium16.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
