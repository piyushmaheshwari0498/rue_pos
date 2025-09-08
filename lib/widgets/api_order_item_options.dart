import 'package:flutter/material.dart';
import 'package:nb_posx/core/mobile/add_products/ui/tablet_api_added_product_item.dart';
import 'package:nb_posx/database/models/api_order_item.dart';
import 'package:nb_posx/database/models/api_product_addon.dart';
import 'package:nb_posx/database/models/api_product_addon_topping.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../core/mobile/add_products/ui/added_product_item.dart';
import '../database/models/attribute.dart';
import '../database/models/option.dart';
import '../database/models/order_item.dart';
import '../main.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/spacer_widget.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class APIItemOptions extends StatefulWidget {
  APIOrderItem orderItem;
  APIItemOptions({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<APIItemOptions> createState() => _ItemOptionsState();
}

class _ItemOptionsState extends State<APIItemOptions> {
  double itemTotal = 0;
  int qty = 0;
  _calculateItemPrice() {
    itemTotal = widget.orderItem.price;
    APIOrderItem item = widget.orderItem;
    if (widget.orderItem.attributes.isNotEmpty) {
      for (var attribute in item.attributes) {
        for (var option in attribute.tbProductTopping) {
          if (option.selected) {
            itemTotal = (itemTotal + option.price);
          }
        }
      }
      itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    } else {
      itemTotal = item.price * widget.orderItem.orderedQuantity;
    }

    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateItemPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          //height: MediaQuery.of(context).size.height * 0.8,
          width: isTabletMode
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          padding: morePaddingAll(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  TABAPiAddedProductItem(
                    product: widget.orderItem,
                    onDelete: () {},
                    disableDeleteOption: true,
                    isUsedinVariantsPopup: true,
                    onItemAdd: () {
                      debugPrint("Stock count: ${widget.orderItem.stock}");
                      setState(() {
                        if (widget.orderItem.orderedQuantity <
                                widget.orderItem.stock ||
                            widget.orderItem.stock == 0) {
                          widget.orderItem.orderedQuantity =
                              widget.orderItem.orderedQuantity + 1;
                          _calculateItemPrice();
                          // _selectedCustomerSection();
                        }
                      });
                    },
                    onItemRemove: () {
                      setState(() {
                        if (widget.orderItem.orderedQuantity > 1) {
                          widget.orderItem.orderedQuantity =
                              widget.orderItem.orderedQuantity - 1;
                          _calculateItemPrice();
                        }
                      });
                    },
                  ),
                  hightSpacer30,
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      primary: false,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return _optionSection(
                            widget.orderItem.attributes[index]);
                      },
                    ),
                  ),
                ],
              )),
                hightSpacer10,
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: GREEN_COLOR,
                  ),
                  child: ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    title: Text(
                      "Item Total",
                      style: getTextStyle(
                          fontSize: MEDIUM_FONT_SIZE,
                          color: WHITE_COLOR,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "$appCurrency ${itemTotal.toStringAsFixed(2)}",
                        style: getTextStyle(
                            fontSize: LARGE_FONT_SIZE,
                            fontWeight: FontWeight.w600,
                            color: WHITE_COLOR)),
                    trailing: Text("Add Item",
                        style: getTextStyle(
                            fontSize: LARGE_FONT_SIZE,
                            fontWeight: FontWeight.bold,
                            color: WHITE_COLOR)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _optionsItems(APIProductAddon attribute, int index) {
    ApiProductToppingOption option = attribute.tbProductTopping[index];
    return InkWell(
      onTap: () => _handleOptionSelection(attribute, index),
      child: Padding(
        padding: verticalSpace(x: 5),
        child: Row(
          children: [
            option.selected
                ? 
                Visibility(
                    visible: true,
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(color: MAIN_COLOR),
                          // border: Border.all(color: Colors.yellow.shade800),
                          color: MAIN_COLOR,
                          // color: Colors.yellow.shade800,
                          borderRadius:
                              BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 18.0,
                          color: WHITE_COLOR,
                        )),
                  )
                : 
                Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(color: BLACK_COLOR),
                      borderRadius:
                          BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
                    ),
                    child: const Icon(
                      null,
                      size: 20.0,
                    ),
                  ),
            widthSpacer(5),
            Text(
              option.name,
              style: getTextStyle(
                  fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
            ),
            const Spacer(),
            Text(
              "$appCurrency ${option.price.toStringAsFixed(2)}",
              style: getTextStyle(
                  fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  _optionSection(APIProductAddon attribute) {
    return Padding(
      padding: isTabletMode ? horizontalSpace() : horizontalSpace(x: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(
          //   attribute.headEnglish,
          //   style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1.5,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: verticalSpace(),
              itemCount: attribute.tbProductTopping.length,
              itemBuilder: (context, index) {
                return _optionsItems(attribute, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  _handleOptionSelection(APIProductAddon attribute, int index) {
    ApiProductToppingOption option = attribute.tbProductTopping[index];
    debugPrint("index: $index");
    // if (attribute.type == "Multiselect") {
    //   debugPrint("Checkbox type functionality");
    //   if (attribute.displayQty > 0) {
    //     //TODO::: Do work here
    //     debugPrint(
    //         "check to see that atleast ${attribute.displayQty} options are selected");
    //   } else {
    //     setState(() {
    //       option.selected = !option.selected;
    //       if (option.selected) {
    //         double optionsTotal =
    //             option.price * widget.orderItem.orderedQuantity;
    //         itemTotal = itemTotal + optionsTotal;
    //         itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    //       } else {
    //         double optionsTotal =
    //             option.price * widget.orderItem.orderedQuantity;
    //         itemTotal = itemTotal - optionsTotal;
    //         // itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    //       }
    //     });
    //   }
    // } else {
      debugPrint("Radio button type functionality");
      for (var i = 0; i < attribute.tbProductTopping.length; i++) {
        var opt = attribute.tbProductTopping[i];

        if (i == index) {
          // if (!opt.selected) {
            // opt.selected = true;
            widget.orderItem.orderedPrice =
                widget.orderItem.orderedPrice + opt.price;
          // }
        } else {
          // if (opt.selected) {
            // opt.selected = false;
            widget.orderItem.orderedPrice =
                widget.orderItem.orderedPrice - opt.price;
          // }
        }
      // }
      setState(() {});
    }
  }
}
