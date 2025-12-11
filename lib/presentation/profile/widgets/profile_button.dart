import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hr_plus/core/core.dart';
import 'package:hr_plus/core/extentions/padding_extention.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title,
    this.color,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onTap: onTap,
      color: color ?? AppColors.primary50,
      borderRadius: 10,
      padding: const EdgeInsets.all(16),

      child: Row(
        children: [
          SvgPicture.asset(icon),
          Gap(12),
          Text(
            title.tr(),
            style: AppTypography.medium16.copyWith(
              color: AppColors.neutral800,
              height: 1.5,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ).paddingOnly(bottom: 12);
  }
}
