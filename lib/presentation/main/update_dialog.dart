import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hr_plus/core/core.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

bool shouldUpdate = false;
bool force = false;

Future<void> getAppUpdateResponse() async {
  final url = Uri.parse('https://api.tictac.sector-soft.ru/api/version/1.0.2');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      shouldUpdate = data["should_update"];
      force = data["force"];

      print("===========> shouldUpdate $shouldUpdate");
      print("===========> force $force");

      print('Response data: $data');
    } else {
      print('Xato: ${response.statusCode}');
    }
  } catch (e) {
    print('Xatolik: $e');
  }
}

void showUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,

    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.rocket3, height: 128, width: 77),

          const SizedBox(height: 16),
          Text(
            'app_updated'.tr(),
            style: AppTypography.semibold18.copyWith(
              color: AppColors.neutral800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'app_updated_desc'.tr(),
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
            if (force) ...[
              Expanded(
                flex: 2,
                child: AppButton(
                  onTap: () => Navigator.of(context).pop(),
                  background: AppColors.neutral100,
                  title: 'later'.tr(),
                  borderRadius: 6,
                  height: 48,
                  titleTextStyle: AppTypography.medium18.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
              ),
              12.g,
            ],
            Expanded(
              flex: 2,
              child: AppButton(
                onTap: () async {
                  final iosLink = Uri.parse(
                    'https://apps.apple.com/uz/app/onur-group/id6755289545',
                  );
                  final androidLink = Uri.parse(
                    'https://play.google.com/store/apps/details?id=uz.sectorsoft.hrpulse',
                  );

                  final targetLink = Platform.isIOS ? iosLink : androidLink;

                  if (await canLaunchUrl(targetLink)) {
                    await launchUrl(
                      targetLink,
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    debugPrint('Linkni ochib bo‘lmadi: $targetLink');
                  }
                },
                borderRadius: 6,

                height: 48,
                background: AppColors.primary,
                title: 'update'.tr(),
                // isLoading: isLoading,
                titleTextStyle: AppTypography.medium18.copyWith(
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
