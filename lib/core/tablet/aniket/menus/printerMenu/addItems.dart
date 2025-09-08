import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/core/service/api_printer_setting/api/api_printer_service.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nb_posx/core/service/category/model/categories.dart' as api;
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../service/api_common/model/locationModel.dart';
import '../../../../service/api_printer_setting/model/categoryAllocated.dart';
import '../../../../service/api_printer_setting/model/insertCategoryAllocate.dart';
import '../../../../service/api_printer_setting/model/printerList.dart';
import '../../../../service/api_product/api/product_api_service.dart';
import '../../../../service/api_product/model/api_product.dart';
import '../../../../service/category/api/catogory_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/api_printer_setting/model/insertCategoryAllocate.dart';

class AddItems extends StatefulWidget {
  final int type;

  const AddItems({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddItemState();
}

class _AddItemState extends State<AddItems> {
  int _currentSegment = 1;
  List _listProduct = [];
  List _listCategories = [];
  String categoryAssign = 'Category Assigned';
  String addButton = 'Add Item';
  String showbdge = '120';

  InsertCategoryAllocate _insertCategoryAllocate = InsertCategoryAllocate();

  List<Location> _listLocation = [];
  List<api.Category> _listCategory = [];
  List<Product> _listProducts = [];
  List<TbProduct> _listTBProducts = [];
  List<Printer> _listPrinter1 = [];
  List<Printer> _listPrinter2 = [];
  List<Printer> _listProductPrinter1 = [];
  List<Printer> _listProductPrinter2 = [];

  var currentSelectedValue;
  var dropdownValue;
  var dropdownValuePrinter1;
  var dropdownValuePrinter2;
  var dropdownValueProductPrinter1;
  var dropdownValueProductPrinter2;
  var indForLocation;
  var indForCategory;
  var indForProduct;
  var indForPrinter1;
  var indForPrinter2;
  var indForProductPrinter1;
  var indForProductPrinter2;
  int? selectedCategoryId = null;
  int? selectedProductId = null;
  int? selectedPrinter1Id = null;
  int? selectedPrinter2Id = null;
  int? selectedProductPrinter1Id = null;
  int? selectedProductPrinter2Id = null;

  String _selectedBranchId = '';
  String _selectedCounterId = '';
  String _userId = '11';

  Future<void> _getIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';
    });
  }

//Inseting category allocate
  Future<InsertCategoryAllocate> insCategoryAllocate() async {
    return PrinterApiService().insCategoryAllocate(
      branchId: _selectedBranchId,
      counterId: _selectedCounterId,
      categoryId: '$selectedCategoryId',
      locationId: _selectedBranchId,
      locationId1: _selectedBranchId,
      createrId: _selectedBranchId,
      modifiedBy: _selectedBranchId,
    );
  }

  //Inseting Product allocate
  Future<InsertCategoryAllocate> insProductAllocate() async {
    return PrinterApiService().insProductAllocate(
      branchId: _selectedBranchId,
      counterId: _selectedCounterId,
      productId: '$selectedProductId',
      locationId: _selectedBranchId,
      locationId1: _selectedBranchId,
      createrId: _selectedBranchId,
      modifiedBy: _selectedBranchId,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIds();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      children: [
        if (widget.type == 1)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _addAllocatedCategory(),
          )
        else
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _addAllocatedProduct(),
          ),
      ],
    ));
  }

  _addAllocatedCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Category Assign',
          style: getTextStyle(
              color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Category',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<api.Categories>(
                      future: CategoryService().getCategoryList(),
                      builder: (context, snapshot) {
                        print("getCategoryList ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          api.Categories? categoryModel = snapshot.data;
                          _listCategory = categoryModel!.category!;
                          return DropdownButton<api.Category>(
                            isExpanded: true,
                            alignment: Alignment.topLeft,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (categories) {
                              setState(() {
                                dropdownValue = categories!;
                                print('Dropdown value $dropdownValue');
                                indForCategory =
                                    _listCategory.indexOf(dropdownValue);
                                print(
                                    'inside on change:---> $indForCategory $dropdownValue');
                                selectedCategoryId =
                                    _listCategory[indForCategory].id;
                              });
                            },
                            value: _listCategory[indForCategory ?? 0],
                            items: _listCategory.map((api.Category value) {
                              return DropdownMenuItem<api.Category>(
                                  value: value,
                                  child: Text(
                                    value.english!,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Category',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Printer 1',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<PrinterList>(
                      future:
                      PrinterApiService().getPrinters(branchId: _selectedBranchId),
                      builder: (context, snapshot) {
                        print("getPrinterList ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          PrinterList? printerList = snapshot.data;
                          _listPrinter1 = printerList!.printer!;
                          return DropdownButton<Printer>(
                            isExpanded: true,
                            alignment: Alignment.bottomRight,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (printers) {
                              setState(() {
                                dropdownValuePrinter1 = printers!;
                                // print('Dropdown value $dropdownValue');
                                indForPrinter1 = _listPrinter1
                                    .indexOf(dropdownValuePrinter1);
                                // print(
                                //     'inside on change:---> $indForPrinter1 $dropdownValue');
                                selectedPrinter1Id =
                                    _listPrinter1[indForPrinter1].printerId;
                              });
                            },
                            value: _listPrinter1[indForPrinter1 ?? 0],
                            items: _listPrinter1.map((Printer value) {
                              return DropdownMenuItem<Printer>(
                                  value: value,
                                  child: Text(
                                    value.printerName!,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Printer 1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Printer 2',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<PrinterList>(
                      future:
                      PrinterApiService().getPrinters(branchId: _selectedBranchId),
                      builder: (context, snapshot) {
                        print("getCategoryList ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          PrinterList? printerList = snapshot.data;
                          _listPrinter2 = printerList!.printer!;
                          return DropdownButton<Printer>(
                            isExpanded: true,
                            alignment: Alignment.bottomRight,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (printers2) {
                              setState(() {
                                dropdownValuePrinter2 = printers2!;
                                // print(
                                //     'Dropdown value ${printers2.toString()}');
                                indForPrinter2 = _listPrinter2
                                    .indexOf(dropdownValuePrinter2);
                                // print(
                                //     'inside on change:---> $indForPrinter2 $dropdownValue');
                                selectedPrinter2Id =
                                    _listPrinter2[indForPrinter2].printerId;
                              });
                            },
                            value: _listPrinter2[indForPrinter2 ?? 0],
                            items: _listPrinter2.map((Printer value) {
                              return DropdownMenuItem<Printer>(
                                  value: value,
                                  child: Text(
                                    value.printerName!,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Printer 2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: 250,
          // height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: MAIN_COLOR,
          ),
          child: TextButton(
              onPressed: () async {
                _insertCategoryAllocate = await insCategoryAllocate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      content: Text(_insertCategoryAllocate.message!),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context,true);
                              // Navigator.of(context, rootNavigator: true).pop();
                              // dispose();
                            },
                            child: const Text('OK'))
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Add Category',
                style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
              )),
        ),
      ],
    );
  }

  _addAllocatedProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Product Assign',
          style: getTextStyle(
              color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<ApiProduct>(
                      future: ProductService().getAllProducts(branchId: _selectedBranchId),
                      builder: (context, snapshot) {
                        print("requestAllProducts ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          ApiProduct? productsModel = snapshot.data;
                          _listProducts = productsModel!.product!;
                          for (var _tbList in _listProducts) {
                            var tb_list = _tbList.tbProduct;
                            if (tb_list?.isNotEmpty != null) {
                              // _listTBProducts.add(tb_list!);
                              for (var _products in tb_list!) {
                                _listTBProducts.add(_products);
                              }
                            }
                          }
                          if (selectedCategoryId != null) {
                            print('Selected Category Id = $selectedCategoryId');
                            _listTBProducts = _listTBProducts
                                .where((element) =>
                                    element.categoryId == selectedCategoryId)
                                .toList();
                            print(_listTBProducts.toString());
                          }
                          return DropdownButton<TbProduct>(
                            isExpanded: true,
                            alignment: Alignment.bottomLeft,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (productss) {
                              setState(() {
                                dropdownValue = productss!;
                                indForProduct =
                                    _listTBProducts.indexOf(dropdownValue);
                                selectedProductId =
                                    _listTBProducts[indForProduct].id;
                              });
                            },
                            value: _listTBProducts[indForProduct ?? 0],
                            items: _listTBProducts.map((TbProduct value) {
                              return DropdownMenuItem<TbProduct>(
                                  value: value,
                                  child: Text(
                                    value.headEnglish!,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Category',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Printer 1',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<PrinterList>(
                      future:
                      PrinterApiService().getPrinters(branchId: _selectedBranchId),
                      builder: (context, snapshot) {
                        print("getPrinterList ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          PrinterList? printerList = snapshot.data;
                          _listProductPrinter1 = printerList!.printer!;
                          return DropdownButton<Printer>(
                            isExpanded: true,
                            alignment: Alignment.bottomRight,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              setState(() {
                                dropdownValueProductPrinter1 = value!;
                                // print(
                                //     'Dropdown value ${value.printerName} ${_listPrinter[3].printerName}');
                                indForProductPrinter1 = _listProductPrinter1
                                    .indexOf(dropdownValueProductPrinter1);

                                selectedProductPrinter1Id =
                                    _listProductPrinter1[indForProductPrinter1]
                                        .printerId;
                              });
                            },
                            value: _listProductPrinter1[
                                indForProductPrinter1 ?? 0],
                            items: _listProductPrinter1.map((Printer value) {
                              return DropdownMenuItem<Printer>(
                                  value: value,
                                  child: Text(
                                    value.printerName!,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Printer 1',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Printer 2',
              style: getTextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 120,
            ),
            Expanded(
              child: Container(
                  child: FutureBuilder<PrinterList>(
                      future:
                      PrinterApiService().getPrinters(branchId: _selectedBranchId),
                      builder: (context, snapshot) {
                        print("getCategoryList ${snapshot.data}");
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          PrinterList? printerList = snapshot.data;
                          _listProductPrinter2 = printerList!.printer!;
                          return DropdownButton<Printer>(
                            isExpanded: true,
                            alignment: Alignment.bottomRight,
                            // dropdownColor: Colors.brown,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onChanged: (printersP2) {
                              setState(() {
                                dropdownValueProductPrinter2 = printersP2!;
                                // print(
                                //     'Dropdown value ${printersP2.toString()}');
                                indForProductPrinter2 = _listProductPrinter2
                                    .indexOf(dropdownValueProductPrinter2);
                                // print(
                                //     'inside on change:---> $indForProductPrinter2 $dropdownValue');
                                selectedProductPrinter2Id =
                                    _listProductPrinter2[indForProductPrinter2]
                                        .printerId;
                              });
                            },
                            value: _listProductPrinter2[
                                indForProductPrinter2 ?? 0],
                            items: _listProductPrinter2.map((Printer value) {
                              return DropdownMenuItem<Printer>(
                                  value: value,
                                  child: Text(
                                    value.printerName!,
                                    style: getTextStyle(
                                        // color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }).toList(),
                            hint: const Text(
                              'Select Printer 2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return const Text('Loading...');
                        }
                      })),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: 250,
          // height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: MAIN_COLOR,
          ),
          child: TextButton(
              onPressed: () async {
                _insertCategoryAllocate = await insProductAllocate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      content: Text(_insertCategoryAllocate.message!),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('OK'))
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Add Product',
                style: getTextStyle(fontSize: 22.0, color: WHITE_COLOR),
              )),
        ),
      ],
    );
  }
}
