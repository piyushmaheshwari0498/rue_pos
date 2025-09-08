import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_posx/core/tablet/app_update/update_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../main.dart';

class VersionGate extends StatefulWidget {
  @override
  _VersionGateState createState() => _VersionGateState();
}

class _VersionGateState extends State<VersionGate> {
  bool _checking = true;
  bool _needsUpdate = false;
  String _apkUrl = "";
  String _latestVersion = "";

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));

    await remoteConfig.fetchAndActivate();

    String latest = remoteConfig.getString('flutter_pos_latest_version');
    String apkUrl = remoteConfig.getString('flutter_pos_apk_url');

    PackageInfo info = await PackageInfo.fromPlatform();
    String current = info.version;

    setState(() {
      _latestVersion = latest;
      _apkUrl = apkUrl;
      _needsUpdate = _isVersionLower(current, latest);
      _checking = false;
    });
  }

  bool _isVersionLower(String current, String latest) {
    List<int> curr = current.split('.').map(int.parse).toList();
    List<int> lat = latest.split('.').map(int.parse).toList();
    for (int i = 0; i < lat.length; i++) {
      if (curr[i] < lat[i]) return true;
      if (curr[i] > lat[i]) return false;
    }
    return false;
  }

  /*@override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_needsUpdate) {
      return UpdateScreen(apkUrl: _apkUrl, latestVersion: _latestVersion,);
    }

    return TabletApp(); // normal app
  }*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _checking
          ? const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
          : _needsUpdate
          ? UpdateScreen(
        apkUrl: _apkUrl,
        latestVersion: _latestVersion,
      )
          : TabletApp(),
    );
  }
}
