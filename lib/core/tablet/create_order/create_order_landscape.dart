import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:get/get.dart';
import 'package:nb_posx/core/service/api_product/api/product_api_service.dart';
import 'package:nb_posx/core/service/api_product/model/product_common_response.dart';
import 'package:nb_posx/core/service/category/api/catogory_api_service.dart';
import 'package:nb_posx/core/service/category/model/categories.dart' as aiCat;
import 'package:nb_posx/core/service/category/model/category_comman_response.dart';
import 'package:nb_posx/core/tablet/create_order/cart_widget%20copy.dart';
import 'package:nb_posx/database/db_utils/db_order_item.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import 'package:nb_posx/database/models/api_order_item.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/option.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/widgets/item_options2.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/models/api_category.dart' as dbcat;
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../database/models/order_item.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../../widgets/item_options.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/create_customer_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/title_search_bar.dart';
import 'cart_widget.dart';

class CreateOrderLandscape extends StatefulWidget {
  final RxString selectedView;
  const CreateOrderLandscape({Key? key, required this.selectedView})
      : super(key: key);

  @override
  State<CreateOrderLandscape> createState() => _CreateOrderLandscapeState();
}

class _CreateOrderLandscapeState extends State<CreateOrderLandscape> {
  late TextEditingController searchCtrl;
  late Size size;
  Customer? customer;
  // List<aiPro.Product> products = [];
  // List<aiPro.TbProduct> tbproducts = [];
  List<dbcat.APICategory> categories = [];
  // List<dbpro.APIProduct> dbproducts = [];

  List<Product> product = [];
  List<Attribute> attributeList = [];
  // List<APIProductAddon> dbproductaddon = [];
  // ParkOrder? parkOrder;
  late List<APIOrderItem> items;
  late List<OrderItem> orderitems;
  int currentSelectedIndex = 0;
  var isChecked;

// double _aspectRatio = 0;
  // late aiPro.Product _product =
  //     new aiPro.Product(0, "", "", 0, "", List.empty());

  @override
  void initState() {
    items = [];
    orderitems = [];
    searchCtrl = TextEditingController();
    super.initState();
    // verify();
    getCategory();
    getProducts();

//     // ignore: use_build_context_synchronously
// Helper.hideLoader(context);
    if (Helper.activeParkedOrder != null) {
      log("park order is active");
      customer = Helper.activeParkedOrder!.customer;
      // items = Helper.activeAPIParkedOrder!.items;
    }

    //  var _crossAxisSpacing = 8;
    // var _screenWidth = MediaQuery.of(context).size.width;
    // var _crossAxisCount = 5;
    // var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
    //     _crossAxisCount;
    // var cellHeight = 600;
    //  _aspectRatio = _width / cellHeight;

    //  log("aspect $_aspectRatio" );
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: _handleTap,
        child: Row(
          children: [
            SizedBox(
              width: Device.get().isTablet ? size.width - 450 : size.width ,
              height: size.height,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TitleAndSearchBar(
                    focusNode: _focusNode,
                    inputFormatter: [],
                    title: "Place Order",
                    onSubmit: (text) {
                      if (text.length >= 3) {
                        categories.isEmpty
                            ? const Center(
                                child: Text(
                                "No items found",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                            : _filterProductsCategories(text);
                      } else {
                        getProducts();
                        getCategory();
                      }
                    },
                    onTextChanged: (changedtext) {
                      if (changedtext.length >= 3) {
                        categories.isEmpty
                            ? const Center(
                                child: Text(
                                "No items found",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                            : _filterProductsCategories(changedtext);
                      } else {
                        getProducts();
                        getCategory();
                      }
                    },
                    searchCtrl: searchCtrl,
                    searchHint: "Search product / category",
                    searchBoxWidth: size.width / 4,
                  ),
                  // hightSpacer15,

                  categories.isEmpty
                      ? const Center(
                          child: Text(
                          "No items found",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ))
                      : getCategoryListWidg(),
                  // hightSpacer10,
                  // ListView.builder(
                  //   primary: true,
                  //   shrinkWrap: true,
                  //   itemCount: 1,
                  //   itemBuilder: (context, index) {
                  //     return Column(
                  //       children: [
                  //         attributeList.isEmpty
                  //             ? const Center(
                  //                 child: Text(
                  //                 "No items found",
                  //                 style: TextStyle(fontWeight: FontWeight.bold),
                  //               ))
                  //             : getCategoryItemsWidget(
                  //                 attributeList[index], attributeList),
                  //         hightSpacer20
                  //       ],
                  //     );
                  //   },
                  // ),
                   attributeList.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No items found",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                              : getCategoryItemsWidget(attributeList),
                ],
              )),
            ),
            Padding(
              padding: leftSpace(x: 5),
              child: CartWidget(
                customer: customer,
                orderList: orderitems,
                onHome: () {
                  widget.selectedView.value = "Home";
                  orderitems.clear();
                  customer = null;
                  setState(() {});
                },
                onPrintReceipt: () {
                  widget.selectedView.value = "Home";
                  orderitems.clear();
                  customer = null;
                  setState(() {});
                },
                onNewOrder: () {
                  customer = null;
                  orderitems = [];
                  setState(() {});
                }, onCartUpdate: (int i, double total) {  },
              ), //_cartWidget()
            ),
          ],
        ));
  }

  getCategoryItemsWidget(List<Attribute> tbproduct) {
    // log('getCategoryItemsWidget ${tbproduct}');
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
          height: MediaQuery.of(context).size.height * 0.90,
          width: size.width,

          child: GridView.builder(
              itemCount: tbproduct.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: GestureDetector(
                      onTap: () {
                        // _handleTap();

                        // if (customer == null) {
                        //   _handleCustomerPopup();
                        // } else {
                        // dbproductaddon = product[index].attributes!;
                        double displayQty = 0;
                        double price = 0;
                        int? id = 0;
                        String? name;
                        for (int i = 0;
                            i < tbproduct.length;
                            i++) {
                            id   = attributeList[0].id;
                          displayQty = tbproduct[0].moq;
                          price = tbproduct[0].rate;
                          name = tbproduct[0].name;
                        }

                        

                        // log('Selected Item displayQty:: $displayQty');
                        if (displayQty > 0.0) {
                         
                          List<Attribute> listattr = [];
                          List<Option> listaddonTopping = [];

                         

                          for (int i = 0; i < attributeList.length; i++) {

                             

                            //  displayQty = cat.moq;
                            for (int j = 0; j < attributeList[i].options.length; j++) {

                              String id = attributeList[i].options[j].id.toString();
                              listaddonTopping.add(Option(
                                  id: id,
                                  name: attributeList[i].options[j].name,
                                  price: attributeList[i].options[j].price,
                                  selected: false,
                                  tax: 0));

                                  //  attributeList[i].options.add(Option(
                                  // id: id,
                                  // name: attributeList[i].options[j].name,
                                  // price: attributeList[i].options[j].price,
                                  // selected: false,
                                  // tax: 0));
                            }

                            // price = dbproductaddon[i].rate;
                            // log('Selected Item price:: $price');
                           
                            listattr.add(Attribute(id: attributeList[i].id, name: attributeList[i].name, type: "", moq: attributeList[i].moq,qty: 0,
                             options: listaddonTopping, rate: attributeList[i].rate, toppingId:  attributeList[i].toppingId));
                          }

                          OrderItem orderItem = OrderItem(
                              id: id.toString(),
                              name: name!,
                              group: "",
                              description: name!,
                              stock: displayQty,
                              price: price,
                              taxCode: "",
                              message: "",
                              orderedQuantity: 1,
                              attributes: listattr,
                              productImage: '',
                              productUpdatedTime: DateTime.now(),
                              productImageUrl: "");

                          _openItemDetailDialog(context, orderItem);

                          // Helper.showPopup(
                          //     context, orderItem.toString());

                          // var item = OrderItem.fromJson(products[index].toString());

                          log('Selected Item :: ${orderItem.toString()}');
                          // log('Selected Item :: ${cat.toString()}');
                        } else {
                          Helper.showPopup(
                              context, 'Sorry, item is not in stock.');
                        }

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
                                          tbproduct[index].name!,
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

                                        
                                        '$appCurrency ${tbproduct != null ? tbproduct[index].rate : 0.0}',
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
                                    const EdgeInsets.only(left: 55, right: 5),
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

          // ListView.builder(
          //     scrollDirection: Axis.vertical,
          //     itemCount: products.length,
          //      shrinkWrap: true,

          //     itemBuilder: (BuildContext context, index) {
          //       return Padding(
          //           padding: const EdgeInsets.only(right: 15),
          //           child: GestureDetector(
          //               onTap: () {
          //                 _handleTap();

          //                 // if (customer == null) {
          //                 //   _handleCustomerPopup();
          //                 // } else {
          //                 if (products[index].tbProduct != null) {
          //                   tbproducts = products[index].tbProduct!;
          //                   var displayQty;
          //                   var price;
          //                   for (int i = 0; i < tbproducts.length; i++) {
          //                     displayQty = tbproducts[i].displayQty;
          //                     price = tbproducts[i].rate;
          //                   }

          //                   log('Selected Item displayQty:: $displayQty');
          //                   if (displayQty != null && displayQty > 0.0) {
          //                     int? id = products[index].id;
          //                     String pro_id = '$id';

          //                     OrderItem orderItem = OrderItem(
          //                         id: pro_id,
          //                         name: products[index].english!,
          //                         group: "",
          //                         description: products[index].english!,
          //                         stock: displayQty,
          //                         price: price,
          //                         attributes: List.empty(),
          //                         productImage: Uint8List(0),
          //                         productUpdatedTime: DateTime.now(),
          //                         productImageUrl: "");
          //                     // var item = OrderItem.fromJson(products[index].toString());

          //                     log('Selected Item :: $orderItem');
          //                     _openItemDetailDialog(context, orderItem);
          //                   } else {
          //                     Helper.showPopup(
          //                         context, 'Sorry, item is not in stock.');
          //                   }
          //                 }

          //                 // }
          //               },
          //               child: ColorFiltered(
          //                   colorFilter: ColorFilter.mode(
          //                       products[index].id! > 0
          //                           ? Colors.transparent
          //                           : Colors.white.withOpacity(0.6),
          //                       BlendMode.screen),
          //                   child: Stack(
          //                     alignment: Alignment.topCenter,
          //                     children: [
          //                       Align(
          //                         alignment: Alignment.bottomCenter,
          //                         child: Container(
          //                           margin: paddingXY(x: 5, y: 20),
          //                           padding: paddingXY(y: 0, x: 10),
          //                           width: 145,
          //                           height: 100,
          //                           decoration: BoxDecoration(
          //                               color: WHITE_COLOR,
          //                               borderRadius:
          //                                   BorderRadius.circular(10)),
          //                           child: Column(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.start,
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.stretch,
          //                             children: [
          //                               hightSpacer40,
          //                               SizedBox(
          //                                 height: 20,
          //                                 child: Text(
          //                                   products[index].english!,
          //                                   maxLines: 1,
          //                                   overflow: TextOverflow.ellipsis,
          //                                   textAlign: TextAlign.center,
          //                                   style: getTextStyle(

          //                                       // color: DARK_GREY_COLOR,
          //                                       // fontWeight: FontWeight.w500,
          //                                       fontSize: MEDIUM_FONT_SIZE),
          //                                 ),
          //                               ),
          //                               hightSpacer4,
          //                               Text(
          //                                 // "$appCurrency ${products[index].tbProduct![0].rate?.toStringAsFixed(2)}",
          //                                 '$appCurrency 0',
          //                                 textAlign: TextAlign.end,
          //                                 style: getTextStyle(
          //                                     color: MAIN_COLOR,
          //                                     fontSize: SMALL_PLUS_FONT_SIZE),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                       Container(
          //                           decoration: BoxDecoration(
          //                               border: Border.all(color: WHITE_COLOR),
          //                               shape: BoxShape.circle),
          //                           child: Container(
          //                             margin: const EdgeInsets.only(
          //                                 left: 5, right: 5),
          //                             height: 58,
          //                             clipBehavior: Clip.antiAliasWithSaveLayer,
          //                             decoration: const BoxDecoration(
          //                                 shape: BoxShape.circle),
          //                             // child: cat
          //                             //         .items[index].productImage.isEmpty
          //                             //     ? Image.asset(BURGAR_IMAGE)
          //                             //     : Image.memory(
          //                             //         cat.items[index].productImage),
          //                           )),
          //                       Container(
          //                         padding: const EdgeInsets.all(6),
          //                         margin: const EdgeInsets.only(left: 45),
          //                         decoration: const BoxDecoration(
          //                             shape: BoxShape.circle,
          //                             color: GREEN_COLOR),
          //                         // child: Text(
          //                         //   products[index]
          //                         //       .tbProduct![0]
          //                         //       .displayQty!
          //                         //       .toInt()
          //                         //       .toString(),
          //                         //   style: getTextStyle(
          //                         //       fontSize: SMALL_FONT_SIZE,
          //                         //       color: WHITE_COLOR),
          //                         // )
          //                       )
          //                     ],
          //                   ))));
          //     }),
        ),
      ],
    );
  }

  _openItemDetailDialog(
      BuildContext context, OrderItem product) async {
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

  getCategoryListWidg() {
//      categories[currentSelectedIndex].isChecked = false;
// currentSelectedIndex = 0;

    return SizedBox(
      height: 80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  isChecked = true;
                  categories[currentSelectedIndex].isChecked = false;
                  currentSelectedIndex = index;
                  categories[index].isChecked = true;
                });
              },
              child: categories.isEmpty
                  ? const Center(
                      child: Text(
                      "No items found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ))
                  : Container(
                      margin: paddingXY(y: 3),
                      width: 150,
                      decoration: BoxDecoration(
                        color: WHITE_COLOR,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: paddingXY(y: 1),
                            margin: const EdgeInsets.only(left: 5),
                            height: 50,
                            alignment: Alignment.center,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: categories[index].isChecked
                                ? BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: WHITE_COLOR,
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))
                                : const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: TABLET_BG_COLOR,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              categories[index].en_name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                fontSize: MEDIUM_FONT_SIZE,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          }),
    );
  }

  Future<void> getCategory() async {
    categories = await DbCategory().getAPICategories();

    // log('Category Size ${categories.length}');

    if (categories.isNotEmpty) {
      categories = categories;

      // categories[0].isChecked = true;

// log('categories  ${categories.length}');
    } else {
      CategoryCommanResponse apiResponse = await CategoryService.getCategory();

      // log(apiResponse.data1.toString());

      // categories.add(new dbcat.APICategory(
      //     id: 0,
      //     en_name: "All",
      //     ar_name: "",
      //     seq_no: 0,
      //     image: "",
      //     main_id_no: 0));

      // for (aiCat.Category c in apiResponse.data1!) {
      //   dbcat.APICategory category = dbcat.APICategory(
      //       id: c.id!,
      //       en_name: c.english!,
      //       ar_name: c.arabic == null ? "" : c.arabic,
      //       seq_no: c.sequenceNo == null ? 0 : c.sequenceNo,
      //       image: c.coverImage == null ? "" : c.coverImage,
      //       main_id_no: c.categoryMainId == null ? 0 : c.categoryMainId);
      //   categories.add(category);
      // }

      // // log('categories  ${categories.length}');

      // //Fetching data from DbProduct database
      // // categories = DbCategory().getAPICategories() as List<dbcat.APICategory>;
      // await DbCategory().addAPICategory(categories);

      categories = await DbCategory().getAPICategories();
    }

    categories[0].isChecked = true;

    setState(() {});
  }

  Future<void> getProducts() async {
//  Helper.showLoaderDialog(context);
    //Fetching data from DbProduct database

    // items = await DbOrderItem().getAllAPIOrders();

    // ignore: unused_local_variable
    // for(var d in await DbProduct().getAllAPiProducts())
    // log(DbProduct().getAllAPiProducts().toString());

    product = await DbProduct().getAllProducts();

    // log('DBProducts ${product.toString()}');

    if (product.isNotEmpty) {
      product = product;
      attributeList.clear();
      for (int i = 0; i < product.length; i++) {
        attributeList.addAll(product[i].attributes);
      }

      //     log('Product Size ${dbproducts.length}');

      // log('DBProducts ${product[3].attributes.toString()}');

//       for (var p in dbproducts) {
// products.add(new aiPro.Product(p.id, p.en_name, p.ar_name, p.seq_no, p.image!, p.tbproduct))

//       }
    } else {
      // ProductCommanResponse apiProResponse = await ProductService.getProducts();

      product = await DbProduct().getAllProducts();
      attributeList.clear();
      for (int i = 0; i < product.length; i++) {
        attributeList.addAll(product[i].attributes);
      }
    }

//     product.sort(((a, b) => a.name.compareTo(b.name)));

    setState(() {});
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
    if (result != null && result.runtimeType == Customer) {
      customer = result;
      debugPrint("Customer selected");
    }
    setState(() {});
  }

  void _filterProductsCategories(String searchTxt) {
    if (searchTxt.isEmpty) {
      categories = categories;
      attributeList = attributeList;
    } else {
      categories = categories
          .where((element) =>
              element.en_name.toLowerCase().contains(searchTxt.toLowerCase()))
          .toList();

      attributeList = attributeList
          .where((element) =>
              element.name!.toLowerCase().contains(searchTxt.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  verify() async {
    CommanResponse res = await VerificationUrl.checkAppStatus();
    if (res.message == true) {
    } else {
      Helper.showPopup(context, "Please update your app to latest version",
          barrierDismissible: true);
    }
  }
}
