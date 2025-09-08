// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/cart_screen.dart';
import 'package:nb_posx/core/mobile/finance/ui/finance.dart';
import 'package:nb_posx/core/mobile/my_account/ui/my_account.dart';
import 'package:nb_posx/database/models/api_category.dart';
import 'package:nb_posx/widgets/search_widget.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_categories.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/db_utils/db_product.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../database/models/order_item.dart';
import '../../../../database/models/park_order.dart';
import '../../../../database/models/product.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/item_options.dart';
import '../../../service/login/api/verify_instance_service.dart';
import '../../customers/ui/customers.dart';
import '../../select_customer/ui/new_select_customer.dart';
import '../../transaction_history/view/transaction_screen.dart';

class ProductListHome extends StatefulWidget {
  final bool isForNewOrder;
  final ParkOrder? parkedOrder;
  const ProductListHome(
      {super.key, this.isForNewOrder = false, this.parkedOrder});

  @override
  State<ProductListHome> createState() => _ProductListHomeState();
}

class _ProductListHomeState extends State<ProductListHome> {
  final _key = GlobalKey<ExpandableFabState>();

  final GlobalKey _focusKey = GlobalKey();
  late TextEditingController _searchTxtController;
  List<Product> products = [];
  List<APICategory> categories = [];
  List<Product> product = [];

  late String managerName = '';
  //bool _isFABOpened = false;
  ParkOrder? parkOrder;
  Customer? _selectedCust;
  final _scrollController = ScrollController();

  double _scrollToOffset(int index) {
    // Calculate the scroll offset for the given index
    // You'll need to adjust this based on your actual item heights
    double itemHeight = 250;
    return itemHeight * index;
  }

  void _scrollToIndex(int index) {
    double offset = _scrollToOffset(index);
    _scrollController.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
  }

  // Define the fixed height for an item
  // double _height = 0.0;

  // void _scrollToIndex(index) {
  //   _scrollController.animateTo(_height * index,
  //       duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
  // }

  @override
  void initState() {
    super.initState();
    // verify();
    // _height = MediaQuery.of(context).size.height;
    _searchTxtController = TextEditingController();
    if (widget.parkedOrder != null) {
      parkOrder = widget.parkedOrder;
      _selectedCust = widget.parkedOrder!.customer;
    }
    if (widget.isForNewOrder && _selectedCust == null) {
      Future.delayed(Duration.zero, () => goToSelectCustomer());
    }

    _getManagerName();
    getProducts();
    //throw Exception();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        final state = _key.currentState;
        if (state != null) {
          debugPrint('isOpen:${state.isOpen}');
          if (state.isOpen) {
            state.toggle();
          }
        }
      },
      child: Scaffold(
        // body: ShowCaseWidget(
        //     builder: WidgetBuilder(
        //         builder: ((context) => SingleChildScrollView(
        //             controller: _scrollController,
        //             physics: const BouncingScrollPhysics(),
        //             padding: const EdgeInsets.only(left: 10, right: 10),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 // SizedBox(
        //                 //   height: MediaQuery.of(context).size.height,
        //                 //   width: MediaQuery.of(context).size.width,
        //                 //   child: ModalBarrier(
        //                 //   dismissible: true,
        //                 //   color: _isModalVisible ? Colors.black.withOpacity(0.5) : Colors.transparent,
        //                 // )
        //                 // ),
        //                 hightSpacer30,
        //                 Visibility(
        //                     visible: !widget.isForNewOrder,
        //                     child: Stack(
        //                       //mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         Align(
        //                             alignment: Alignment.center,
        //                             child: Column(
        //                               children: [
        //                                 Text(WELCOME_BACK,
        //                                     style: getTextStyle(
        //                                       fontSize: SMALL_PLUS_FONT_SIZE,
        //                                       color: MAIN_COLOR,
        //                                       fontWeight: FontWeight.w600,
        //                                     )),
        //                                 hightSpacer5,
        //                                 Text(
        //                                   managerName,
        //                                   style: getTextStyle(
        //                                       fontSize: LARGE_FONT_SIZE,
        //                                       color: DARK_GREY_COLOR),
        //                                   overflow: TextOverflow.ellipsis,
        //                                 ),
        //                               ],
        //                             )),
        //                         /*  Align(
        //                             alignment: Alignment.topRight,
        //                             child: Stack(
        //                               children: [
        //                                 Showcase(
        //                                     key: _focusKey,
        //                                     description:
        //                                         'Tap here to create the new order',
        //                                     child: IconButton(
        //                                         onPressed: (() async {
        //                                           await Navigator.push(
        //                                               context,
        //                                               MaterialPageRoute(
        //                                                   builder: (context) =>
        //                                                       const ProductListHome(
        //                                                           isForNewOrder:
        //                                                               true)));
        //                                           setState(() {});
        //                                         }),
        //                                         icon: SvgPicture.asset(
        //                                           NEW_ORDER_ICON,
        //                                           height: 25,
        //                                           width: 25,
        //                                         ))),
        //                               ],
        //                             )),*/
        //                       ],
        //                     )),
        //                 Visibility(
        //                     visible: widget.isForNewOrder,
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         InkWell(
        //                           onTap: () => Navigator.pop(context),
        //                           child: Padding(
        //                             padding: smallPaddingAll(),
        //                             child: SvgPicture.asset(
        //                               BACK_IMAGE,
        //                               color: BLACK_COLOR,
        //                               width: 25,
        //                             ),
        //                           ),
        //                         ),
        //                         Text(
        //                           _selectedCust != null
        //                               ? _selectedCust!.name
        //                               : '',
        //                           style: getTextStyle(
        //                               fontSize: LARGE_FONT_SIZE,
        //                               color: MAIN_COLOR),
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                         Stack(
        //                             alignment: Alignment.topCenter,
        //                             children: [
        //                               IconButton(
        //                                 onPressed: (() async {
        //                                   if (parkOrder != null &&
        //                                       parkOrder!.items.isNotEmpty) {
        //                                     await Navigator.push(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                             builder: (context) =>
        //                                                 CartScreen(
        //                                                     order:
        //                                                         parkOrder!)));
        //                                     setState(() {});
        //                                   } else {
        //                                     Helper.showPopup(
        //                                         context, "Your cart is empty");
        //                                   }
        //                                 }),
        //                                 icon: SvgPicture.asset(
        //                                   CART_ICON,
        //                                   height: 25,
        //                                   width: 25,
        //                                 ),
        //                               ),
        //                               Visibility(
        //                                   visible: parkOrder != null &&
        //                                       parkOrder!.items.isNotEmpty,
        //                                   child: Container(
        //                                       padding: const EdgeInsets.all(6),
        //                                       margin: const EdgeInsets.only(
        //                                           left: 20),
        //                                       decoration: const BoxDecoration(
        //                                           shape: BoxShape.circle,
        //                                           color: MAIN_COLOR),
        //                                       child: Text(
        //                                         parkOrder != null
        //                                             ? parkOrder!.items.length
        //                                                 .toInt()
        //                                                 .toString()
        //                                             : "0",
        //                                         style: getTextStyle(
        //                                             fontSize: SMALL_FONT_SIZE,
        //                                             color: WHITE_COLOR),
        //                                       )))
        //                             ])
        //                       ],
        //                     )),
        //                 hightSpacer15,
        //                 SearchWidget(
        //                   onTap: () {
        //                     final state = _key.currentState;
        //                     if (state != null) {
        //                       debugPrint('isOpen:${state.isOpen}');
        //                       if (state.isOpen) {
        //                         state.toggle();
        //                       }
        //                     }
        //                   },
        //                   searchHint: 'Search product / category',
        //                   searchTextController: _searchTxtController,
        //                   onTextChanged: ((changedtext) {
        //                     final state = _key.currentState;
        //                     if (state != null) {
        //                       debugPrint('isOpen:${state.isOpen}');
        //                       if (state.isOpen) {
        //                         state.toggle();
        //                       }
        //                     }
        //                     if (changedtext.length < 3) {
        //                       getProducts();
        //                       // _filterProductsCategories(changedtext);
        //                     }
        //                   }),
        //                   submit: () {
        //                     if (_searchTxtController.text.length >= 3) {
        //                       _filterProductsCategories(
        //                           _searchTxtController.text);
        //                     } else {
        //                       getProducts();
        //                     }
        //                   },
        //                 ),
        //                 hightSpacer20,
        //                 SizedBox(
        //                     height: 100,
        //                     child: ListView.builder(
        //                         physics: const BouncingScrollPhysics(),
        //                         shrinkWrap: true,
        //                         scrollDirection: Axis.horizontal,
        //                         itemCount: categories.length,
        //                         itemBuilder: (context, position) {
        //                           return GestureDetector(
        //                               onTap: (() {
        //                                 final state = _key.currentState;
        //                                 if (state != null) {
        //                                   debugPrint('isOpen:${state.isOpen}');
        //                                   if (state.isOpen) {
        //                                     state.toggle();
        //                                   }
        //                                 }
        //                                 _scrollToIndex(position);
        //                               }),
        //                               child: Column(
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 children: [
        //                                   Container(
        //                                     margin:
        //                                         const EdgeInsets.only(left: 5),
        //                                     height: 60,
        //                                     clipBehavior:
        //                                         Clip.antiAliasWithSaveLayer,
        //                                     decoration: const BoxDecoration(
        //                                         shape: BoxShape.circle),
        //                                     child:
        //                                     // categories[position]
        //                                     //         .items
        //                                     //         .first
        //                                     //         .productImage
        //                                     //         .isEmpty
        //                                     //     ?
        //                                     Image.asset(
        //                                             PIZZA_IMAGE,
        //                                             fit: BoxFit.fill,
        //                                           )
        //                                     //     :
        //                                     // Image.asset(
        //                                     //         categories[position]
        //                                     //             .items
        //                                     //             .first
        //                                     //             .productImage,
        //                                     //         fit: BoxFit.fill,
        //                                     //       ),
        //                                   ),
        //                                   hightSpacer10,
        //                                   Text(
        //                                     categories[position].en_name,
        //                                     style: getTextStyle(
        //                                         fontWeight: FontWeight.normal,
        //                                         fontSize: SMALL_PLUS_FONT_SIZE),
        //                                   )
        //                                 ],
        //                               ));
        //                         })),
        //                 categories.isEmpty
        //                     ? const Center(
        //                         child: Text(
        //                         "No items found",
        //                         style: TextStyle(fontWeight: FontWeight.bold),
        //                       ))
        //                     : _getCategoryItems(),
        //                 hightSpacer45
        //               ],
        //             ))))),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: Visibility(
            visible: !widget.isForNewOrder,
            child: ExpandableFab(
              key: _key,
              onOpen: (() {
                // setState(() {
                //   _isFABOpened = true;
                // });
              }),
              onClose: (() {
                // setState(() {
                //   _isFABOpened = false;
                // });
              }),
              type: ExpandableFabType.up,
              distance: 80,
              // backgroundColor: LIGHT_BLACK_COLOR,
              // child: SvgPicture.asset(
              //   FAB_MAIN_ICON,
              //   height: 55,
              //   width: 55,
              // ),
              // closeButtonStyle: ExpandableFabCloseButtonStyle(
              //     child: SvgPicture.asset(
              //   FAB_MAIN_ICON,
              //   height: 55,
              //   width: 55,
              // )),
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'finance',
                      onPressed: (() async {
                    
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Finance()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: WHITE_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_FINANCE_ICON,
                            color: BLACK_COLOR,
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Finance',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'account',
                      onPressed: (() async {
                    
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAccount()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: WHITE_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_ACCOUNT_ICON,
                            color: BLACK_COLOR,
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('My Profile',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'transactions',
                      onPressed: (() async {
                   
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionScreen()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: WHITE_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_HISTORY_ICON,
                            color: BLACK_COLOR,
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('History',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'customers',
                      onPressed: (() async {
                     
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Customers()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: WHITE_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_CUSTOMERS_ICON,
                            color: BLACK_COLOR,
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Customer',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 70,
                //   width: 70,
                //   child: FloatingActionButton(
                //       heroTag: 'products',
                //       onPressed: (() {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Products()));
                //       }),
                //       shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       backgroundColor: WHITE_COLOR,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(
                //             FAB_PRODUCTS_ICON,
                //             color: BLACK_COLOR,
                //             height: 25,
                //             width: 25,
                //           ),
                //           hightSpacer5,
                //           Text('Product',
                //               style: getTextStyle(
                //                   fontSize: SMALL_FONT_SIZE,
                //                   fontWeight: FontWeight.normal))
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'create order',
                      onPressed: (() async {
                    
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductListHome(
                                    isForNewOrder: true)));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: WHITE_COLOR,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_ORDERS_ICON,
                            color: BLACK_COLOR,
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Order',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 70,
                //   width: 70,
                //   child: FloatingActionButton(
                //       heroTag: 'home',
                //       onPressed: (() {
                //         _key.currentState!.toggle();
                //       }),
                //       shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       backgroundColor: WHITE_COLOR,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(
                //             FAB_HOME_ICON,
                //             color: BLACK_COLOR,
                //             height: 25,
                //             width: 25,
                //           ),
                //           hightSpacer5,
                //           Text('Home',
                //               style: getTextStyle(
                //                   fontSize: SMALL_FONT_SIZE,
                //                   fontWeight: FontWeight.w600))
                //         ],
                //       )),
                // ),
              ],
            )),
      ),
    ));
  }

  _getCategoryItems() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: categories.length,
        itemBuilder: ((context, catPosition) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hightSpacer20,
              Text(categories[catPosition].en_name,
                  style: getTextStyle(fontSize: LARGE_MINUS_FONT_SIZE)),
              hightSpacer10,
              GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: product.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: ((context, itemPosition) {
                    return GestureDetector(
                        onTap: () {
                          final state = _key.currentState;
                          if (state != null) {
                            debugPrint('isOpen:${state.isOpen}');
                            if (state.isOpen) {
                              state.toggle();
                            }
                          }
                          if (widget.isForNewOrder) {
                            if (product[itemPosition]
                                    .stock >
                                0) {
                              var item = OrderItem.fromJson(
                                  product[itemPosition]
                                      .toJson());
                              log('Selected Item :: $item');
                              _openItemDetailDialog(context, item);
                            } else {
                              Helper.showPopup(
                                  context, 'Sorry, item is not in stock.');
                            }
                          } else {
                            Helper.showPopup(
                                context, "Please select customer first");
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ShowCaseWidget.of(context)
                                  .startShowCase([_focusKey]);
                            });
                            setState(() {
                              _scrollController.jumpTo(0);
                            });
                          }
                        },
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                product[itemPosition]
                                            .stock >
                                        0
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.6),
                                BlendMode.screen),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: paddingXY(x: 5, y: 5),
                                    padding: paddingXY(y: 0, x: 10),
                                    width: 145,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        color: MAIN_COLOR.withOpacity(0.04),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        hightSpacer40,
                                        SizedBox(
                                          //height: 30,
                                          child: Text(
                                            product[itemPosition]
                                                .name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: getTextStyle(
                                                // color: DARK_GREY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: SMALL_PLUS_FONT_SIZE),
                                          ),
                                        ),
                                        hightSpacer4,
                                        Text(
                                          "$appCurrency ${product[itemPosition].price.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
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
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      height: 55,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: product[itemPosition]
                                              .productImage
                                              .isEmpty
                                          ? Image.asset(BURGAR_IMAGE)
                                          : Image.asset(product[itemPosition]
                                              .productImage),
                                    )),
                                Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(left: 45),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: GREEN_COLOR),
                                    child: Text(
                                      product[itemPosition]
                                          .stock
                                          .toInt()
                                          .toString(),
                                      style: getTextStyle(
                                          fontSize: SMALL_FONT_SIZE,
                                          color: WHITE_COLOR),
                                    ))
                              ],
                            )));
                  })),
              hightSpacer30
            ],
          );
        }));
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    // products = await DbProduct().getProducts();
    // categories = Category.getCategories(products);
    categories = await DbCategory().getAPICategories();

    product = await DbProduct().getAllProducts();
    setState(() {});
  }

  void _filterProductsCategories(String searchTxt) {
    categories = categories
        .where((element) =>
                element.en_name.toLowerCase().contains(searchTxt.toLowerCase()))
        .toList();

    setState(() {});
  }

  _getManagerName() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    managerName = manager.name;
    //profilePic = manager.profileImage;
    setState(() {});
  }

  verify() async {
    CommanResponse res = await VerificationUrl.checkAppStatus();
    if (res.message == true) {
      _getManagerName();
      getProducts();
    } else {
      Helper.showPopup(context, "Please update your app to latest version",
          barrierDismissible: true);
    }
  }

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    product.orderedPrice = product.price;
    if (product.orderedQuantity == 0) {
      product.orderedQuantity = 1;
    }
    var res = await showDialog(
        context: context,
        builder: (context) {
          return ItemOptions(orderItem: product);
        });
    if (res == true) {
      if (parkOrder == null) {
        HubManager manager = await DbHubManager().getManager() as HubManager;
        parkOrder = ParkOrder(
            id: _selectedCust!.id,
            date: Helper.getCurrentDate(),
            time: Helper.getCurrentTime(),
            customer: _selectedCust!,
            items: [],
            orderAmount: 0,
            manager: manager,
            transactionDateTime: DateTime.now());
      }

      setState(() {
        if (product.orderedQuantity > 0 &&
            !parkOrder!.items.contains(product)) {
          OrderItem newItem = product;
          parkOrder!.items.add(newItem);
          _calculateOrderAmount();
        } else if (product.orderedQuantity == 0) {
          parkOrder!.items.remove(product);
          _calculateOrderAmount();
        }
      });
      // DbParkedOrder().saveOrder(parkOrder!);
    }
    return res;
  }

  void _calculateOrderAmount() {
    double amount = 0;
    for (var item in parkOrder!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    parkOrder!.orderAmount = amount;
  }

  void goToSelectCustomer() async {
    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewSelectCustomer()));
    if (data != null) {
      getProducts();
      setState(() {
        _selectedCust = data;
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
