import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4689366044834117/51812782181';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4689366044834117/6526698217';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
