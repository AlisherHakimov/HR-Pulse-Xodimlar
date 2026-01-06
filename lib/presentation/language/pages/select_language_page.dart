import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr_plus/main.dart';
import 'package:hr_plus/presentation/auth/pages/login_page.dart';
import 'package:hr_plus/presentation/language/bloc/language_cubit.dart';

import '../../../core/core.dart';
import 'change_language_page.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: AppUtils.kPaddingHor16Ver12,
            child: SizedBox.expand(
              child: ValueListenableBuilder(
                valueListenable: localeStorage.box.listenable(),
                builder: (context, object, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(Assets.langSelection, height: 72),
                    24.g,
                    Text(
                      'select_language'.tr(),
                      style: AppTypography.semibold24.copyWith(
                        color: AppColors.neutral800,
                      ),
                    ),
                    Spacer(),
                    LanguageSelectionBtn(lang: 'uz'),
                    12.g,
                    LanguageSelectionBtn(lang: 'cyrl'),
                    12.g,
                    LanguageSelectionBtn(lang: 'ru'),

                    36.g,
                    AppButton(
                      title: 'continue'.tr(),
                      onTap: () => context.push(LoginPage()),
                    ),
                    16.g,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
