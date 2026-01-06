import 'package:flutter/material.dart';
import 'package:hr_plus/presentation/language/bloc/language_cubit.dart';
import '../../../core/core.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'change_language', isBackBtn: true),
      body: SafeArea(
        child: Padding(
          padding: AppUtils.kPaddingHor16Ver12,
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LanguageSelectionBtn(lang: 'uz'),
                12.g,
                LanguageSelectionBtn(lang: 'cyrl'),
                12.g,
                LanguageSelectionBtn(lang: 'ru'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageSelectionBtn extends StatelessWidget {
  const LanguageSelectionBtn({super.key, required this.lang, this.color});

  final String lang;
  final Color? color;

  // MIUI uchun to'g'ri Locale qaytarish
  Locale _getLocale(String lang) {
    switch (lang) {
      case 'uz':
        return Locale('uz', 'UZ');
      case 'cyrl':
        return Locale('uz', 'Cyrl'); // Kirill uchun
      case 'ru':
        return Locale('ru', 'RU');
      default:
        return Locale('uz', 'UZ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final isSelected = state.selectedLanguage == lang;
        return GestureDetector(
          onTap: () async {
            try {
              // To'g'ri Locale olish
              final locale = _getLocale(lang);

              // Locale o'zgartirish
              await context.setLocale(locale);

              // Cubit yangilash
              context.read<LanguageCubit>().changeLanguage(lang);

              // MIUI uchun qo'shimcha kechikish
              await Future.delayed(Duration(milliseconds: 100));
            } catch (e) {
              print('Locale change error: $e');
              // Xatolik bo'lsa fallback
              if (lang == 'cyrl') {
                await context.setLocale(Locale('uz', 'UZ'));
                context.read<LanguageCubit>().changeLanguage('uz');
              }
            }
          },
          child: Container(
            padding: AppUtils.kPaddingAll12,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppUtils.kBorderRadius8,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.neutral100,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(lang != 'ru' ? Assets.flagUz : Assets.flagRu),
                8.g,
                Text(
                  lang == 'uz'
                      ? 'O\'zbekcha (lotin)'
                      : lang == 'ru'
                      ? 'Русский'
                      : "Ўзбекча (kirilcha)",
                  style: AppTypography.medium16.copyWith(
                    color: AppColors.neutral800,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Radio(
                    value: lang,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: state.selectedLanguage,
                    activeColor: AppColors.primary,
                    onChanged: (value) async {
                      if (value != null) {
                        try {
                          final locale = _getLocale(value);
                          await context.setLocale(locale);
                          context.read<LanguageCubit>().changeLanguage(value);
                        } catch (e) {
                          print('Radio locale error: $e');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
