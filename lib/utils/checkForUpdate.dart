import 'dart:math';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'downloadAndInstallApk.dart';

Future<void> checkForUpdate() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: Duration.zero, // always fresh
  ));

  await remoteConfig.setDefaults({
    'flutter_pos_latest_version': '1.0.0',
    'flutter_pos_apk_url': '',
  });

  try {
    await remoteConfig.fetch();
    bool activated = await remoteConfig.activate();
    print("RemoteConfig activated: $activated");

    String latestVersion = remoteConfig.getString('flutter_pos_latest_version');
    String apkUrl = remoteConfig.getString('flutter_pos_apk_url');

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    print('App url: $apkUrl');
    print('App current: $currentVersion');
    print('App latest: $latestVersion');

    // if (_isVersionLower(currentVersion, latestVersion)) {
    //   downloadAndInstallApk(apkUrl,latestVersion);
    //
    // }
  } catch (e) {
    print("RemoteConfig error: $e");
  }
}


bool _isVersionLower(String current, String latest) {
  List<int> currentParts = current.split('.').map(int.parse).toList();
  List<int> latestParts = latest.split('.').map(int.parse).toList();

  for (int i = 0; i < latestParts.length; i++) {
    if (i >= currentParts.length || currentParts[i] < latestParts[i]) {
      return true;
    } else if (currentParts[i] > latestParts[i]) {
      return false;
    }
  }
  return false;
}
