import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/downloadAndInstallApk.dart';

class UpdateScreen extends StatefulWidget {
  final String apkUrl;
  final String latestVersion;

  const UpdateScreen({required this.apkUrl, Key? key, required this.latestVersion}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  int _progress = 0;
  bool _isDownloading = false;

  void _startDownload() {
    setState(() {
      _isDownloading = true;
    });
    downloadAndInstallApk(widget.apkUrl, widget.latestVersion, (progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disable back
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.system_update, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  "New update available!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Versions ${widget.latestVersion}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Please update to continue using the app.",
                    textAlign: TextAlign.center),
                const SizedBox(height: 30),

                // Show button or progress
                !_isDownloading
                    ? ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Update Now"),
                  onPressed: _startDownload,
                )
                    : Column(
                  children: [
                    LinearProgressIndicator(
                      value: _progress / 100,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 10),
                    Text("Downloading... $_progress%"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

