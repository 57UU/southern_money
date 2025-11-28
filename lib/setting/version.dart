import 'package:flutter/foundation.dart' show kIsWeb, kIsWasm;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:southern_money/setting/environment_info/native.dart'
    if (dart.library.js_interop) 'package:southern_money/setting/environment_info/web.dart';

class VersionService {
  PackageInfo packageInfo;
  VersionService(this.packageInfo) {
    _version = packageInfo.version;
  }

  late String _version;

  String get currentVersion {
    return _version;
  }

  String getVersionInfo() {
    var appName = packageInfo.appName;
    var buildNumber = packageInfo.buildNumber;
    var version = packageInfo.version;
    var signature = packageInfo.buildSignature;
    var installerStore = packageInfo.installerStore;
    var packageName = packageInfo.packageName;

    var environmentText = "---Environment---\n${getEnvironmentInfo()}";

    String content =
        "---APP---\n"
        "AppName: $appName\n"
        "BuildNumber: $buildNumber\n"
        "Version: $version\n"
        "Signature: $signature\n"
        "Installer: $installerStore\n"
        "PackageName: $packageName\n"
        "$environmentText"
        "---FLAG---\n"
        "Web: $kIsWeb\n"
        "WASM: $kIsWasm\n";
    return content;
  }
}
