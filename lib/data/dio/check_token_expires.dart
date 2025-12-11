import 'dart:developer';

import 'package:hr_plus/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

bool get isTokenExpired {
  bool expired = false;

  if (localeStorage.accessToken.isEmpty) {
    expired = true;
  } else {
    expired = JwtDecoder.isExpired(localeStorage.accessToken);

    log('accessTokenHasExpired: $expired');
  }

  return expired;
}
