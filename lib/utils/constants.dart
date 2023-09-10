import 'package:flutter/foundation.dart' show kReleaseMode;

class Constants {
  static const String _bannerAdTestId =
      'ca-app-pub-3940256099942544/6300978111';

  static const String _bannerAdId = kReleaseMode
      ? String.fromEnvironment('BANNER_AD_UNIT_ID')
      : _bannerAdTestId;

  static String get bannerAdId {
    const String bannerAdId = String.fromEnvironment('BANNER_AD_UNIT_ID');
    if (bannerAdId.isEmpty && kReleaseMode) {
      throw Exception(
        'BANNER_AD_UNIT_ID environment variable not defined.',
      );
    }
    return _bannerAdId;
  }
}
