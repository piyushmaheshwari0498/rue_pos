// import 'dart:html';

// import 'dart:html';

import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:nb_posx/core/service/api_common/api/api_common_service.dart';
import 'package:nb_posx/core/service/api_stock/model/stock_comman_response.dart';
import 'package:nb_posx/core/service/api_stock/model/stock_model.dart';
import 'package:nb_posx/core/service/category/model/categories.dart' as api;
import 'package:nb_posx/utils%20copy/ui_utils/spacer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../service/api_common/model/locationModel.dart';
import '../../../service/api_stock/api/stock_api_service.dart';
import '../../../service/category/api/catogory_api_service.dart';

class StocksMenuLandscape extends StatefulWidget {
  const StocksMenuLandscape({super.key});

  @override
  State<StatefulWidget> createState() => _StocksState();
}

class _StocksState extends State<StocksMenuLandscape> {
  // final _listNames = ['Bankok', 'Pataya', 'Armenia', 'Bangaluru'];
  List<Location> _listLocation = [];
  late LocationModel locationModel;
  late StockCommanResponse stockModel;
  List<api.Category> _listCategory = [];
  late api.Categories _listCategories;
  List<Product> _listProducts = [];
  List<Product> _filterProducts = [];

  late api.Category categoryModel;
  Location? currentSelectedValue;
  api.Category? currentCatSelectedValue;
  var dropdownValue;
  var indForLocation;
  var indForCategory;
  int? selectedCategoryId = null;

  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedTypeId = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _getDetails());
  }

  /*Future<void> fetchInitialData() async {
    // locationModel = await CommonApiService().getLocationList(_selectedBranchId);
    try {
      final locationModel = await CommonApiService().getLocationList(_selectedBranchId);
      _listLocation = locationModel.location ?? [];
      if (_listLocation.isNotEmpty) {
        setState(() {
          _listLocation = locationModel.location!;
          currentSelectedValue = _listLocation.first;
          // final selected = currentSelectedValue as Location;
          indForLocation = currentSelectedValue?.id;

          // indForLocation = _listLocation.indexWhere((loc) => loc.id == currentSelectedValue?.id);
          print("initaldata: ${currentSelectedValue.toString()}");
          print("initaldata: $indForLocation");
        });

        // print("initaldata: ${currentSelectedValue.toString()}");
        // print("initaldata: $indForLocation");
        await fetchStockData();
      }
    } catch (e) {
      print("Error fetching locations: $e");
      // Optionally show snackbar or alert
    }

    _listCategories = await CategoryService().getCategoryList();

    if (_listCategories.category!.isNotEmpty) {
      _listCategory = _listCategories.category!;
      _listCategory.insert(0, api.Category(
        id: 0,
        english: "All",
        arabic: "",
        sequenceNo: 0,
        coverImage: null,
        categoryMainId: 0,
      ));
      currentCatSelectedValue = _listCategory.first;
    }

    setState(() {});
  }*/

  Future<void> fetchInitialData() async {
    try {
      final locationModel = await CommonApiService().getLocationList(_selectedBranchId);
      final locations = locationModel.location ?? [];

      final categoriesModel = await CategoryService().getCategoryList();

      setState(() {
        _listLocation = locations;
        if (_listLocation.isNotEmpty) {
          currentSelectedValue = _listLocation.first;
          indForLocation = currentSelectedValue?.id;
        }

        _listCategories = categoriesModel;

        if (_listCategories.category!.isNotEmpty) {
          _listCategory = _listCategories.category!;
          _listCategory.insert(
            0,
            api.Category(
              id: 0,
              english: "All",
              arabic: "",
              sequenceNo: 0,
              coverImage: null,
              categoryMainId: 0,
            ),
          );
          currentCatSelectedValue = _listCategory.first;
        }
      });

      if (_listLocation.isNotEmpty) {
        await fetchStockData();
      }

    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  Future<void> fetchStockData() async {
    if (currentSelectedValue != null) {
      stockModel = await StockService.getStock('$indForLocation');
      _listProducts = [];
      _filterProducts = [];
      if(stockModel.data1!.isNotEmpty) {
        _listProducts = stockModel.data1!;
        _filterProducts = _listProducts;
      }

      // if (selectedCategoryId != null && selectedCategoryId != 0) {
      //   _listProducts = _listProducts
      //       .where((p) => p.categoryId == selectedCategoryId)
      //       .toList() ?? [];
      // }else{
      //   _listProducts = _listProducts;
      // }

      setState(() {});
    }
  }

 /* Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    _selectedTypeId = await dbPreferences.getPreference(UserTypeId);

    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });

    fetchInitialData();
  }*/

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;
    DBPreferences dbPreferences = DBPreferences();

    _selectedTypeId = await dbPreferences.getPreference(UserTypeId);

    setState(() {
      _selectedEmployeeId = manager.id;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });

    // ✅ Wait for fetchInitialData to complete
    await fetchInitialData();
  }

  Widget buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? selectedValue,
    required Function(T?) onChanged,
    required String Function(T) getLabel,
  }) {
    return Expanded(
      child: Container(
        height: 60,
        color: MAIN_COLOR,
        child: ListTile(
          leading: Text(label, style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width * 0.01)),
          trailing: DropdownButton<T>(
            dropdownColor: MAIN_COLOR,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            value: selectedValue,
            onChanged: onChanged,
            items: items
                .map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel(item),
                style: TextStyle(color: Colors.white),
              ),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  double getResponsiveRatio(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) return 4 / 2; // Large tablets
    if (width > 600) return 4 / 2; // Small tablets
    return 5 / 2; // Phones
  }

  int getResponsiveAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print("AXIS COUNT WIDTH $width");
    if (width > 900) return 5; // Large tablets
    if (width > 600) return 4; // Small tablets
    return 6; // Phones
  }

  /*@override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,

        title: Text(
          'Stocks',
          style:
              getTextStyle(fontSize: LARGE_PLUS_FONT_SIZE, color: BLACK_COLOR),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: MAIN_COLOR,
                    height: 60,
                    child: ListTile(
                      leading: Text(
                        'Location',
                        style: getTextStyle(
                            color: WHITE_COLOR,
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: FutureBuilder<LocationModel>(
                        future: CommonApiService().getLocationList(_selectedBranchId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            LocationModel? locationModel = snapshot.data;
                            _listLocation = locationModel!.location!;

                            return DropdownButton<Location>(
                              alignment: Alignment.centerRight,
                              dropdownColor: MAIN_COLOR,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              onChanged: (newValue) {
                                setState(() {
                                  currentSelectedValue = newValue!;
                                  indForLocation = _listLocation.indexOf(currentSelectedValue);
                                });
                              },
                              value: _listLocation[indForLocation ?? 0],
                              items: _listLocation.map((Location value) {
                                return DropdownMenuItem<Location>(
                                  alignment: Alignment.centerLeft,
                                  value: value,
                                  child: Text(
                                    value.location!,
                                    style: getTextStyle(
                                        color: WHITE_COLOR,
                                        fontSize: MediaQuery.of(context).size.width * 0.01,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                'Select',
                                style: getTextStyle(
                                    color: WHITE_COLOR,
                                    fontSize: MediaQuery.of(context).size.width * 0.01,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Adds space between the two containers
                Expanded(
                  child: Container(
                    color: MAIN_COLOR,
                    height: 60,
                    child: ListTile(
                      leading: Text(
                        'Category',
                        style: getTextStyle(
                            color: WHITE_COLOR,
                            fontSize: LARGE_MINUS_FONT_SIZE,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: FutureBuilder<api.Categories>(
                        future: CategoryService().getCategoryList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            api.Categories? categoryModel = snapshot.data;
                            _listCategory = categoryModel!.category!;

                            return DropdownButton<api.Category>(
                              dropdownColor: MAIN_COLOR,
                              alignment: Alignment.centerRight,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                              onChanged: (categories) {
                                setState(() {
                                  dropdownValue = categories!;
                                  indForCategory = _listCategory.indexOf(dropdownValue);
                                  selectedCategoryId = _listCategory[indForCategory].id;
                                });
                              },
                              value: _listCategory[indForCategory ?? 0],
                              items: _listCategory.map((api.Category value) {
                                return DropdownMenuItem<api.Category>(
                                  value: value,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value.english!,
                                    style: getTextStyle(
                                        color: WHITE_COLOR,
                                        fontSize: MediaQuery.of(context).size.width * 0.01,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              hint: Text(
                                'Select',
                                style: getTextStyle(
                                    color: WHITE_COLOR,
                                    fontSize: MediaQuery.of(context).size.width * 0.01,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: FutureBuilder<StockCommanResponse>(
                    future: StockService.getStock("$currentSelectedValue"),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // until data is fetched, show loader
                        return Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: const CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasData) {
                        StockCommanResponse productsModel = snapshot.data!;

                        _listProducts = productsModel.data1!;

                        if (selectedCategoryId != null) {
                          print('Selected Category Id = $selectedCategoryId');
                          _listProducts = _listProducts
                              .where((element) =>
                                  element.categoryId == selectedCategoryId)
                              .toList();
                          print(_listProducts.toString());
                        }

                        return _listProducts.isEmpty
                            ? Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                        // height: 500,
                                        // width: 500,
                                        child: Text(
                                      "No Data Found",
                                      style: getTextStyle(
                                          color: BLACK_COLOR,
                                          fontSize: LARGE_MINUS_FONT_SIZE),
                                    ))),
                              )
                            : GridView.count(
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                crossAxisCount: 5,
                                childAspectRatio: 1.00,
                                children: List.generate(_listProducts.length,
                                    (index) {
                                  return Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                            color: Colors.grey, width: 1.0)),
                                    child: Center(
                                      child: Container(
                                        height: 200,
                                        child: Column(
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: double.maxFinite,
                                                  height:
                                                      defaultTargetPlatform ==
                                                              TargetPlatform.iOS
                                                          ? 80
                                                          : 85,
                                                  child: _listProducts[index]
                                                              .uploadImage ==
                                                          null
                                                      ? Image.asset(
                                                          'assets/images/rue_no_img.png',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          fit: BoxFit.cover,
                                                          "$RUE_IMAGE_BASE_PATH${_listProducts[index].uploadImage}"),
                                                  //  Image.network(
                                                  //     fit: BoxFit.cover,
                                                  //     '${APIConstants.imageBaseUrl}${_listTBProducts[index].uploadImage}'),
                                                )
                                                // Image.asset('assets/rueHeader.png'),
                                                ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              width: double.maxFinite,
                                              height: defaultTargetPlatform ==
                                                      TargetPlatform.iOS
                                                  ? 48
                                                  : 55,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Center(
                                                  child: Text(
                                                    maxLines:
                                                        defaultTargetPlatform ==
                                                                TargetPlatform
                                                                    .iOS
                                                            ? 2
                                                            : 2,
                                                    _listProducts[index]
                                                            .headEnglish ??
                                                        '0',
                                                    style: getTextStyle(
                                                        color: BLACK_COLOR,
                                                        fontSize:
                                                            MEDIUM_PLUS_FONT_SIZE,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                    ? EdgeInsets.all(5.0) : EdgeInsets.all(5.0),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: GREEN_COLOR,
                                                  ),
                                                  width: double.maxFinite,
                                                  height:
                                                      defaultTargetPlatform ==
                                                              TargetPlatform.iOS
                                                          ? 20
                                                          : 30,
                                                  child: Center(
                                                    child: Text(
                                                      '${_listProducts[index].qty ?? '0.0'}',
                                                      style: getTextStyle(
                                                          color: WHITE_COLOR,
                                                          fontSize: defaultTargetPlatform ==
                                                                  TargetPlatform
                                                                      .iOS
                                                              ? MEDIUM_FONT_SIZE
                                                              : MEDIUM_PLUS_FONT_SIZE,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                      } else {
                        return const Text('Loading...');
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Stocks')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                buildDropdown<Location>(
                  label: "Location",
                  items: _listLocation,
                  selectedValue: currentSelectedValue,
                  onChanged: (val) async {
                    currentSelectedValue = val;
                    indForLocation = _listLocation.indexWhere((loc) => loc.id == currentSelectedValue?.id);
                    await fetchStockData();
                  },
                  getLabel: (loc) => loc.location!,
                ),
                SizedBox(width: 10),
                buildDropdown<api.Category>(
                  label: "Category",
                  items: _listCategory,
                  selectedValue: currentCatSelectedValue,
                  onChanged: (val) async {
                    // print(val);
                    currentCatSelectedValue = val;
                    selectedCategoryId = currentCatSelectedValue!.id;
                    // await fetchStockData();
                    // if (selectedCategoryId != null) {
                    //   _listProducts = _listProducts
                    //       .where((p) => p.categoryId == selectedCategoryId)
                    //       .toList() ?? [];
                    // }

                    // if (selectedCategoryId != null) {
                    //   _listProducts = _listProducts
                    //       .where((p) => p.categoryId == selectedCategoryId)
                    //       .toList() ?? [];
                    // }
                   
                    setState(() {
                      if (selectedCategoryId != null && selectedCategoryId != 0) {
                        _listProducts = [];
                        _listProducts = _filterProducts
                            .where((p) => p.categoryId == selectedCategoryId)
                            .toList() ?? [];
                      }else{
                        _listProducts = [];
                        _listProducts = _filterProducts;
                      }
                    });
                    // fetchStockData();
                  },
                  getLabel: (cat) => cat.english!,
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _listProducts.isEmpty
                  ? Center(child: Text("No Data Found"))
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getResponsiveAxisCount(context),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: Device.get().isTablet
                      ? getResponsiveRatio(context)
                      : 4 / 2, // Slightly increased to make space
                ),
                itemCount: _listProducts.length,
                itemBuilder: (context, index) {
                  final product = _listProducts[index];
                  return
                    Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey)),
                    child:
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 1,
                              blurRadius: 0,
                              offset: Offset(1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: defaultTargetPlatform == TargetPlatform.iOS
                            ? const EdgeInsets.only(bottom: 4, top: 10)
                            : const EdgeInsets.only(bottom: 8, top: 10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  width: Device.get().isTablet
                                      ? defaultTargetPlatform == TargetPlatform.iOS
                                      ? 50
                                      : 55
                                      : 40,
                                  height: Device.get().isTablet
                                      ? defaultTargetPlatform == TargetPlatform.iOS
                                      ? 50
                                      : 55
                                      : 40,
                                  child: product.uploadImage == null
                                      ? Image.asset(
                                    'assets/images/rue_no_img.png',
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                      fit: BoxFit.cover,
                                      "$RUE_IMAGE_BASE_PATH${product.uploadImage}"),
                                ),
                              ),
                              ],),
                              Expanded(
                                child: SizedBox(
                                  // height: 120,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(children: [
                                          Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text(
                                                    product.headEnglish!,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: getTextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: BLACK_COLOR,
                                                        fontSize: Device.get().isTablet
                                                            ? MediaQuery.of(context).size.width *
                                                            0.01
                                                            : MediaQuery.of(context).size.width *
                                                            0.03),
                                                  ))),
                                        ]),
                                        defaultTargetPlatform == TargetPlatform.iOS
                                            ? hightSpacer5
                                            : hightSpacer10,
                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                          Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text(
                                                product.qty!.toStringAsFixed(1),
                                                style: getTextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: product.qty == 0.0 ? MAIN_COLOR : Colors.green,
                                                    fontSize:
                                                    // defaultTargetPlatform == TargetPlatform.iOS
                                                    //     ? MEDIUM_PLUS_FONT_SIZE
                                                    //     : LARGE_MINUS_FONT_SIZE),
                                                    Device.get().isTablet
                                                        ? MediaQuery.of(context).size.width *
                                                        0.01
                                                        : MediaQuery.of(context).size.width *
                                                        0.03),
                                              )),
                                          // const Spacer(),
                                          // const Icon(Icons.delete)
                                        ]),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
