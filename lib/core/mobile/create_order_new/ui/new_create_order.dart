import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/database/models/api_category.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/item_options.dart';
import '../../../../../widgets/product_shimmer_widget.dart';
import '../../../../../widgets/search_widget.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_order_item.dart';
import '../../../../database/db_utils/db_product.dart';
import '../../../../database/db_utils/db_sub_categories.dart';
import '../../../../database/models/api_category.dart' as dbcat;
import '../../../../database/models/api_order_item.dart';
import '../../../../database/models/api_sub_category.dart';
import '../../../../database/models/attribute.dart';
import '../../../service/api_cat_pro/api/cat_pro_api_service.dart';
import '../../select_customer/ui/new_select_customer.dart';
import 'cart_screen.dart';
import 'widget/category_item.dart';

// ignore: must_be_immutable
class NewCreateOrder extends StatefulWidget {
  ParkOrder? order;

  NewCreateOrder({Key? key, this.order}) : super(key: key);

  @override
  State<NewCreateOrder> createState() => _NewCreateOrderState();
}

class _NewCreateOrderState extends State<NewCreateOrder> {
  late TextEditingController searchProductCtrl;


  ParkOrder? parkOrder;

  bool isProductGridEnable = true;

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
  late List<OrderItem> orderitems;
  // List<Product> cartProducts = [];

  @override
  void initState() {
    super.initState();
    searchProductCtrl = TextEditingController();
    // if (widget.order != null) {
      // _selectedCust = widget.order!.customer;
      // parkOrder = widget.order!;
      // _calculateOrderAmount();
      getProducts();
    // }
    // if (_selectedCust == null) {
    //   Future.delayed(Duration.zero, () => goToSelectCustomer());
    // }
  }

  @override
  void dispose() {
    searchProductCtrl.dispose();
    super.dispose();
  }

  Widget get searchBarSection => Padding(
      padding: mediumPaddingAll(),
      child: SearchWidget(
        searchHint: SEARCH_PRODUCT_HINT_TXT,
        searchTextController: searchProductCtrl,
        onTextChanged: (text) {
          // log('Changed text :: $text');
          // if (text.isNotEmpty) {
          //   filterCustomerData(text);
          // } else {
          //   getCustomersFromDB();
          // }
        },
        onSubmit: (text) {
          // if (text.isNotEmpty) {
          //   filterCustomerData(text);
          // } else {
          //   getCustomersFromDB();
          // }
        },
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                const CustomAppbar(
                  title: "Create Order",
                  hideSidemenu: true,
                  showBackBtn: false,
                ),
                // selectedCustomerSection,
                searchBarSection,
                productList()
              ],
            )),
            parkOrder == null
                ? Container()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: morePaddingAll(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MAIN_COLOR,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(order: parkOrder!)));
                        },
                        title: Text(
                          "${parkOrder!.items.length} Item",
                          style: getTextStyle(
                              fontSize: SMALL_FONT_SIZE,
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.normal),
                        ),
                        subtitle: Text("$appCurrency ${_getItemTotal()}",
                            style: getTextStyle(
                                fontSize: LARGE_FONT_SIZE,
                                fontWeight: FontWeight.w600,
                                color: WHITE_COLOR)),
                        trailing: Text("View Cart",
                            style: getTextStyle(
                                fontSize: LARGE_FONT_SIZE,
                                fontWeight: FontWeight.w400,
                                color: WHITE_COLOR)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getProducts() async {
    // //Fetching data from DbProduct database
    // // products = await DbProduct().getProducts();
    // // categories = Category.getCategories(products);
    // categories = await DbCategory().getCategories();
    // setState(() {});
    try {
      product = await DbProduct().getAllProducts();
      // int size = await DbProduct().getProductsSize();
      // List<Customer> customerList = await DbCustomer().getOfflineCustomers();

      categories = await DbCategory().getAPICategories();

      subcategories = await DbSubCategory().getAPISUBCategories();

      await DbOrderItem().deleteProducts();

      orderitems = await DbOrderItem().getProducts();

      // log('DBCustomers ${customerList.toString()}');

      // log('DBProducts size ${size.toString()}');

      var isInternetAvailable = await Helper.isNetworkAvailable();
      // checkInternetStatus();
      // debugPrint('isInternetAvailable: $isInternetAvailable');
      // debugPrint('isInternetAvailable: ${categories.toString()}');
      // debugPrint('isInternetAvailable: ${subcategories.toString()}');

      if (!isInternetAvailable &&
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
        // selectedMainCatId = 0;
        // selectedSubCatId = 0;
        subcategories[0].isChecked = true;
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String _selectedBranchId = prefs.getString(BranchId) ?? '1';
        await CatProductService.getProducts(_selectedBranchId);

        product = await DbProduct().getAllProducts();
        categories = await DbCategory().getAPICategories();
        subcategories = await DbSubCategory().getAPISUBCategories();
        tempsubcategories = subcategories;
        tempproduct = product;
        categories[0].isChecked = true;
        subcategories[0].isChecked = true;
        // selectedMainCatId = 0;
        // selectedSubCatId = 0;
        // print('***** Data ***** ${product.toString()}');
        attributeList.clear();
        for (int i = 0; i < product.length; i++) {
          for (int j = 0; j < product[i].attributes.length; j++) {
            attributeList.add(product[i].attributes[j]);
          }
        }

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

  Widget productCategoryList() {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
        shrinkWrap: true,
        itemCount: categories.isEmpty ? 10 : categories.length,
        primary: false,
        itemBuilder: (context, position) {
          if (categories.isEmpty) {
            return const ProductShimmer();
          } else {
            return Column(
              children: [
                // category tile for product
                InkWell(
                  onTap: () {
                    setState(() {
                      // categories[position].isExpanded =
                      //     !categories[position].isExpanded;
                    });
                  },
                  child: Padding(
                    padding: mediumPaddingAll(),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(categories[position].en_name,
                                style:
                                    // categories[position].isExpanded
                                    //     ?
                                    getTextStyle(
                                        fontSize: LARGE_FONT_SIZE,
                                        color: DARK_GREY_COLOR,
                                        fontWeight: FontWeight.w500)
                                // : getTextStyle(
                                //     fontSize: MEDIUM_PLUS_FONT_SIZE,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                ),
                            // categories[position].isExpanded
                            //     ?
                            // Container()
                            // :
                            Padding(
                              padding: verticalSpace(x: 5),
                              child: Text(
                                "${categories.length} items",
                                style: getTextStyle(
                                    color: MAIN_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: SMALL_PLUS_FONT_SIZE),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          // categories[position].isExpanded
                          //     ?
                          CATEGORY_OPENED_ICON,
                          // : CATEGORY_CLOSED_ICON,
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded panel for a category
                // categories[position].isExpanded
                //     ?
                productList(),
                // : Container()
              ],
            );
          }
        });
  }

  Widget productList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: product.isEmpty ? 10 : product.length,
        primary: false,
        itemBuilder: (context, position) {
          if (product.isEmpty) {
            return const ProductShimmer();
          } else {
            return InkWell(
              onTap: () {
                // product[position].productUpdatedTime = DateTime.timestamp() as DateTime;
                var item = OrderItem.fromJson(product[position].toJson());
                print("Item click ${item.toString()}");
                _openItemDetailDialog(context, item);
              },
              child: CategoryItem(
                product: product[position],
              ),
            );
          }
        });
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
            id: "1",
            date: Helper.getCurrentDate(),
            time: Helper.getCurrentTime(),
            customer: Customer(id: "1", name: "Walk-in", email: "email", phone: "phone", isSynced: true, modifiedDateTime: DateTime.now()),
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
      DbParkedOrder().saveOrder(parkOrder!);
    }
    return res;
  }

  double _getItemTotal() {
    double total = 0;
    for (OrderItem item in parkOrder!.items) {
      total = total + (item.orderedPrice * item.orderedQuantity);
    }
    return total;
  }

  void _calculateOrderAmount() {
    double amount = 0;
    for (var item in parkOrder!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    parkOrder!.orderAmount = amount;
  }
}
