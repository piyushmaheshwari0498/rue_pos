import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/cat_pro_api_service.dart';
import 'package:nb_posx/core/service/api_cat_pro/api/product_common_response.dart';
import 'package:nb_posx/core/tablet/create_order/cart_widget%20copy.dart';
import 'package:nb_posx/database/db_utils/db_customer.dart';
import 'package:nb_posx/database/db_utils/db_order_item.dart';
import 'package:nb_posx/database/db_utils/db_product.dart';
import 'package:nb_posx/database/db_utils/db_sub_categories.dart';
import 'package:nb_posx/database/models/api_order_item.dart';
import 'package:nb_posx/database/models/api_sub_category.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/option.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/widgets/item_options2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/models/api_category.dart' as dbcat;
import 'package:nb_posx/core/service/api_cat_pro/model/apicatpromodel.dart'
    as apipro;
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../constants/asset_paths.dart';
import '../../../database/db_utils/db_constants.dart';
import '../../../database/db_utils/db_hub_manager.dart';
import '../../../database/db_utils/db_preferences.dart';
import '../../../database/models/hub_manager.dart';
import '../../../database/models/order_item.dart';
import '../../../main.dart';
import '../../../network/api_constants/api_paths.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../service/api_cashier/api/api_cashier_common.dart';
import '../../service/api_cashier/model/addAndWithdrawCash.dart';
import '../../service/api_sales/model/orderDetailsModel.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/create_customer_popup.dart';
import '../widget/logout_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/title_search_bar.dart';
import 'package:nb_posx/utils%20copy/helper.dart' as cp;

import 'cart_controller.dart';

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

  AddWithdrawCash _addWithdrawCash = AddWithdrawCash();

  // List<aiPro.Product> products = [];
  // List<aiPro.TbProduct> tbproducts = [];
  late List<dbcat.APICategory> categories = [];
  late List<APISUBCategory> subcategories = [];
  late List<APISUBCategory> tempsubcategories = [];

  // List<dbpro.APIProduct> dbproducts = [];

  late List<Product> product = [];
  late List<Product> tempproduct = [];
  late List<Attribute> attributeList = [];

  // List<APIProductAddon> dbproductaddon = [];
  // ParkOrder? parkOrder;
  late List<APIOrderItem> items;

  // late List<OrderItem> orderitems;
  int currentCatSelectedIndex = 0;
  int currentSubCatSelectedIndex = 0;
  int selectedMainCatId = 0;
  int lastselectedMainCatId = 0;
  int selectedSubCatId = 0;

  // int cartSize = 0;
  // double totalCartAmount = 0.0;
  double discountValue = 0.0;
  double discountPer = 0.0;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;
  bool isTax = false;
  late var isChecked;

  bool isCashierLogin = false;
  String _selectedBranch = "";
  String _selectedBranchId = "";
  String _selectedCounter = "";
  String _selectedCounterId = "";
  String _selectedEmployeeId = "";
  String _selectedEmployeeName = "";
  String _selectedTypeId = "";
  bool isSubCatOn = false;

  final CartController cartController = Get.find();

// double _aspectRatio = 0;
  // late aiPro.Product _product =
  //     new aiPro.Product(0, "", "", 0, "", List.empty());

  @override
  void initState() {
    items = [];
    cartController.orderItems.clear();
    cartController.cartSize = 0.obs;
    cartController.totalAmount = 0.0.obs;

    searchCtrl = TextEditingController();
    super.initState();
    // verify();
    // getCategory();
    // Helper.showLoaderDialog(context);
    getProducts();
    _getDetails();
    if (Helper.activeParkedOrder != null) {
      log("park order is active");
      // customer = Helper.activeParkedOrder!.customer;
      // items = Helper.activeAPIParkedOrder!.items;
    }

    // 👇 Add this
    if (cp.Helper.activeTableOrder != null) {
      log("Pre-loading order from table...");
      // Load the order into cart
      _loadOrderFromTable(
          cp.Helper.activeTableOrder!, cp.Helper.activeOrderDtl);
      cp.Helper.activeTableOrder = null; // clear it to prevent reuse
    }
  }

  Future<void> _loadOrderFromTable(OrderDetailsModel orderDetailsModel,
      List<OrderDtl>? activeOrderDtl) async {
    int id;
    for (OrderDtl apiItem in activeOrderDtl ?? []) {
      print("_loadOrderFromTable ${apiItem.toString()}");
      List<Attribute> atrList = [];
      List<Option> listaddonTopping = [];
      for (ToppingModel toppingModel in apiItem.tbDirectOrderTopping!) {
        atrList.add(Attribute(
            id: toppingModel.id!,
            name: toppingModel.name!,
            type: "",
            moq: toppingModel.qty!.toDouble(),
            options: listaddonTopping,
            rate: toppingModel.rate!,
            qty: toppingModel.qty!.toDouble(),
            toppingId: toppingModel.toppingId!));
      }
      OrderItem item = OrderItem(
        id: apiItem.itemId.toString(),
        name: apiItem.description ?? "",
        group: "",
        description: apiItem.description ?? "",
        stock: 0,
        price: apiItem.rate ?? 0.0,
        orderedQuantity: apiItem.qty ?? 1,
        attributes: atrList,
        // Map attributes if needed
        productImage: apiItem.image ?? "",
        productImageUrl: "",
        productUpdatedTime: DateTime.now(),
        tax: apiItem.taxAmount ?? 0.0,
        taxCode: orderDetailsModel.taxBreakDown?[0].taxCode ?? "",
        message: apiItem.variationRemarks!,
      );

      // orderitems.add(item);
      cartController.addItem(item);
      DbOrderItem().addUpdateProducts(item);
    }

    // ✅ Reload from DB to make sure UI reflects it
    // orderitems = await DbOrderItem().getProducts();

    setState(() {
      print("Cart data ${cartController.orderItems.toString()}");
      // cartController.cartSize = cartController.orderItems.length;
      _configureTaxAndTotal(cartController.orderItems);
    });
  }

  Future<void> _getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    HubManager manager = await DbHubManager().getManager() as HubManager;

    DBPreferences dbPreferences = DBPreferences();

    _selectedTypeId = await dbPreferences.getPreference(UserTypeId);
    isCashierLogin =
        await dbPreferences.getPreference(isNewCashierLogin) ?? false;
    // userTypeId = prefs.getInt(UserTypeId)!;
    setState(() {
      isSubCatOn = prefs.getBool(isSubCategory) ?? false;

      // isCashierLogin = true;
      _selectedEmployeeId = manager.id;
      _selectedEmployeeName = manager.name;
      isTax = prefs.getBool(isTaxOn) ?? false;
      _selectedBranch = prefs.getString(BranchName) ?? '';
      _selectedBranchId = prefs.getString(BranchId) ?? '';
      _selectedCounter = prefs.getString(CounterName) ?? '';
      _selectedCounterId = prefs.getString(CounterId) ?? '';

      debugPrint("isNewCashierLogin $isCashierLogin ");
    });
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

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Device.get().isTablet
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "$_selectedEmployeeName\n$_selectedBranch - $_selectedCounter",
                      style: getTextStyle(
                          fontSize: Device.get().isTablet
                              ? LARGE_PLUS_FONT_SIZE
                              : SMALL_FONT_SIZE,
                          color: BLACK_COLOR)))
              : Image(
                  image: AssetImage(APP_ICON_TABLET),
                  color: MAIN_COLOR,
                  height: 80,
                  width: 120,
                  fit: BoxFit.fitWidth,
                ),
          // title: Text('App Bar!'),
          flexibleSpace: Device.get().isTablet
              ? Image(
                  image: AssetImage(APP_ICON_TABLET),
                  color: MAIN_COLOR,
                  fit: BoxFit.fitHeight,
                )
              : Spacer(),
          backgroundColor: Colors.transparent,
          actions: [
            // Badge(
            Visibility(
              visible: MediaQuery.of(context).size.height > 900 &&
                      Device.get().isTablet
                  ? false
                  : true,
              child: Badge(
                  label: Text(
                    cartController.cartSize == 0
                        ? "0"
                        : cartController.cartSize.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SMALL_PLUS_FONT_SIZE),
                  ),

                  // position: const BadgePosition(start: 30, bottom: 30),
                  child: Row(
                    children: [
                      // Container(
                      //   // height: label == null ? effectiveSmallSize : effectiveLargeSize,
                      //   clipBehavior: Clip.antiAlias,
                      //   decoration: ShapeDecoration(
                      //     color: Colors.white60,
                      //     shape: const StadiumBorder(),
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: ),
                      Text(
                        "${cartController.totalAmount.toStringAsFixed(3)} $appCurrency2",
                        style: TextStyle(
                            fontSize: LARGE_FONT_SIZE,
                            color: MAIN_COLOR,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const CartScreen()));
                          showGeneralDialog(
                            context: context,
                            barrierColor: Colors.black54,
                            barrierDismissible: true,
                            barrierLabel: '',
                            pageBuilder: (_, __, ___) {
                              return Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: Device.get().isTablet
                                      ? MediaQuery.of(context).size.width * 0.3
                                      : MediaQuery.of(context).size.width * 0.9,
                                  color: Colors.transparent,
                                  child: CartWidget(
                                    key: ValueKey(
                                        cartController.orderItems.length),
                                    // ✅ Use key to rebuild only when cart changes
                                    customer: customer,
                                    orderList: cartController.orderItems,
                                    onHome: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                      widget.selectedView.value = "Home";
                                      cartController.orderItems.clear();
                                      customer = null;
                                      if (mounted) setState(() {});
                                    },
                                    onPrintReceipt: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                      widget.selectedView.value = "Home";
                                      cartController.orderItems.clear();
                                      customer = null;
                                      if (mounted) setState(() {});
                                    },
                                    onNewOrder: () {
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                      customer = null;
                                      cartController.orderItems.clear();
                                      if (mounted) setState(() {});
                                    },
                                    onCartUpdate: (int i, double totalAmount) {
                                      cartController.cartSize = i.obs;
                                      cartController.totalAmount = 0.0.obs;
                                      cartController.totalAmount =
                                          totalAmount.obs;
                                      // log("onCartUpdate $totalCartAmount");
                                      if (mounted) setState(() {});
                                    },
                                    // onCartUpdate: () async {
                                    //   cartController.orderItems = await DbOrderItem().getProducts();
                                    //   setState(() {
                                    //
                                    //   });
                                    // },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              width: 20.0,
            ),
          ],
        ),
        body: GestureDetector(
            onTap: _handleTap,
            child: Row(
              children: [
                // debugPrint("NewCashierLogin main ${isCashierLogin}");
                // if (isCashierLogin)

                Visibility(
                  visible: false,
                  child: Expanded(
                    flex: 1,
                    child: Container(
                      // color: const Color.fromRGBO(245, 248, 247, 1),
                      color: Colors.white,
                      child: Center(
                        // This ensures the entire content is centered
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // Prevents Column from taking full height
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: MAIN_COLOR,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  showOpeningBalanceDialog(context);
                                },
                                child: Text(
                                  "Start shift",
                                  style: getTextStyle(
                                      color: WHITE_COLOR, fontSize: 23.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: true,
                  child: Expanded(
                    flex: 6,
                    child: SizedBox(
                      // width: isTabletMode
                      //     // ? double.infinity
                      //     ? MediaQuery.of(context).size.width / 1.55
                      //     : MediaQuery.of(context).size.width * 0.9,
                      height: isTabletMode
                          ? !isSubCatOn
                              ? MediaQuery.of(context).size.height * 0.95
                              : MediaQuery.of(context).size.height * 1.90
                          : MediaQuery.of(context).size.height * 0.9,
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                    : _filterProductsCategories(text);
                              } else {
                                getProducts();
                              }
                            },
                            onTextChanged: (changedtext) {
                              if (changedtext.length >= 3) {
                                categories.isEmpty
                                    ? const Center(
                                        child: Text(
                                        "No items found",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                    : _filterProductsCategories(changedtext);
                              } else {
                                getProducts();
                              }
                            },
                            searchCtrl: searchCtrl,
                            searchHint: Device.get().isTablet
                                ? "Search product / category"
                                : "Search Product",
                            searchBoxWidth: Device.get().isTablet
                                ? size.width / 4
                                : size.width / 1.8,
                          ),

                          // hightSpacer15,

                          categories.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No items found",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ))
                              : getCategoryListWidg(),

                          // hightSpacer5,

                          isSubCatOn
                              ? subcategories.isEmpty
                                  ? const Center(
                                      child: Text(
                                      "No items found",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ))
                                  : getSubCategoryListWidg()
                              : Container(),
                          // hightSpacer5,
                          product.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No items found",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                              : getProductItemsWidget(product),
                        ],
                      )),
                    ),
                  ),
                ),

                // if (MediaQuery.of(context).size.height > 900 &&
                //     Device.get().isTablet)
                Expanded(
                  flex: 3,
                  child: SizedBox(
                      // width: isTabletMode
                      //     // ? double.infinity
                      //     ? MediaQuery.of(context).size.width / 1.55
                      //     : MediaQuery.of(context).size.width * 0.9,
                      height: isTabletMode
                          // ? !isSubCatOn
                          // ? MediaQuery.of(context).size.height * 0.95
                          ? MediaQuery.of(context).size.height * 1.90
                          : MediaQuery.of(context).size.height * 0.95,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        color: Colors.transparent,
                        child: CartWidget(
                          key: ValueKey(cartController.orderItems.length),
                          // ✅ Use key to rebuild only when cart changes
                          customer: customer,
                          orderList: cartController.orderItems,
                          onHome: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            widget.selectedView.value = "Home";
                            cartController.orderItems.clear();
                            customer = null;
                            if (mounted) setState(() {});
                          },
                          onPrintReceipt: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            widget.selectedView.value = "Home";
                            cartController.orderItems.clear();
                            customer = null;
                            if (mounted) setState(() {});
                          },
                          onNewOrder: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            customer = null;
                            cartController.orderItems.clear();
                            if (mounted) setState(() {});
                          },
                          onCartUpdate: (int i, double totalAmount) {
                            cartController.cartSize = i.obs;
                            cartController.totalAmount = 0.0.obs;
                            cartController.totalAmount = totalAmount.obs;
                            // log("onCartUpdate $totalCartAmount");
                            if (mounted) setState(() {});
                          },
                          // onCartUpdate: () async {
                          //   cartController.orderItems = await DbOrderItem().getProducts();
                          //   setState(() {
                          //
                          //   });
                          // },
                        ),
                      )),
                ),
              ],
            )));
  }

  getProductItemsWidget(List<Product> tbproduct) {
    // log('getCategoryItemsWidget ${tbproduct}');
    // debugPrint('getProductItemsWidget Height ${MediaQuery.of(context).size.height}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Total Items: ${tbproduct.length}",
            style: getTextStyle(
              fontSize: MEDIUM_FONT_SIZE,
            ),
          ),
        ),
        hightSpacer5,
        SizedBox(
          // height: !isSubCatOn
          //     ? MediaQuery.of(context).size.height * 0.74
          //     : MediaQuery.of(context).size.height * 0.58,
          height: !isSubCatOn
              ? MediaQuery.of(context).size.height * 0.74
              : MediaQuery.of(context).size.height <= 800
                  ? MediaQuery.of(context).size.height * 0.54
                  : MediaQuery.of(context).size.height * 0.70,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
              itemCount: tbproduct.length,
              cacheExtent: 100,
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   crossAxisCount: Helper.checkOrientation(context) ? 4 : 5,
              //   crossAxisSpacing: 10,
              //   childAspectRatio:
              //       Helper.checkOrientation(context) ? 4 / 2 : 7 / 2,
              // ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 10,
              // ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // maxCrossAxisExtent: 250,       // Each item will be at most 250px wide
                // crossAxisCount: Device.get().isTablet
                //     ? MediaQuery.of(context).size.height <= 800
                //         ? 4
                //         : MediaQuery.of(context).size.height > 900
                //             ? 3
                //             : 6
                //     : 2,
                crossAxisCount: 4,
                // Horizontal spacing between grid items
                crossAxisSpacing: Device.get().isTablet ? 15 : 0,
                // Horizontal spacing between grid items
                mainAxisSpacing: Device.get().isTablet ? 0 : 0,
                // Vertical spacing between grid items
                childAspectRatio: Device.get().isTablet
                    ? 4 / 2
                    // : 5 / 2.28, // Adjust this to get the right shape
                    : 4 / 2, // Adjust this to get the right shape
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                      onTap: () {
                        // _handleTap();
                        bool alreadyExists = cartController.orderItems.any(
                            (item) =>
                                int.tryParse(item.id) == tbproduct[index].id);
                        if (alreadyExists) {
                          Helper.showToastInfo("Item already in Cart", context);
                        } else {
                          _addItemToCart(tbproduct, index);
                          setState(
                              () {}); // or notifyListeners() if using provider
                        }
                      },
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.transparent, BlendMode.screen),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for (Product item in tbproduct)
                            itemListWidget(tbproduct[index]),
                          ],
                        ),

                        /* Stack(
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

                                        "$appCurrency ${tbproduct != null ? tbproduct[index].price.toStringAsFixed(2) : 0.0}",
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
                              // )
                            ],
                          )*/
                      )))),
        ),
      ],
    );
  }

  Widget itemListWidget(Product item) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Container(
        // padding: EdgeInsets.only(left: 20, top: 60),
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
            : const EdgeInsets.only(bottom: 8, top: 15),
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
                      child: item.productImage.isEmpty
                          ? Image.asset(
                              'assets/images/rue_no_img.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              "$RUE_IMAGE_BASE_PATH${item.productImage}",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                item.name,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getTextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: BLACK_COLOR,
                                  fontSize: Device.get().isTablet
                                      ? MediaQuery.of(context).size.width * 0.01
                                      : MediaQuery.of(context).size.width *
                                          0.03,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? hightSpacer5
                          : hightSpacer10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "${item.price.toStringAsFixed(2)} $appCurrency2",
                              style: getTextStyle(
                                fontWeight: FontWeight.w500,
                                color: MAIN_COLOR,
                                fontSize: Device.get().isTablet
                                    ? MediaQuery.of(context).size.width * 0.01
                                    : MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _addItemToCart(List<Product> tbproduct, int index) {
    double displayQty = 0;
    double price = 0;
    int? id = 0;
    String? name;
    List<Attribute> atrList = [];

    log("onCLick Index ${index}");

    if (tbproduct[index].attributes.isEmpty) {
      setState(() {
        price = tbproduct[index].price;
        log("onCLick Price ${price}");
        displayQty = tbproduct[index].stock;
        name = tbproduct[index].name;
        id = tbproduct[index].id;
        OrderItem cartorderItem = OrderItem(
            id: id.toString(),
            name: name!,
            group: "",
            description: name!,
            stock: displayQty,
            price: price,
            orderedQuantity: 1,
            attributes: List.empty(),
            productImage: tbproduct[index].productImage,
            productUpdatedTime: DateTime.now(),
            productImageUrl: tbproduct[index].productImage ?? "",
            tax: tbproduct[index].tax ?? 0.0,
            taxCode: tbproduct[index].taxCode ?? "",
            message: "");

        // cartorderItem.price = cartorderItem.price;
        if (cartorderItem.orderedQuantity == 0) {
          cartorderItem.orderedQuantity = 1;
        }

        cartController.orderItems.add(cartorderItem);
        cartController.cartSize = cartController.orderItems.length.obs;
        _configureTaxAndTotal(cartController.orderItems);
        // DbOrderItem().deleteProducts();
        DbOrderItem().addUpdateProducts(cartorderItem);
        Helper.showToastSuccess("Item added to Cart", context);
      });
    } else {
      if (tbproduct[index].attributes.isNotEmpty) {
        atrList = tbproduct[index].attributes;
      }

      for (int i = 0; i < tbproduct.length; i++) {
        id = tbproduct[index].id;
        displayQty = tbproduct[index].stock;
        price = tbproduct[index].price;
        name = tbproduct[index].name;
      }

      // if (displayQty > 0.0) {
      List<Attribute> listattr = [];
      List<Option> listaddonTopping = [];

      if (atrList.isNotEmpty) {
        for (int i = 0; i < atrList.length; i++) {
          listattr.add(Attribute(
              id: atrList[i].id,
              name: atrList[i].name,
              type: "",
              moq: 0,
              qty: 0,
              toppingId: atrList[i].toppingId,
              options: listaddonTopping,
              rate: atrList[i].rate));
        }
      }

      OrderItem orderItem = OrderItem(
          id: id.toString(),
          name: name!,
          group: "",
          description: name!,
          stock: displayQty,
          price: price,
          orderedQuantity: 1,
          attributes: listattr,
          productImage: tbproduct[index].productImage,
          productUpdatedTime: DateTime.now(),
          productImageUrl: tbproduct[index].productImage ?? "",
          taxCode: tbproduct[index].taxCode ?? "",
          message: "",
          tax: tbproduct[index].tax ?? 0.0);

      _openItemDetailDialog(context, orderItem);
      // } else {
      //   Helper.showPopup(context, 'Sorry, item is not in stock.');
      // }
    }

    if (cartController.orderItems.isEmpty) {
      customer = null;
    }
    // customer = customer ?? null;
  }

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    // product.price = product.price;
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
      cartController.orderItems.add(product);
      cartController.cartSize = cartController.orderItems.length.obs;
      // DbOrderItem().deleteProducts();
      _configureTaxAndTotal(cartController.orderItems);
      Helper.showToastSuccess("Item added to Cart", context);
      DbOrderItem().addUpdateProducts(product);
    }
    setState(() {});
  }

  getCategoryListWidg() {
//      categories[currentSelectedIndex].isChecked = false;
// currentSelectedIndex = 0;

    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  isChecked = true;
                  categories[currentCatSelectedIndex].isChecked = false;
                  currentCatSelectedIndex = index;
                  categories[index].isChecked = true;
                  selectedMainCatId = categories[index].id;

                  subcategories = tempsubcategories;

                  if (selectedMainCatId != 0) {
                    product = tempproduct;
                    log('cate Id $selectedMainCatId');
                    for (int i = 0; i < subcategories.length; i++) {
                      subcategories[i].isChecked = false;
                    }

                    subcategories = subcategories
                        .where((element) =>
                            element.main_id_no == selectedMainCatId)
                        .toList();

                    if (selectedSubCatId != 0) {
                      if (lastselectedMainCatId == selectedMainCatId) {
                        product = product
                            .where((element) =>
                                element.catmainid == selectedMainCatId &&
                                element.subcatid == selectedSubCatId)
                            .toList();
                      } else {
                        product = product
                            .where((element) =>
                                element.catmainid == selectedMainCatId)
                            .toList();
                      }
                    } else {
                      selectedSubCatId = 0;
                      // log('Sorted Product ${product.toString()}');
                      product = product
                          .where((element) =>
                              element.catmainid == selectedMainCatId)
                          .toList();
                    }
                  } else {
                    if (index == 0) {
                      // log('SUbIn $currentCatSelectedIndex');
                      for (int i = 0; i < subcategories.length; i++) {
                        subcategories[i].isChecked = false;
                      }

                      product = tempproduct;
                      selectedSubCatId = 0;
                      selectedMainCatId = 0;
                      currentSubCatSelectedIndex = index;
                      subcategories[index].isChecked = true;
                    }
                  }
                  lastselectedMainCatId = selectedMainCatId;
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
                      // width: 150,
                      width: Device.get().isTablet ? 150 : 150,
                      // decoration: BoxDecoration(
                      //   color: WHITE_COLOR,
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)))
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
                                fontSize: Device.get().isTablet
                                    ? MEDIUM_PLUS_FONT_SIZE
                                    : MEDIUM_MINUS_FONT_SIZE,
                                fontWeight: FontWeight.w600,
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

  getSubCategoryListWidg() {
//      categories[currentSelectedIndex].isChecked = false;
// currentSelectedIndex = 0;

    return SizedBox(
      height: 80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: subcategories.length,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  isChecked = true;
                  // log('SUbIndex $currentCatSelectedIndex');
                  subcategories[currentSubCatSelectedIndex].isChecked = false;
                  currentSubCatSelectedIndex = index;
                  subcategories[index].isChecked = true;
                  selectedSubCatId = subcategories[index].id;

                  product = tempproduct;
                  // log('subcate Id $selectedSubCatId');
                  if (selectedMainCatId != 0 && selectedSubCatId != 0) {
                    product = product
                        .where((element) =>
                            element.catmainid == selectedMainCatId &&
                            element.subcatid == selectedSubCatId)
                        .toList();
                  } else if (selectedSubCatId != 0) {
                    product = product
                        .where(
                            (element) => element.subcatid == selectedSubCatId)
                        .toList();
                  } else {
                    selectedSubCatId = 0;
                    product = tempproduct;
                  }
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
                      width: Device.get().isTablet ? 150 : 150,
                      // decoration: BoxDecoration(
                      //   color: WHITE_COLOR,
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
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
                            decoration: subcategories[index].isChecked
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
                              subcategories[index].en_name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                fontSize: Device.get().isTablet
                                    ? MEDIUM_PLUS_FONT_SIZE
                                    : MEDIUM_MINUS_FONT_SIZE,
                                fontWeight: FontWeight.w600,
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

  Future<void> getProducts() async {
    try {
      product = await DbProduct().getAllProducts();
      // int size = await DbProduct().getProductsSize();
      // List<Customer> customerList = await DbCustomer().getOfflineCustomers();

      categories = await DbCategory().getAPICategories();

      subcategories = await DbSubCategory().getAPISUBCategories();

      await DbOrderItem().deleteProducts();

      // orderitems = await DbOrderItem().getProducts();

      // log('DBCustomers ${customerList.toString()}');

      // log('DBProducts size ${size.toString()}');

      var isInternetAvailable = await Helper.isNetworkAvailable();
      // checkInternetStatus();
      // debugPrint('isInternetAvailable: $isInternetAvailable');
      // debugPrint('isInternetAvailable: ${categories.toString()}');
      // debugPrint('isInternetAvailable: ${subcategories.toString()}');

      if (isInternetAvailable &&
          product.isNotEmpty &&
          categories.isNotEmpty &&
          subcategories.isNotEmpty) {
        product = product;
        tempproduct = product;

        attributeList.clear();
        for (int i = 0; i < product.length; i++) {
          for (int j = 0; j < product[i].attributes.length; j++) {
            attributeList.add(product[i].attributes[j]);
          }
        }
        categories = categories;
        subcategories = subcategories;
        tempsubcategories = subcategories;
        categories[0].isChecked = true;
        selectedMainCatId = 0;
        selectedSubCatId = 0;
        subcategories[0].isChecked = true;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _selectedBranchId = prefs.getString(BranchId) ?? '';
        await CatProductService.getProducts("1");

        product = await DbProduct().getAllProducts();
        categories = await DbCategory().getAPICategories();
        subcategories = await DbSubCategory().getAPISUBCategories();
        tempsubcategories = subcategories;
        tempproduct = product;
        categories[0].isChecked = true;
        subcategories[0].isChecked = true;
        selectedMainCatId = 0;
        selectedSubCatId = 0;

        attributeList.clear();
        for (int i = 0; i < product.length; i++) {
          for (int j = 0; j < product[i].attributes.length; j++) {
            attributeList.add(product[i].attributes[j]);
          }
        }

        // if (commanResponse.data1!.isNotEmpty) {
        //   // for (var productData in data) {
        //   // final Uint8List empty = Uint8List(1);
        //   List<apipro.Product> data = commanResponse.data1!;
        //   List<Option> listaddonTopping = [];
        //   List<Attribute> proaddon = [];
        //   for (int p = 0; p < data.length; p++) {
        //     for (int j = 0; j < data[p].tbProductTopping!.length; j++) {
        //       // listaddonTopping.add(Option(
        //       //     id: data[p].tbProductTopping![j].id.toString(),
        //       //     name: data[p].tbProductTopping![j].name ?? "",
        //       //     price: data[p].tbProductTopping![j].rate ?? 0,
        //       //     selected: false,
        //       //     tax: data[p].taxPercentage ?? 0));
        //
        //       proaddon.add(Attribute(
        //           id: data[p].tbProductTopping![j].id ?? 0,
        //           name: data[p].tbProductTopping![j].name ?? "",
        //           type: "Multiselect",
        //           moq: 0,
        //           options: listaddonTopping,
        //           rate:  data[p].tbProductTopping![j].rate ?? 0));
        //     }
        //
        //     Product orderItem = Product(
        //       id: data[p].id ?? 0,
        //       name: data[p].headEnglish ?? "",
        //       group: "",
        //       description: "",
        //       stock: data[p].qty ?? 0,
        //       price: data[p].rate ?? 0,
        //       attributes: proaddon,
        //       productImage: "",
        //       productUpdatedTime: DateTime.now(),
        //       tax: 0,
        //       catmainid: data[p].categoryMainId ?? 0,
        //       subcatid: data[p].categoryId ?? 0,
        //     );
        //     // var item = OrderItem.fromJson(products[index].toString());
        //     attributeList.addAll(proaddon);
        //     product.add(orderItem);
        //   }

        // await DbProduct().addProducts(product);

        // products = apiProResponse.data1!;

        // product = await DbProduct().getAllProducts();
        // }
      }
    } catch (e) {
      if (kDebugMode) {
        print('***** Exception Caught1 ***** $e');
      }
      Helper.showSnackBar(context, e.toString());
      if (e is Exception) {
        if (kDebugMode) {
          print('***** Exception Caught2 ***** ${e.toString()}');
        }
      }
    }

    // ignore: use_build_context_synchronously

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
      // categories = categories;
      // subcategories = subcategories;

      product = tempproduct;
    } else {
      // categories = categories
      //     .where((element) =>
      //         element.en_name.toLowerCase().contains(searchTxt.toLowerCase()))
      //     .toList();
      //
      // subcategories = subcategories
      //     .where((element) =>
      //         element.en_name.toLowerCase().contains(searchTxt.toLowerCase()))
      //     .toList();

      product = product
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

  _configureTaxAndTotal(List<OrderItem> items) {
    cartController.totalAmount = 0.0.obs;
    subTotalAmount = 0.0;
    taxAmount = 0.0;
    totalItems = 0;
    taxPercentage = 0;
    for (OrderItem item in items) {
      //taxPercentage = taxPercentage + (item.tax * item.orderedQuantity);
      // log('Tax Percentage after adding ${item.name} :: $taxPercentage');
      // log("${item.price} ${item.orderedQuantity}$subTotalAmount");
      taxPercentage += item.tax!;
      subTotalAmount = subTotalAmount + (item.price * item.orderedQuantity);

      // taxAmount += (subTotalAmount * taxPercentage) / 100;
      taxAmount = _calculateVatProduct(item.price,item.tax,taxAmount,item.orderedQuantity) - discountValue;

      // log('SubTotal after adding ${item.name} :: $subTotalAmount');
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          //taxPercentage = taxPercentage + attribute.tax;
          // log('Tax Percentage after adding ${attribute.name} :: $taxPercentage');
          // if (attribute.options.isNotEmpty) {
          //   for (var options in attribute.options) {
          if (attribute.qty != 0) {
            //taxPercentage = taxPercentage + options.tax;
            subTotalAmount = subTotalAmount + attribute.rate * attribute.qty;
            // log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
          }
        }
        // }
        // }
      }
    }
    //taxAmount = (subTotalAmount / 100) * taxPercentage;
    if (!isTax) {
      subTotalAmount = subTotalAmount - taxAmount;
      // log("_itemTotal ${taxAmount}");
      // total = total - taxAmount;
    }

    subTotalAmount =  subTotalAmount - discountValue;

    cartController.totalAmount =
        (subTotalAmount + taxAmount).obs;
    // log('Subtotal :: $subTotalAmount');
    // log('Tax percentage :: $taxAmount');
    // log('Tax Amount :: $taxAmount');
    // log('totalCartAmount :: $totalCartAmount');
    //return taxPercentage;
    setState(() {});
  }

  double _calculateVatProduct(double price,double taxPer,double taxAmount,double qty){
    double num1 = 100 + taxPer;

    return (taxAmount+((price*qty))*taxPer/num1);
  }

  Future<AddWithdrawCash> startDay(String amount, String remark) async {
    return CashierApiService().startDay(
      amount: amount,
      branchId: _selectedBranchId,
      userId: _selectedEmployeeId,
      counterId: _selectedCounterId,
      remarks: remark,
    );
  }

  void showOpeningBalanceDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController remarksController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.3, // 30% of screen width
            // height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Opening Balance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "Please Enter Amount",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Amount",
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Remarks",
                  ),
                ),
                // Spacer(), // Pushes buttons to the bottom
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      // Handle "Start Sales" action
                      _addWithdrawCash = await startDay(
                          amountController.text, remarksController.text);

                      if (_addWithdrawCash.status == 1 &&
                          _addWithdrawCash.result == "Success") {
                        setState(() async {
                          DBPreferences dbPreferences = DBPreferences();
                          await dbPreferences.savePreference(
                              isNewCashierLogin, false);
                        });

                        CupertinoAlertDialog(
                          content: Text(_addWithdrawCash.message!),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              content: Text(_addWithdrawCash.message!),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          },
                        );
                      }
                    },
                    // style: ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
                    // ),
                    child: Text(
                      "Start Sales",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
