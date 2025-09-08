import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';

/*Future<void> downloadAndInstallApk(
    String url, void Function(int progress) onProgress) async {
  try {
    Dio dio = Dio();
    String savePath = "/storage/emulated/0/Download/app_update.apk";

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          int progress = ((received / total) * 100).toInt();
          onProgress(progress); // 🔥 update UI
        }
      },
    );

    // await InstallPlugin.installApk(savePath, 'com.example.app'); // replace package id
  } catch (e) {
    print("Download failed: $e");
  }
}*/

Future<void> downloadAndInstallApk(
    String url, String version, void Function(int progress) onProgress) async {
  try {
    Dio dio = Dio();

    // 📂 Get Downloads folder path
    Directory? downloadsDir = Directory("/storage/emulated/0/Download");

    // Create RUE_POS folder inside Downloads
    String folderPath = "${downloadsDir.path}/RUE_POS";
    Directory ruePosDir = Directory(folderPath);
    if (!await ruePosDir.exists()) {
      await ruePosDir.create(recursive: true);
    }

    // File path with version number
    String savePath = "$folderPath/app_v$version.apk";

    // Start Download
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          int progress = ((received / total) * 100).toInt();
          onProgress(progress); // 🔥 update UI progress
        }
      },
    );

    // 📂 Open APK file -> System will show Package Installer
    await OpenFilex.open(savePath);
  } catch (e) {
    print("Download failed: $e");
  }
}


