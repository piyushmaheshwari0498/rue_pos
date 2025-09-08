import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/core/service/api_common/api/api_common_service.dart';
import 'package:nb_posx/utils%20copy/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../service/api_common/model/AllBranchModel.dart';
import '../../../../service/api_common/model/counterModel.dart';

class ThermalSettingsLandscape extends StatefulWidget {
  const ThermalSettingsLandscape({super.key});

  @override
  State<ThermalSettingsLandscape> createState() => _ThermalSettingsState();
}

class _ThermalSettingsState extends State<ThermalSettingsLandscape> {
  List<Branch> branchList = [];
  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";

  // String _selectedTypeId = "";

  AllBranchModel allBranchModel = AllBranchModel();
  CounterModel _counterModel = CounterModel();

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    // _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool isOn = false;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          FutureBuilder<AllBranchModel?>(
              future: CommonApiService().getBranchList(
                  '12',
                  _selectedEmployeeId,
                  '19',
                  '2023-01-29 08:01:39.000',
                  'IN',
                  'NULL',
                  '2023-07-11 08:01:39.000'),
              builder: (context, snapshot) {
                // print('BRANCH::snapshot.data : ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // until data is fetched, show loader
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  AllBranchModel? allBranch = snapshot.data;

                  print(
                      'BRANCH::snapshot.data : ${allBranch!.branch![0].id.toString()}');
                  allBranchModel = snapshot.data!;
                  // print(
                  //     'allBranch!.branch?.length.: ${allBranch!.branch?.length.toString()}');
                  return Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 1.0))),
                      child: ListTile(
                        onTap: () {},
                        visualDensity: const VisualDensity(vertical: 4),
                        leading: Text(
                          'Branch',
                          style: getTextStyle(
                              fontSize: Device.get().isTablet
                                  ? LARGE_MINUS20_FONT_SIZE : MEDIUM_FONT_SIZE,
                              fontWeight: FontWeight.bold),
                        ),
                        title: const Text(''),
                        trailing: TextButton.icon(
                          onPressed: () {
                            // if (_selectedTypeId == "1") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: alertShowBranches(1),
                                    title: Center(
                                        child: Text(
                                      'Branch',
                                      style: getTextStyle(
                                          fontSize: Device.get().isTablet
                                              ? 40.0 : 20.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  );
                                });
                            // }
                          },
                          label: Text(_selectedBranch,
                              style: getTextStyle(
                                  fontSize: Device.get().isTablet ? 20.0 : 15.0, fontWeight: FontWeight.w600)),
                          iconAlignment: IconAlignment.end,
                          icon: const Icon(Icons.arrow_drop_down_rounded,
                              size: 35),
                        ),
                      ));
                } else {
                  return const Center(
                    child: Text("Loading..."),
                  );
                }
              }),
          FutureBuilder<CounterModel?>(
              future: CommonApiService().getCounterList(
                  _selectedBranchId,
                  '12',
                  _selectedEmployeeId,
                  '19',
                  '2023-01-29 08:01:39.000',
                  'IN',
                  'NULL',
                  '2023-07-11 08:01:39.000'),
              builder: (context, snapshot) {
                print('COUNTER::snapshot.data : ${snapshot.data}');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // until data is fetched, show loader
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  CounterModel? counterModel = snapshot.data;
                  _counterModel = snapshot.data!;
                  print(
                      'counterModel!.counter?.length.: ${counterModel!.counter?.length.toString()}');
                  return Container(
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    )),
                    child: ListTile(
                      onTap: () {},
                      visualDensity: const VisualDensity(vertical: 4),
                      leading: Text(
                        'Counter',
                        style: getTextStyle(
                            fontSize: Device.get().isTablet
                                ? LARGE_MINUS20_FONT_SIZE : MEDIUM_FONT_SIZE,
                            fontWeight: FontWeight.bold),
                      ),
                      title: const Text(''),
                      trailing: TextButton.icon(
                        onPressed: () {
                          // if (_selectedTypeId == "1") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: alertShowBranches(2),
                                  title: Center(
                                      child: Text(
                                    'Select Counter',
                                    style: getTextStyle(
                                        fontSize: Device.get().isTablet ? 40.0 : 20.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                                );
                              });
                          // }
                        },
                        label: Text(_selectedCounter,
                            style: getTextStyle(
                                fontSize: Device.get().isTablet ? 20.0 : 15.0, fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.end,
                        icon:
                            const Icon(Icons.arrow_drop_down_rounded, size: 35),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("Loading..."),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<void> selectedBranch(Branch selctedBranch) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(BranchName, selctedBranch.name.toString());
    prefs.setString(BranchId, selctedBranch.id.toString());
    prefs.setString(BranchAdd1, selctedBranch.address1.toString());
    prefs.setString(BranchAdd2, selctedBranch.address2.toString());
    prefs.setString(BranchAdd3, selctedBranch.address3.toString());
    prefs.setString(BranchPhone, selctedBranch.phoneNo.toString());
    prefs.setString(BranchVAT, selctedBranch.vATNo.toString());
    prefs.setString(BranchCRNo, selctedBranch.cRNo.toString());
  }

  Future<void> selectedCounter(
      String selectedCounter, selectedCounterId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(CounterName, selectedCounter);
    prefs.setString(CounterId, selectedCounterId);
  }

  Widget alertShowBranches(int selectionType) {
    // print('allBranchModel DATA : ${_counterModel.counter?.length}');
    if (selectionType == 1) {
      final List<Branch>? _arrBranch = allBranchModel.branch;
      return Container(
        width: 500,
        height: 500,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _arrBranch?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  '${_arrBranch?[index].name}',
                  style:
                      getTextStyle(fontWeight: FontWeight.w500, fontSize: Device.get().isTablet ? 25.0 : 18.0),
                ),
                onTap: () {
                  selectedBranch(_arrBranch![index]);
                  _getDetails();
                  Navigator.of(context).pop();
                },
              );
            }),
      );
    } else {
      final List<Counter>? _arrCounter = _counterModel.counter;
      return Container(
        width: 500,
        height: 500,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _arrCounter?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  '${_arrCounter?[index].counterNo}-${_arrCounter?[index].description}',
                  style:
                      getTextStyle(fontWeight: FontWeight.w500, fontSize: Device.get().isTablet ? 25.0 : 18.0),
                ),
                onTap: () {
                  selectedCounter('${_arrCounter?[index].counterNo}',
                      '${_arrCounter?[index].id}');
                  _getDetails();
                  Navigator.of(context).pop();
                },
              );
            }),
      );
    }
  }
}
