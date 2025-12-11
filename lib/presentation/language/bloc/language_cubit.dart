import 'package:flutter/material.dart';
import 'package:hr_plus/main.dart';

import '../../../core/core.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
    : super(LanguageState(selectedLanguage: localeStorage.language));

  void changeLanguage(String languageCode) {
    localeStorage.setLanguage(languageCode);
    emit(state.copyWith(selectedLanguage: languageCode));
  }
}

// class LocaleChangeNotifier extends ValueNotifier<Locale> {
//   LocaleChangeNotifier(super.value);
//
//   void change(Locale locale) {
//     value = locale;
//     notifyListeners();
//   }
// }
