import 'package:flutter/material.dart';

import '../core.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.icon, required this.title, this.subtitle});

  final String? icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SizedBox(
          height: context.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Image.asset(icon!, height: 96, width: 96),
              16.g,
              Text(
                title.tr(),
                style: AppTypography.semibold20.copyWith(
                  color: AppColors.neutral800,
                ),
              ),
              8.g,
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    subtitle!.tr(),
                    textAlign: TextAlign.center,
                    style: AppTypography.regular14.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
