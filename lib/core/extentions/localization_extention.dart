import 'package:hr_plus/main.dart';

extension TranslationExtension on Object {
  String get trApi {
    final String lang = localeStorage.language;

    final dynamic obj = this;

    if (lang == 'uz') {
      return obj.nameUz;
    }
    if (lang == 'ru') {
      return obj.nameRu;
    }
    return obj.nameUz;
  }
}
