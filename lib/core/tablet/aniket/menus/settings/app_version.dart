import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';

class AppVersionLandscape extends StatefulWidget {
  String version;

  AppVersionLandscape({Key? key, required this.version}) : super(key: key);

  @override
  State<AppVersionLandscape> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersionLandscape> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool isOn = false;

    /*return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0))),
              child: ListTile(
                visualDensity: VisualDensity(vertical: 4),
                leading: Text(
                  'Version',
                  style: getTextStyle(
                      fontSize: LARGE_MINUS20_FONT_SIZE,
                      fontWeight: FontWeight.bold),
                ),
                title: Text(''),
                trailing: SizedBox(
                  height: 30,
                  width: 100,
                  child: Text(
                    widget.version,
                    style: getTextStyle(
                        fontSize: LARGE_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )), //Sales Overview area

          Container(
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1.0),
            )),
            child: ListTile(
              visualDensity: VisualDensity(vertical: 4),
              leading: Text(
                'Base url',
                style: getTextStyle(
                    fontSize: LARGE_MINUS20_FONT_SIZE,
                    fontWeight: FontWeight.bold),
              ),
              title: Text(''),
              trailing: Text('https://ruecateringdemo.asatechbh.com',
                  style: getTextStyle(
                      fontSize: LARGE_MINUS_FONT_SIZE,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );*/

    bool isTablet = Device.get().isTablet;

    return Column(
      children: [
        Container(
          color: Colors.white,
          // padding:
          // EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20, vertical: 10),
          child: SingleChildScrollView(
            // ✅ Prevents layout errors
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ Avoid unbounded height issues
              children: [
                _buildInfoRow('Version', widget.version, isTablet),
                _buildInfoRow('Base URL',
                    'https://ruecateringdemo.asatechbh.com', isTablet),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 25 : 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: getTextStyle(
                fontSize: isTablet ? 20.0 : 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Value
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: getTextStyle(
                fontSize: isTablet ? 18.0 : 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
