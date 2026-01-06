import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_plus/main.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit()
    : super(LanguageState(selectedLanguage: localeStorage.language));

  void changeLanguage(String languageCode) {
    localeStorage.setLanguage(languageCode);
    emit(state.copyWith(selectedLanguage: languageCode));
  }
}
