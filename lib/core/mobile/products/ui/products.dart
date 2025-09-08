import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';

import '../../../../database/db_utils/db_categories.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_order_item.dart';
import '../../../../database/db_utils/db_product.dart';
import '../../../../database/db_utils/db_sub_categories.dart';
import '../../../../database/models/api_category.dart' as dbcat;
import '../../../../database/models/api_order_item.dart';
import '../../../../database/models/api_sub_category.dart';
import '../../../../database/models/attribute.dart';
import '../../../../database/models/category.dart';
import '../../../../database/models/order_item.dart';
import '../../../../database/models/product.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../utils copy/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/product_shimmer_widget.dart';
import '../../../../widgets/product_widget.dart';
import '../../../../widgets/product_widget2.dart';
import '../../../../widgets/search_widget.dart';
import '../../../service/api_cat_pro/api/cat_pro_api_service.dart';
import '../../create_order_new/ui/widget/category_item.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late TextEditingController searchProductCtrl;
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

  @override
  void initState() {
    super.initState();
    searchProductCtrl = TextEditingController();
    getProducts();
    // ProductsService().getCategoryProduct();
  }

  @override
  void dispose() {
    searchProductCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: categories.isEmpty
              ? const NeverScrollableScrollPhysics()
              : const ScrollPhysics(),
          child: Column(
            children: [
              const CustomAppbar(title: PRODUCTS_TXT,showBackBtn: false,hideSidemenu: true,),
              hightSpacer15,
              Padding(
                padding: horizontalSpace(),
                child: SearchWidget(
                  searchHint: SEARCH_PRODUCT_TXT,
                  searchTextController: searchProductCtrl,
                  onTextChanged: (text) {
                    if (text.isNotEmpty) {
                      debugPrint("entered text1: $text");
                    }
                  },
                  onSubmit: (text) {
                    if (text.isNotEmpty) {
                      debugPrint("entered text2: $text");
                    }
                  },
                ),
              ),
              hightSpacer15,
              isProductGridEnable ? productGrid() : productCategoryList(),
            ],
          ),
        ),
      ),
    );
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
                      categories[position].isChecked =
                      !categories[position].isChecked;
                    });
                  },
                  child: Padding(
                    padding: mediumPaddingAll(),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories[position].en_name,
                              style: categories[position].isChecked
                                  ? getTextStyle(
                                  fontSize: LARGE_FONT_SIZE,
                                  color: DARK_GREY_COLOR,
                                  fontWeight: FontWeight.w500)
                                  : getTextStyle(
                                fontSize: MEDIUM_PLUS_FONT_SIZE,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            categories[position].isChecked
                                ? Container()
                                : Padding(
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
                          categories[position].isChecked
                              ? CATEGORY_OPENED_ICON
                              : CATEGORY_CLOSED_ICON,
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                // Expanded panel for a category
                categories[position].isChecked
                    ? productList(product[position].catmainid)
                    : Container()
              ],
            );
          }
        });
  }

  Widget productList(prodList) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: prodList.isEmpty ? 10 : prodList.length,
        primary: false,
        itemBuilder: (context, position) {
          if (prodList.isEmpty) {
            return const ProductShimmer();
          } else {
            return CategoryItem(
              product: prodList[position],
            );
            // return SalesDetailsItems(
            //   product: prodList[position],
            // );
            // return ListTile(title: Text(prodList[position].name));
          }
        });
  }

  Widget productGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: GridView.builder(
        itemCount: product.isEmpty ? 10 : product.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          childAspectRatio: 0.80,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, position) {
          if (product.isEmpty) {
            return const ProductShimmer();
          } else {
            return ProductWidget2(
              title: product[position].name,
              image_asset: product[position].productImage,
              enableAddProductButton: false,
              product: product[position],
            );
          }
        },
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
}