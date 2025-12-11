import 'package:flutter/material.dart';

import '../core.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool isAllText;
  final Color? titleColor;
  final Color? iconColor;
  final Function()? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
    this.padding,
    this.titleColor,
    this.iconColor,
    this.isAllText = false,
  });

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSeeAllTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.medium18.copyWith(
                color: titleColor ?? AppColors.woodSmoke950,
                height: 1.4,
              ),
            ),
            if (onSeeAllTap != null)
              Row(
                children: [
                  isAllText
                      ? Text(
                          'see_all'.tr(),
                          style: AppTypography.regular14.copyWith(
                            color: iconColor,
                          ),
                        )
                      : SizedBox(),

                  8.g,
                  SvgPicture.asset(Assets.arrowRight, color: iconColor),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
