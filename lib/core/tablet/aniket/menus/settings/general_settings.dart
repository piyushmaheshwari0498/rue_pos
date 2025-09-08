import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';

class GeneralSettingsLandscape extends StatefulWidget {
  const GeneralSettingsLandscape({super.key});

  @override
  State<GeneralSettingsLandscape> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettingsLandscape> {
  bool isSalesOn = false;
  bool isPaymentOn = false;
  bool isTax = false;
  bool isSubCatOn = false;
  int receipt_count = 0;
  int kot_count = 0;
  // String _selectedTypeId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDetails();
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      receipt_count = prefs.getInt(receipt_print) ?? 0;
      kot_count = prefs.getInt(kot_print) ?? 0;
      isSalesOn = prefs.getBool(isSalesOverview) ?? false;
      isPaymentOn = prefs.getBool(isPayment) ?? false;
      isTax = prefs.getBool(isTaxOn) ?? false;
      isSubCatOn = prefs.getBool(isSubCategory) ?? true;
    });
  }

  Future<void> setSales(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSalesOverview, val);
    setState(() {});
  }

  Future<void> setPayment(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isPayment, val);
    setState(() {});
  }

  Future<void> setTax(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isTaxOn, val);
    setState(() {});
  }

  Future<void> setSubCat(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSubCategory, val);
    setState(() {});
  }

  Future<void> setReceiptCount(int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(receipt_print, val);
    setState(() {});
  }

  Future<void> setKOTCount(int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(kot_print, val);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

   /* return Container(
      color: Colors.white,
      child: Column(
        children: [
          Visibility(
              visible: true,
              child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: ListTile(
                    visualDensity: const VisualDensity(vertical: 4),
                    leading: Text(
                      'Sales Overview area',
                      style: getTextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    title: const Text(''),
                    trailing: SizedBox(
                        height: 50,
                        width: 100,
                        child: Switch(
                          // This bool value toggles the switch.
                          value: isSalesOn,
                          activeColor: Colors.red,
                          onChanged: (bool value) {
                            // if (_selectedTypeId == "1") {
                              // This is called when the user toggles the switch.
                              setState(() {
                                isSalesOn = value;
                                setSales(isSalesOn);
                                _getDetails();
                              });
                            // }
                          },

                          inactiveTrackColor: Colors.grey.shade300,
                          inactiveThumbColor: Colors.grey.shade500,
                        )),
                  ))), //Sales Overview area
          Container(
              decoration: BoxDecoration(border: Border.all()),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Text(
                  'Payment',
                  style:
                      getTextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                title: const Text(''),
                trailing: SizedBox(
                    height: 50,
                    width: 100,
                    child: Switch(
                      // This bool value toggles the switch.
                      value: isPaymentOn,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        // if (_selectedTypeId == "1") {
                          // This is called when the user toggles the switch.
                          setState(() {
                            isPaymentOn = value;
                            setPayment(isPaymentOn);
                            _getDetails();
                          });
                        // }
                      },

                      inactiveTrackColor: Colors.grey.shade300,
                      inactiveThumbColor: Colors.grey.shade500,
                    )),
              )),
          Container(
              decoration: BoxDecoration(border: Border.all()),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Text(
                  'Tax',
                  style:
                      getTextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                title: isTax
                    ? Text(
                        'Exclusive',
                        style: getTextStyle(),
                      )
                    : Text(
                        'Inclusive',
                        style: getTextStyle(),
                      ),
                trailing: SizedBox(
                    height: 50,
                    width: 100,
                    child: Switch(
                      // This bool value toggles the switch.
                      value: isTax,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        // if (_selectedTypeId == "1") {
                          // This is called when the user toggles the switch.
                          setState(() {
                            isTax = value;
                            setTax(isTax);
                            _getDetails();
                          });
                        // }
                      },

                      inactiveTrackColor: Colors.grey.shade300,
                      inactiveThumbColor: Colors.grey.shade500,
                    )),
              )), //Sales Overview area
          Visibility(
            visible: true,
            child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: ListTile(
                  visualDensity: const VisualDensity(vertical: 4),
                  leading: Text(
                    'Sub Category',
                    style: getTextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  title: const Text(''),
                  trailing: SizedBox(
                      height: 50,
                      width: 100,
                      child: Switch(
                        // This bool value toggles the switch.
                        value: isSubCatOn,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // if (_selectedTypeId == "1") {
                            // This is called when the user toggles the switch.
                            setState(() {
                              isSubCatOn = value;
                              setSubCat(isSubCatOn);
                              _getDetails();
                            });
                          // }
                        },

                        inactiveTrackColor: Colors.grey.shade300,
                        inactiveThumbColor: Colors.grey.shade500,
                      )),
                )),
          ), //Sales Overview area

          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Text(
                  'Receipt Print',
                  style:
                      getTextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                title: const Text(''),
                trailing: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MAIN_COLOR,
                        ),
                        borderRadius:
                            BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              // if (_selectedTypeId == "1") {
                                if (receipt_count > 1) {
                                  receipt_count = receipt_count - 1;
                                  setReceiptCount(receipt_count);
                                  _getDetails();
                                // } else {
                                //   receipt_count = 0;
                                //   setReceiptCount(receipt_count);
                                //   _getDetails();
                                // }
                                setState(() {});
                              }
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 35,
                            )),
                        greySizedBox,
                        Container(
                            // color: MAIN_COLOR.withOpacity(0.1),
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              "${receipt_count}",
                              // item.orderedQuantity
                              //     .toInt()
                              //     .toString(),
                              style: getTextStyle(
                                fontSize: LARGE_MINUS_FONT_SIZE,
                                fontWeight: FontWeight.w600,
                                color: MAIN_COLOR,
                              ),
                            )),
                        greySizedBox,
                        ///////////////
                        InkWell(
                            onTap: () {
                              // if (_selectedTypeId == "1") {
                                receipt_count = receipt_count + 1;

                                setReceiptCount(receipt_count);
                                _getDetails();
                                setState(() {});
                              // }
                            },
                            child: const Icon(
                              Icons.add,
                              size: 35,
                            )),
                      ],
                    ))),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                leading: Text(
                  'KOT print',
                  style:
                      getTextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: MAIN_COLOR,
                        ),
                        borderRadius:
                            BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () {
                              if (kot_count > 1) {
                                kot_count = kot_count - 1;

                                setKOTCount(kot_count);
                                _getDetails();
                              } else {
                                kot_count = 0;
                                setKOTCount(kot_count);
                                _getDetails();
                              }
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.remove,
                              size: 35,
                            )),
                        greySizedBox,
                        Container(
                            // color: MAIN_COLOR.withOpacity(0.1),
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              "${kot_count}",
                              // item.orderedQuantity
                              //     .toInt()
                              //     .toString(),
                              style: getTextStyle(
                                fontSize: LARGE_MINUS_FONT_SIZE,
                                fontWeight: FontWeight.w600,
                                color: MAIN_COLOR,
                              ),
                            )),
                        greySizedBox,
                        ///////////////
                        InkWell(
                            onTap: () {
                              kot_count = kot_count + 1;

                              setKOTCount(kot_count);
                              _getDetails();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add,
                              size: 35,
                            )),
                      ],
                    ))),
          )
        ],
      ),
    );*/
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Device.get().isTablet ? 16.0 : 8.0),
      child: Device.get().isTablet
          ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildSettingsColumn()),
          const SizedBox(width: 20),
          Expanded(child: _buildPrintingColumn()),
        ],
      )
          : Column(
        children: [
          _buildSettingsColumn(),
          const SizedBox(height: 10),
          _buildPrintingColumn(),
        ],
      ),
    );
  }

  Widget _buildSettingsColumn() {
    return Column(
      children: [
        _buildSwitchTile('Sales Overview', isSalesOn, (value) {
          setState(() {
            isSalesOn = value;
            setSales(isSalesOn);
            _getDetails();
          });
        }),
        _buildSwitchTile('Payment', isPaymentOn, (value) {
          setState(() {
            isPaymentOn = value;
            setPayment(isPaymentOn);
            _getDetails();
          });
        }),
        Visibility(
          visible: false,
          child:
        _buildSwitchTile('Tax', isTax, (value) {
          setState(() {
            isTax = value;
            setTax(isTax);
            _getDetails();
          });
        }, isTax ? 'Exclusive' : 'Inclusive'),),
        _buildSwitchTile('Sub Category', isSubCatOn, (value) {
          setState(() {
            isSubCatOn = value;
            setSubCat(isSubCatOn);
            _getDetails();
          });
        }),
      ],
    );
  }

  Widget _buildPrintingColumn() {
    return Column(
      children: [
        _buildCounterTile('Receipt Print', receipt_count, (newCount) {
          setState(() {
            receipt_count = newCount;
            setReceiptCount(receipt_count);
            _getDetails();
          });
        }),
        hightSpacer20,
        _buildCounterTile('KOT Print', kot_count, (newCount) {
          setState(() {
            kot_count = newCount;
            setKOTCount(kot_count);
            _getDetails();
          });
        }),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged, [String? subtitle]) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 4),
        leading: Text(title, style: getTextStyle(fontSize: Device.get().isTablet
            ? 20.0 : 15.0, fontWeight: FontWeight.bold)),
        title: subtitle != null ? Text(subtitle, style: getTextStyle()) : const SizedBox.shrink(),
        trailing: SizedBox(
          height: 50,
          width: 100,
          child: Switch(
            value: value,
            activeColor: Colors.green,
            onChanged: onChanged,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterTile(String title, int count, Function(int) onCountChanged) {
    return Container(
      // decoration: BoxDecoration(border: Border.all()),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 4),
        leading: Text(title, style: getTextStyle(fontSize: Device.get().isTablet
            ? 20.0 : 15.0, fontWeight: FontWeight.bold)),
        trailing: Container(
          width: Device.get().isTablet
              ? 150 : 120,
          height: 50,
          // decoration: BoxDecoration(
          //   border: Border.all(color: MAIN_COLOR),
          //   borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  if (count > 1) {
                    onCountChanged(count - 1);
                  }
                },
                child: Container(
                  width: Device.get().isTablet
                      ? 50 : 40,
                  height: Device.get().isTablet
                      ? 50 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MAIN_COLOR.withOpacity(0.1),
                  ),
                  child: Icon(Icons.remove,
                      size: Device.get().isTablet
                          ? 35 : 20, color: MAIN_COLOR),
                ),
              ),
              widthSpacer(10),
              Text("$count", style: getTextStyle(fontSize: Device.get().isTablet
                  ? LARGE_MINUS_FONT_SIZE : MEDIUM_FONT_SIZE, fontWeight: FontWeight.w600, color: MAIN_COLOR)),
              widthSpacer(10),
              InkWell(
                onTap: () {
                  onCountChanged(count + 1);
                },
                child: Container(
                  width: Device.get().isTablet
                      ? 50 : 40,
                  height: Device.get().isTablet
                      ? 50 : 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MAIN_COLOR.withOpacity(0.1),
                  ),
                  child: Icon(Icons.add,
                      size: Device.get().isTablet
                          ? 35 : 20, color: MAIN_COLOR),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
