import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/cat_pro_api_service.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/product_common_response.dart';
import 'package:nb_posx/core/service/api_product/api/product_api_service.dart';
import 'package:nb_posx/core/service/api_product/model/product_common_response.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import 'package:nb_posx/database/models/api_product_addon.dart';
import 'package:nb_posx/database/models/api_product_addon_topping.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';

import '../../../../database/db_utils/db_categories.dart';
import '../../../../database/models/category.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/product.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/db_utils/db_order_item.dart';
import '../../../database/models/order_item.dart';
import '../../../main.dart';
import '../../../widgets/item_options2.dart';
import '../widget/create_customer_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/title_search_bar.dart';

import 'package:nb_posx/core/service/api_product/model/api_product.dart'
    as aiPro;

import 'package:nb_posx/database/models/api_product.dart' as dbpro;

class ProductsLandscape extends StatefulWidget {
  const ProductsLandscape({Key? key}) : super(key: key);

  @override
  State<ProductsLandscape> createState() => _ProductsLandscapeState();
}

class _ProductsLandscapeState extends State<ProductsLandscape> {
  late TextEditingController searchCtrl;
  late Size size;
  Customer? customer;

  // List<Product> products = [];
  // List<Category> categories = [];
  // List<aiPro.Product> products = [];

  //   List<dbpro.APIProduct> dbproducts = [];
  // List<APIProductAddon> dbproductaddon = [];
  List<Product> product = [];
  List<Attribute> attributeList = [];
  List<OrderItem> orderitems = [];

  @override
  void initState() {
    searchCtrl = TextEditingController();
    super.initState();
    getProducts();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: GestureDetector(
            onTap: _handleTap,
            child: Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TitleAndSearchBar(
                    inputFormatter: [],
                    focusNode: _focusNode,
                    title: "Product List",
                    onSubmit: (text) {
                      if (text.length >= 3) {
                        _filterProductsCategories(text);
                      } else {
                        getProducts();
                      }
                    },
                    onTextChanged: (changedtext) {
                      if (changedtext.length >= 3) {
                        _filterProductsCategories(changedtext);
                      } else {
                        getProducts();
                      }
                    },
                    searchCtrl: searchCtrl,
                    searchHint: "Search product",
                    searchBoxWidth: size.width / 4,
                  ),
                  // hightSpacer20,
                  // getCategoryListWidget(),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Total Items: ${product.length}",
                          textAlign: TextAlign.end,
                          style: getTextStyle(
                            fontSize: MEDIUM_FONT_SIZE,
                          ),
                        ),
                      )),
                  // hightSpacer20,
                  // ListView.builder(
                  //             primary: false,
                  //             shrinkWrap: true,
                  //             itemCount: 1,
                  //             itemBuilder: (context, index) {
                  //               return Column(
                  //                 children: [
                  //                   attributeList.isEmpty
                  //                       ? const Center(
                  //                           child: Text(
                  //                           "No items found",
                  //                           style: TextStyle(fontWeight: FontWeight.bold),
                  //                         ))
                  //                       : getCategoryItemsWidget(attributeList),
                  //                   hightSpacer10
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  product.isEmpty
                      ? const Center(
                          child: Text(
                          "No items found",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      : getCategoryItemsWidget(product),
                ],
              )
            ])));
  }

  getCategoryItemsWidget(List<Product> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 10),
        //   child: Text(
        //     cat.english!,
        //     style: getTextStyle(
        //       fontSize: MEDIUM_FONT_SIZE,
        //     ),
        //   ),
        // ),
        // hightSpacer5,
        SizedBox(
          // height: MediaQuery.of(context).size.height * 0.83,
          // width: size.width,

          width: isTabletMode
              // ? double.infinity
              ? size.width
              : MediaQuery.of(context).size.width * 0.9,
          height: isTabletMode
              ? MediaQuery.of(context).size.height * 0.83
              : MediaQuery.of(context).size.height * 0.9,
          child: GridView.builder(
              itemCount: product.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: GestureDetector(
                      onTap: () {
                        _handleTap();

                        // double displayQty = 0;
                        // double price = 0;
                        // int? id = 0;
                        // String? name;
                        // for (int i = 0; i < product.length; i++) {
                        // id = attributeList[0].id;
                        // displayQty = product[0].stock;
                        // price = product[0].price;
                        // name = product[0].name;
                        // }
                        //
                        // // log('Selected Item displayQty:: $displayQty');
                        // if (displayQty > 0.0) {
                        //   List<Attribute> listattr = [];
                        //   List<Option> listaddonTopping = [];
                        //
                        //   for (int i = 0; i < attributeList.length; i++) {
                        //     //  displayQty = cat.moq;
                        //     for (int j = 0;
                        //     j < attributeList[i].options.length;
                        //     j++) {
                        //       String id =
                        //       attributeList[i].options[j].id.toString();
                        //       listaddonTopping.add(Option(
                        //           id: id,
                        //           name: attributeList[i].options[j].name,
                        //           price: attributeList[i].options[j].price,
                        //           selected: false,
                        //           tax: 0));
                        //
                        //       //  attributeList[i].options.add(Option(
                        //       // id: id,
                        //       // name: attributeList[i].options[j].name,
                        //       // price: attributeList[i].options[j].price,
                        //       // selected: false,
                        //       // tax: 0));
                        //     }
                        //
                        //     // price = dbproductaddon[i].rate;
                        //     // log('Selected Item price:: $price');
                        //
                        //     listattr.add(Attribute(
                        //         id: attributeList[i].id,
                        //         name: attributeList[i].name,
                        //         type: "",
                        //         moq: attributeList[i].moq,
                        //         options: listaddonTopping,
                        //         rate: attributeList[i].rate));
                        //   }
                        //
                        //   OrderItem orderItem = OrderItem(
                        //       id: id.toString(),
                        //       name: name!,
                        //       group: "",
                        //       description: name!,
                        //       stock: displayQty,
                        //       price: price,
                        //       orderedQuantity: 1,
                        //       attributes: listattr,
                        //       productImage: Uint8List(0),
                        //       productUpdatedTime: DateTime.now(),
                        //       productImageUrl: "");
                        //
                        //   _openItemDetailDialog(context, orderItem);
                        // }
                      },
                      child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                              // dbproducts[index].id! > 0
                              //     ?
                              Colors.transparent,
                              //     :
                              // Colors.white.withOpacity(0.6),
                              // GREY_COLOR,
                              BlendMode.screen),
                          child: Stack(
                            // alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: paddingXY(x: 1, y: 2),
                                  padding: paddingXY(y: 0, x: 10),
                                  width: 200,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      color: WHITE_COLOR,
                                      border: Border.all(
                                          width: 2, color: BLACK_COLOR),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      hightSpacer40,
                                      SizedBox(
                                        height: 20,
                                        child: Text(
                                          product[index].name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(

                                              // color: DARK_GREY_COLOR,
                                              // fontWeight: FontWeight.w500,
                                              fontSize: MEDIUM_FONT_SIZE),
                                        ),
                                      ),
                                      // hightSpacer5,
                                      Text(
                                        // "$appCurrency ${products[index].tbProduct![0].rate?.toStringAsFixed(2)}",

                                        // ignore: unnecessary_null_comparison
                                        '$appCurrency ${product != null ? product[index].price : 0.0}',
                                        textAlign: TextAlign.end,
                                        style: getTextStyle(
                                            color: MAIN_COLOR,
                                            fontSize: MEDIUM_PLUS_FONT_SIZE),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: WHITE_COLOR),
                                  //     shape: BoxShape.circle),
                                  child: Container(
                                margin:
                                    const EdgeInsets.only(left: 50, right: 5),
                                height: 80,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child:
                                    Image.asset('assets/images/pizza_img.png'),
                              )),
                              // Container(
                              //   padding: const EdgeInsets.all(6),
                              //   margin: const EdgeInsets.only(left: 45),
                              //   decoration: const BoxDecoration(
                              //       shape: BoxShape.circle, color: GREEN_COLOR),
                              //   // child: Text(
                              //   //   products[index]
                              //   //       .tbProduct![0]
                              //   //       .displayQty!
                              //   //       .toInt()
                              //   //       .toString(),
                              //   //   style: getTextStyle(
                              //   //       fontSize: SMALL_FONT_SIZE,
                              //   //       color: WHITE_COLOR),
                              //   // )
                              // )
                            ],
                          ))))),
        ),
      ],
    );
  }

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    product.price = product.price;
    if (product.orderedQuantity == 0) {
      product.orderedQuantity = 1;
    }
    var res = await showDialog(
        context: context,
        builder: (context) {
          return ItemOptions2(
            orderItem: product,
            // attribute: attribute,
          );
        });
    if (res == true) {
      orderitems.add(product);
      // DbOrderItem().deleteProducts();
      DbOrderItem().addProducts(orderitems);
    }
    setState(() {});
  }

  getCategoryItemsWidget2(dbpro.APIProduct cat) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 10),
        //   child: Text(
        //     "Total Items: ${tbproduct.length}",
        //     style: getTextStyle(
        //       fontSize: MEDIUM_FONT_SIZE,
        //     ),
        //   ),
        // ),
        // hightSpacer4,
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          width: size.width,
          child: GridView.builder(
              itemCount: product.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemBuilder: (context, index) => Center(
                  // padding:  const EdgeInsets.all(20),

                  child: GestureDetector(
                      onTap: () {
                        _handleTap();

                        // if (customer == null) {
                        //   _handleCustomerPopup();
                        // } else {
                        // if (products[index].tbProduct != null) {
                        //   tbproducts = products[index].tbProduct!;
                        //   var displayQty;
                        //   var price;
                        //   for (int i = 0; i < tbproducts.length; i++) {
                        //     displayQty = tbproducts[i].displayQty;
                        //     price = tbproducts[i].rate;
                        //   }

                        //   log('Selected Item displayQty:: $displayQty');
                        //   if (displayQty != null && displayQty > 0.0) {
                        //     int? id = products[index].id;
                        //     String pro_id = '$id';

                        //     OrderItem orderItem = OrderItem(
                        //         id: pro_id,
                        //         name: products[index].english!,
                        //         group: "",
                        //         description: products[index].english!,
                        //         stock: displayQty,
                        //         price: price,
                        //         attributes: List.empty(),
                        //         productImage: Uint8List(0),
                        //         productUpdatedTime: DateTime.now(),
                        //         productImageUrl: "");
                        //     // var item = OrderItem.fromJson(products[index].toString());

                        //     log('Selected Item :: $orderItem');
                        //     _openItemDetailDialog(context, orderItem);
                        //   } else {
                        //     Helper.showPopup(
                        //         context, 'Sorry, item is not in stock.');
                        //   }
                        // }

                        // }
                      },
                      child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              product[index].id > 0
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.6),
                              BlendMode.screen),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: paddingXY(x: 5, y: 10),
                                  padding: paddingXY(y: 0, x: 20),
                                  width: 160,
                                  height: 90,
                                  decoration: BoxDecoration(
                                      color: WHITE_COLOR,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // hightSpacer5,
                                      SizedBox(
                                        height: 20,
                                        child: Text(
                                          product[index].name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(

                                              // color: DARK_GREY_COLOR,
                                              // fontWeight: FontWeight.w500,
                                              fontSize: MEDIUM_FONT_SIZE),
                                        ),
                                      ),
                                      hightSpacer4,
                                      Text(
                                        // "$appCurrency ${products[index].tbProduct![0].rate?.toStringAsFixed(2)}",
                                        '$appCurrency 0',
                                        textAlign: TextAlign.end,
                                        style: getTextStyle(
                                            color: MAIN_COLOR,
                                            fontSize: SMALL_PLUS_FONT_SIZE),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: WHITE_COLOR),
                                      shape: BoxShape.circle),
                                  child: Container(
                                    // margin: const EdgeInsets.only(
                                    //     left: 5, right: 5),
                                    height: 100,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                        'assets/images/pizza_img.png'),
                                  )),
                              // Container(
                              //   padding: const EdgeInsets.all(6),
                              //   margin: const EdgeInsets.only(left: 45),
                              //   decoration: const BoxDecoration(
                              //       shape: BoxShape.circle, color: GREEN_COLOR),
                              //   // child: Text(
                              //   //   products[index]
                              //   //       .tbProduct![0]
                              //   //       .displayQty!
                              //   //       .toInt()
                              //   //       .toString(),
                              //   //   style: getTextStyle(
                              //   //       fontSize: SMALL_FONT_SIZE,
                              //   //       color: WHITE_COLOR),
                              //   // )
                              // )
                            ],
                          ))))),
        ),
      ],
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     // Text(
    //     //   cat.english!,
    //     //   style: getTextStyle(
    //     //     fontSize: LARGE_FONT_SIZE,
    //     //   ),
    //     // ),
    //     hightSpacer10,
    //     SizedBox(
    //       height: 140,
    //       child: ListView.builder(
    //           scrollDirection: Axis.horizontal,
    //           itemCount: products.length,
    //           itemBuilder: (BuildContext context, index) {
    //             return Container(
    //                 margin: const EdgeInsets.only(left: 8, right: 8),
    //                 child: InkWell(
    //                   onTap: () {
    //                     // var item =
    //                     //     OrderItem.fromJson(cat.items[index].toJson());
    //                     // _openItemDetailDialog(context, item);
    //                     debugPrint("Item clicked $index");
    //                   },
    //                   child: Stack(
    //                     alignment: Alignment.topCenter,
    //                     children: [
    //                       Align(
    //                         alignment: Alignment.bottomCenter,
    //                         child: Container(
    //                           margin: paddingXY(x: 5, y: 5),
    //                           padding: paddingXY(y: 0, x: 10),
    //                           width: 145,
    //                           height: 105,
    //                           decoration: BoxDecoration(
    //                               color: WHITE_COLOR,
    //                               borderRadius: BorderRadius.circular(10)),
    //                           child: Column(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             crossAxisAlignment: CrossAxisAlignment.stretch,
    //                             children: [
    //                               hightSpacer25,
    //                               SizedBox(
    //                                 child: Text(
    //                                   products[index].english!,
    //                                   maxLines: 2,
    //                                   overflow: TextOverflow.ellipsis,
    //                                   style: getTextStyle(
    //                                       color: DARK_GREY_COLOR,
    //                                       fontWeight: FontWeight.w500,
    //                                       fontSize: SMALL_PLUS_FONT_SIZE),
    //                                 ),
    //                               ),
    //                               hightSpacer5,
    //                               Text(
    //                                 "$appCurrency 0}",
    //                                 textAlign: TextAlign.right,
    //                                 style: getTextStyle(
    //                                     color: MAIN_COLOR,
    //                                     fontSize: MEDIUM_FONT_SIZE),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 60,
    //                         width: 60,
    //                         decoration:
    //                             const BoxDecoration(shape: BoxShape.circle),
    //                         clipBehavior: Clip.antiAliasWithSaveLayer,
    //                         // child: cat.items[index].productImage.isNotEmpty
    //                         //     ? Image.memory(cat.items[index].productImage,
    //                         //         fit: BoxFit.fill)
    //                         //     : SvgPicture.asset(
    //                         //         PRODUCT_IMAGE,
    //                         //       ),
    //                       ),
    //                     ],
    //                   ),
    //                 ));
    //           }),
    //     ),
    //   ],
    // );
  }

  getCategoryListWidget() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: product.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              child: Container(
                margin: paddingXY(y: 5),
                width: 70,
                decoration: BoxDecoration(
                  color: WHITE_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // categories[index].image.isNotEmpty
                    //     ? Image.memory(
                    //         products[index].image,
                    //         height: 45,
                    //         width: 45,
                    //       )
                    //     : Image.asset(
                    //         BURGAR_IMAGE,
                    //         height: 45,
                    //         width: 45,
                    //       ),
                    Text(
                      product[index].name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  _handleCustomerPopup() async {
    final result = await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SelectCustomerPopup(
        customer: customer,
      ),
    );
    if (result.runtimeType == String) {
      customer = await Get.defaultDialog(
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        // custom: Container(),
        content: CreateCustomerPopup(
          phoneNo: result,
        ),
      );
    }
    if (customer != null) {
      debugPrint("Customer selected");
    }
    setState(() {});
  }

  Future<void> getProducts() async {
    product = await DbProduct().getAllProducts();

    if (product.isNotEmpty) {
      product = product;
      attributeList.clear();
      for (int i = 0; i < product.length; i++) {
        attributeList.addAll(product[i].attributes);
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String _selectedBranchId = prefs.getString(BranchId) ?? '';
      ProductCommanResponse2 apiProResponse =
          await CatProductService.getProducts(_selectedBranchId);

      product = await DbProduct().getAllProducts();

      attributeList.clear();
      for (int i = 0; i < product.length; i++) {
        attributeList.addAll(product[i].attributes);
      }
    }

    setState(() {});
  }

  void _filterProductsCategories(String searchTxt) {
    product = product
        .where((element) =>
            element.name!.toLowerCase().contains(searchTxt.toLowerCase()))
        .toList();

    setState(() {});
  }
}
