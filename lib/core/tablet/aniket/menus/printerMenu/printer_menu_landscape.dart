import 'dart:developer';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/configs/theme_config.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/api_printer_setting/api/api_printer_service.dart';
import 'package:nb_posx/core/service/api_printer_setting/model/productAllocated.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nb_posx/core/service/category/model/categories.dart' as api;
import '../../../../../constants/asset_paths.dart';
import '../../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../../service/api_common/model/locationModel.dart';
import '../../../../service/api_printer_setting/model/categoryAllocated.dart';
import '../../../../service/api_printer_setting/model/insertCategoryAllocate.dart';
import '../../../../service/api_printer_setting/model/printerList.dart';
import '../../../../service/api_product/api/product_api_service.dart';
import '../../../../service/api_product/model/api_product.dart';
import '../../../../service/category/api/catogory_api_service.dart';
import 'addItems.dart';

class PrinterMenuLandscape extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PrinterMenuState();
}

class _PrinterMenuState extends State<PrinterMenuLandscape> {
  int _currentSegment = 1;
  List _listProduct = [];
  List _listCategories = [];
  String categoryAssign = 'Category Assigned';
  String addButton = 'Add Item';
  String showbdge = '';
  String showbdge2 = '';

  InsertCategoryAllocate _insertCategoryAllocate = InsertCategoryAllocate();

  List<CategoryAllocate> _listCategoryAllocate = [];
  List<ProductAllocate> _listProdcutAllocate = [];
  List<LocationModel> _listLocation = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIds();
  }

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

  //Deleting Category/Product allocate
  Future<InsertCategoryAllocate> delCategory_Allocate(
      String _apiString, String _id) async {
    return PrinterApiService().delAllocatedCategory(
      apiString: _apiString,
      catId: _id,
    );

    setState(() {

    });
  }

  //Deleting Category/Product allocate
  Future<InsertCategoryAllocate> del_Product_Allocate(
      String _apiString, String _id) async {
    return PrinterApiService().delAllocatedProduct(
      apiString: _apiString,
      catId: _id,
    );

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        // backgroundColor: const Color.fromRGBO(172, 182, 161, 2),
        title: Text(
          'Printer Settings',
          style: getTextStyle(fontSize: 23.0, color: BLACK_COLOR),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10),
        child: Container(
          color: const Color.fromRGBO(245, 248, 247, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSlidingSegmentedControl<int>(
                      isStretch: true,
                      isShowDivider: true,
                      initialValue: 1,
                      children: const {
                        1: Text(
                          'Category',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        2: Text('Product',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      },
                      decoration: BoxDecoration(
                        color: CupertinoColors.opaqueSeparator,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(
                              0.0,
                              2.0,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInToLinear,
                      onValueChanged: (v) {
                        setState(() {
                          _currentSegment = v;
                          if (v == 2) {
                            categoryAssign = 'Product Assign';
                          } else {
                            categoryAssign = 'Category Assign';
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          child: SearchAnchor(builder:
                              (BuildContext context, SearchController controller) {
                            return SearchBar(
                              hintText: 'Search',
                              controller: controller,
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                              leading: const Icon(Icons.search),
                            );
                          }, suggestionsBuilder:
                              (BuildContext context, SearchController controller) {
                            return List<ListTile>.generate(_listProduct.length,
                                    (int index) {
                                  final String item = _listProduct[index].salNo!;
                                  return ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      setState(() {
                                        controller.closeView(item);
                                      });
                                    },
                                  );
                                });
                          }),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    categoryAssign,
                    style: getTextStyle(fontSize: 25.0),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // if (showbdge != '')
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        borderRadius: BorderRadius.circular(22.5)),
                    child: Center(
                      child: Text(
                        _currentSegment == 1 ? showbdge : showbdge2,
                        style: getTextStyle(fontSize: 20.0, color: WHITE_COLOR),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListTile(
                      trailing: TextButton(
                          onPressed: () {
                            _openAddItemDialog(context, _currentSegment);
                            // showDialog(
                            //     context: context,
                            //     builder: (Context) =>
                            //         AlertDialog(
                            //           content: SizedBox(
                            //               width: 600,
                            //               height: 500,
                            //               child:
                            // AddItems(
                            //   type: _currentSegment,
                            // )
                            // _openAddItemDialog(context,_currentSegment),
                            // ),
                            // ));
                          },
                          child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: MAIN_COLOR,
                              ),
                              child: Center(
                                child: Text(
                                  addButton,
                                  style: getTextStyle(
                                      color: WHITE_COLOR, fontSize: 23.0),
                                ),
                              ))),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (_currentSegment == 1)
                Expanded(
                  child: _showCategoryList(),
                )
              else
                Expanded(
                  child: _showProductList(),
                )
            ],
          ),
        ),
      ),
    );
  }

  _openAddItemDialog(BuildContext context, int type) async {
    // product.price = product.price;

    var res = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SizedBox(
                width: 600,
                height: 500,
                child: AddItems(
                  type: type,
                  // attribute: attribute,
                ))));
    if (res == true) {
      // orderitems.add(product);
      // DbOrderItem().deleteProducts();
      // DbOrderItem().addUpdateProducts(product);
    }
    setState(() {});
  }

  _showCategoryList() {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: FutureBuilder<GetCategoryAllocate>(
            future: PrinterApiService().getAlocatedCategories(
                branchId: _selectedBranchId, counterId: _selectedCounterId),
            builder: (context, snapshot) {
              print("getAlocatedCategories ${snapshot.data}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                // until data is fetched, show loader
                return Center(
                  child: Container(
                      height: 100,
                      width: 100,
                      child: const CircularProgressIndicator()),
                );
              } else if (snapshot.hasData) {
                GetCategoryAllocate? getCategoryAllocate = snapshot.data;
                _listCategoryAllocate = getCategoryAllocate!.categoryAllocate!;

                showbdge = '${_listCategoryAllocate.length}';

                return GridView.count(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 4,
                  childAspectRatio: 1.8,
                  children:
                  List.generate(_listCategoryAllocate.length, (index) {
                    showbdge = '${_listCategoryAllocate.length}';
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side:
                          const BorderSide(color: Colors.grey, width: 1.0)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* Padding(
                                padding: const EdgeInsets.all(5.0),
                                child:
                                ListTile(
                                  trailing: TextButton.icon(
                                      onPressed: () {
                                        delCategory_Product_Allocate(
                                            'delCategoryAllocate',
                                            '${_listCategoryAllocate[index].id}');
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text('')),
                                  title: Text(
                                    _listCategoryAllocate[index].category ??
                                        'Null',
                                    softWrap: true,
                                    maxLines: 1,
                                    style: getTextStyle(
                                        fontSize: MEDIUM_FONT_SIZE,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),*/
                            // Row(
                            //   children: [
                            //     ListTile(
                            //       trailing: TextButton.icon(
                            //           onPressed: () {
                            //             delCategory_Product_Allocate(
                            //                 'delCategoryAllocate',
                            //                 '${_listCategoryAllocate[index].id}');
                            //           },
                            //           icon: const Icon(Icons.delete),
                            //           label: const Text('')),
                            //       title: Text(
                            //         _listCategoryAllocate[index].category ??
                            //             'Null',
                            //         softWrap: true,
                            //         maxLines: 1,
                            //         style: getTextStyle(
                            //             fontSize: MEDIUM_FONT_SIZE,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              child: Row(children: [
                                Expanded(
                                    child: Text(
                                      _listCategoryAllocate[index].category ??
                                          'Null',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: getTextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: BLACK_COLOR,
                                        fontSize: MediaQuery.of(context).size.width * 0.01,),
                                    )),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      delCategory_Allocate(
                                          'delCategoryAllocate',
                                          '${_listCategoryAllocate[index].id}');
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: SvgPicture.asset(
                                      DELETE_IMAGE,
                                      color: Colors.black,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                )
                              ]),
                            ),

                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 10.0, right: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Location 1: ',
                                      maxLines: 1,
                                      style: getTextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${_listCategoryAllocate[index].location1}',
                                      maxLines: 2,
                                      style: getTextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.01,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 20.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Location 2: ',
                                      maxLines: 1,
                                      style: getTextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.01,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${_listCategoryAllocate[index].location2}',
                                      maxLines: 2,
                                      style: getTextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.01,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
                );
              } else {
                showbdge = "0";
                return const Text('Loading...');
              }
            }));
  }

  _showProductList() {
    return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: FutureBuilder<GetproductAllocated>(
            future: PrinterApiService().getAlocatedProducts(
                branchId: _selectedBranchId, counterId: _selectedCounterId),
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
                print(
                    "Snapshot getAlocatedProducts ${snapshot.data.toString()}");
                GetproductAllocated? getProductAllocate = snapshot.data;
                // print("getAlocatedProducts ${getCategoryAllocate!.categoryAllocate.toString()}");
                if (getProductAllocate!.productAllocate!.length != 0) {
                  _listProdcutAllocate = getProductAllocate.productAllocate!;

                  showbdge2 = '${_listProdcutAllocate.length}';

                  return GridView.count(
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    crossAxisCount: 4,
                    childAspectRatio: 1.8,
                    children:
                    List.generate(_listProdcutAllocate.length, (index) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Colors.grey, width: 1.0)),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /* Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    trailing: TextButton.icon(
                                        onPressed: () {

                                          setState(() {
                                            del_Product_Allocate(
                                                '/api/Mobile/delProductAllocate',
                                                '${_listProdcutAllocate[index].id}');
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                        label: const Text('')),
                                    title: Text(
                                      _listProdcutAllocate[index].product ??
                                          'Null',
                                      style: getTextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),*/
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10.0),
                                child: Row(children: [
                                  Expanded(
                                      child: Text(
                                        _listProdcutAllocate[index].product ??
                                            'Null',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: getTextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: BLACK_COLOR,
                                            fontSize: MEDIUM_FONT_SIZE),
                                      )),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        del_Product_Allocate(
                                            'delCategoryAllocate',
                                            '${_listProdcutAllocate[index].id}');
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: SvgPicture.asset(
                                        DELETE_IMAGE,
                                        color: Colors.black,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),

                                ]
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0, right: 10.0),
                                  child:Text(
                                    _listProdcutAllocate[index].category ??
                                        'Null',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getTextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: BLACK_COLOR,
                                        fontSize: SMALL_PLUS_FONT_SIZE),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, right: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Location 1: ',
                                        maxLines: 1,
                                        style: getTextStyle(
                                            fontSize: SMALL_PLUS_FONT_SIZE,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${_listProdcutAllocate[index].location1}',
                                        maxLines: 2,
                                        style: getTextStyle(
                                            fontSize: SMALL_PLUS_FONT_SIZE,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Location 2: ',
                                        maxLines: 1,
                                        style: getTextStyle(
                                            fontSize: SMALL_PLUS_FONT_SIZE,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${_listProdcutAllocate[index].location2}',
                                        maxLines: 2,
                                        style: getTextStyle(
                                            fontSize: SMALL_PLUS_FONT_SIZE,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                } else {
                  showbdge2 = "0";
                  return Center(
                    child: Text(
                      'Oops.. Empty list \nPlease add a product',
                      style: getTextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  );
                }
              } else {
                showbdge2 = "0";
                return const Text('Loading...');
              }
            }));
  }
}
