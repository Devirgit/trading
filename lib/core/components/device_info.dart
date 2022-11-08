import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfo {
  static Future<String> name() async {
    String deviceIdentifier = 'unknown';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.device ?? 'android-none';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.model ?? 'ios-none';
    } else if (kIsWeb) {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      String vendor = webInfo.vendor ?? 'none';
      String userAgent = webInfo.userAgent ?? 'none';
      deviceIdentifier =
          webInfo.hardwareConcurrency.toString() + userAgent + vendor;
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      deviceIdentifier = linuxInfo.machineId ?? 'linux-none';
    }
    return deviceIdentifier;
  }
}
