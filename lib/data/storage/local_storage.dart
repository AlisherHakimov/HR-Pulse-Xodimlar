import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';

class LocalStorage {
  late Box box;

  Future<void> init() async {
    await Hive.initFlutter();
    /*    var encriptionKey = Hive.generateSecureKey();*/
    box = await Hive.openBox(
      AppKeys.hiveBox,
      // encryptionCipher: HiveAesCipher(encriptionKey),
    );
  }

  //User
  Future<void> saveUser({
    int? id,
    required String name,
    required String lastName,
    required String phone,
    required String email,
    required String avatar,
    required String role,
    String? token,
  }) async {
    box.put(AppKeys.userId, id);
    box.put(AppKeys.userName, name);
    box.put(AppKeys.userPhone, phone);
    box.put(AppKeys.userLastName, lastName);
    box.put(AppKeys.userEmail, email);
    box.put(AppKeys.userAvatar, avatar);
    if (token != null) {
      box.put(AppKeys.accessToken, token);
    }
    box.put(AppKeys.role, role);
  }

  void clearUser() {
    box.delete(AppKeys.userId);
    box.delete(AppKeys.userName);
    box.delete(AppKeys.userLastName);
    box.delete(AppKeys.userPhone);
    box.delete(AppKeys.userEmail);
    box.delete(AppKeys.userAvatar);
    box.delete(AppKeys.userType);
    box.delete(AppKeys.accessToken);
  }

  void deleteAvatar() {
    box.delete(AppKeys.userAvatar);
  }

  Future<void> setFirstLaunch() async {
    box.put(AppKeys.firstLaunch, false);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    box.put(AppKeys.accessToken, accessToken);
    box.put(AppKeys.refreshToken, refreshToken);
  }

  Future<void> setLanguage(String lang) async {
    box.put(AppKeys.lang, lang);
  }

  Future<void> setNotificationEnable(bool value) async {
    box.put(AppKeys.notificationEnable, value);
  }

  Future<void> clearTokens() async {
    box.delete(AppKeys.accessToken);
    box.delete(AppKeys.refreshToken);
  }

  Future<void> clear() async {
    box.clear();
  }

  Future<void> setLoggedIn(bool value) async {
    box.put(AppKeys.isLoggedIn, value);
  }

  bool get notificationEnable => box.get(AppKeys.notificationEnable) ?? true;

  bool get isFirstLaunch => box.get(AppKeys.firstLaunch) ?? true;

  String get language => box.get(AppKeys.lang) ?? 'uz';

  String get accessToken => box.get(AppKeys.accessToken) ?? '';

  String get role => box.get(AppKeys.role) ?? '';

  String get refreshToken => box.get(AppKeys.refreshToken) ?? '';

  String get avatar => box.get(AppKeys.userAvatar) ?? '';

  String get name => box.get(AppKeys.userName) ?? '';

  String get lastName => box.get(AppKeys.userLastName) ?? '';

  String get phone => box.get(AppKeys.userPhone) ?? '';

  bool get isLoggedIn => box.get(AppKeys.isLoggedIn) ?? false;

  //PIN Code
  Future<void> setPin(String pin) async {
    box.put(AppKeys.pin, pin);
  }

  String get pin => box.get(AppKeys.pin);

  Future<void> putBaseUrl(String baseUrl) async {
    box.put('baseUrl', baseUrl);
  }

  String get baseUrl => box.get('baseUrl') ?? 'api.tema2.sector-soft.ru/api/v1';
}
