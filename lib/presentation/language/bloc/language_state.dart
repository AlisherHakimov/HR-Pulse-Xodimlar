part of 'language_cubit.dart';

class LanguageState {
  LanguageState({ required this.selectedLanguage});

  final String selectedLanguage;

  LanguageState copyWith({String? selectedLanguage}) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
