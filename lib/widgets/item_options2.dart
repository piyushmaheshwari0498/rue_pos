import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:nb_posx/core/mobile/add_products/ui/added_attribute_item.dart';

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
class ItemOptions2 extends StatefulWidget {
  OrderItem orderItem;

  // Attribute attribute;
  ItemOptions2({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<ItemOptions2> createState() => _ItemOptionsState();
}

class _ItemOptionsState extends State<ItemOptions2> {
  double itemTotal = 0;

  late List<Attribute> attributeList = [];

  // late List<Option> optionList = [];
  int qty = 0;

  _calculateItemPrice() {
    itemTotal = widget.orderItem.price;
    OrderItem item = widget.orderItem;

    if (widget.orderItem.attributes.isNotEmpty) {
      for (var attribute in item.attributes) {
        // for (var option in attribute.options) {
          if (attribute.qty != 0) {
        //     itemTotal = (itemTotal + option.price);
        // }else{
        itemTotal = itemTotal + attribute.rate * attribute.qty;
        }
        // }
      }
      itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    } else {
      itemTotal = item.price * widget.orderItem.orderedQuantity;
    }
  }

  @override
  void initState() {
    super.initState();
    attributeList.addAll(widget.orderItem.attributes);
    // for(int i=0;i<widget.orderItem.attributes.length;i++){
    //
    //   for(int j=0;j<widget.orderItem.attributes[i].options.length;i++){
    //     optionList.add(widget.orderItem.attributes[i].options[j]);
    //   }
    // }

    _calculateItemPrice();
  }

  @override
  Widget build(BuildContext context) {
   /* return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          // height: defaultTargetPlatform == TargetPlatform.iOS ?
          height:
          // MediaQuery.of(context).size.height * 0.80 : MediaQuery.of(context).size.height * 0.75,
          MediaQuery.of(context).size.height * 0.9,
          // isTabletMode
          //     ? MediaQuery.of(context).size.height *
          //     : MediaQuery.of(context).size.height * 0.9,
          width: isTabletMode
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          padding: morePaddingAll(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  AddedProductItem(
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

                          for(int i=0;i<attributeList.length;i++){
                            if(attributeList[i].qty != 0){
                              attributeList[i].qty =
                                  attributeList[i].moq * widget.orderItem.orderedQuantity;

                              // attributeList[i].moq = attributeList[i].qty;

                              attributeList[attributeList.indexWhere(
                                      (element) => element.id == attributeList[i].id)] = attributeList[i];
                            }
                          }

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

                          for(int i=0;i<attributeList.length;i++){
                            if(attributeList[i].qty != 0){
                              attributeList[i].qty =
                                  attributeList[i].moq * widget.orderItem.orderedQuantity;

                              // attributeList[i].moq = attributeList[i].qty;

                              attributeList[attributeList.indexWhere(
                                      (element) => element.id == attributeList[i].id)] = attributeList[i];
                            }
                          }

                          _calculateItemPrice();
                        }
                      });
                    },
                  ),
                  hightSpacer10,
                  SizedBox(
                    height: 380,
                    child: attributeList.isNotEmpty ? _optionSection() : null,
                  ),
                  //   ListView.builder(
                  //     primary: true,
                  //     itemCount: 1,
                  //     itemBuilder: (context, index) {
                  //       return attributeList.isNotEmpty
                  //           ? _optionSection()
                  //           : null;
                  //     },
                  //   ),
                  // ),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MAIN_COLOR,
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
                        "${itemTotal.toStringAsFixed(2)} $appCurrency2",
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
    );*/

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height / 1.1,
          width: isTabletMode
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width * 0.9,
          padding: morePaddingAll(),
          child: Column(
            children: [
              // This makes the list scroll properly and take available space
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AddedProductItem(
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
                              widget.orderItem.orderedQuantity += 1;

                              for (int i = 0; i < attributeList.length; i++) {
                                if (attributeList[i].qty != 0) {
                                  attributeList[i].qty =
                                      attributeList[i].moq * widget.orderItem.orderedQuantity;

                                  attributeList[attributeList.indexWhere(
                                          (element) => element.id == attributeList[i].id)] = attributeList[i];
                                }
                              }

                              _calculateItemPrice();
                            }
                          });
                        },
                        onItemRemove: () {
                          setState(() {
                            if (widget.orderItem.orderedQuantity > 1) {
                              widget.orderItem.orderedQuantity -= 1;

                              for (int i = 0; i < attributeList.length; i++) {
                                if (attributeList[i].qty != 0) {
                                  attributeList[i].qty =
                                      attributeList[i].moq * widget.orderItem.orderedQuantity;

                                  attributeList[attributeList.indexWhere(
                                          (element) => element.id == attributeList[i].id)] = attributeList[i];
                                }
                              }

                              _calculateItemPrice();
                            }
                          });
                        },
                      ),
                      hightSpacer10,
                      // Ensures this section scrolls properly without being too small
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 350,
                          maxHeight: MediaQuery.of(context).size.height * 0.8, // Adjust height dynamically
                        ),
                        child: attributeList.isNotEmpty ? _optionSection() : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              // This ensures the Item Total container matches the width of the main container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: MAIN_COLOR,
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item Total",
                          style: getTextStyle(
                              fontSize: MEDIUM_FONT_SIZE,
                              color: WHITE_COLOR,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${itemTotal.toStringAsFixed(2)} $appCurrency2",
                          style: getTextStyle(
                              fontSize: LARGE_FONT_SIZE,
                              fontWeight: FontWeight.w600,
                              color: WHITE_COLOR),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Text(
                        "Add Item",
                        style: getTextStyle(
                            fontSize: Device.get().isTablet ? LARGE_FONT_SIZE : MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.bold,
                            color: WHITE_COLOR),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  _attrioptionsItems(Attribute attribute, int index) {
    return InkWell(
      onTap: () => _handleOptionSelection(attribute, index),
      child: Padding(
        padding: verticalSpace(x: 5),
        child: AddedAttributItem(
          product: attribute,
          onDelete: () {},
          disableDeleteOption: true,
          isUsedinVariantsPopup: true,
          onItemAdd: () {
            debugPrint("Stock count: ${widget.orderItem.stock}");
            setState(() {
              // if (attributeList.qt <
              //     widget.orderItem.stock ||
              //     widget.orderItem.stock == 0) {
              attribute.qty =
                  attribute.qty + 1;

              attribute.moq = attribute.qty;

              attributeList[attributeList.indexWhere(
                  (element) => element.id == attribute.id)] = attribute;
              _calculateItemPrice();
              // _selectedCustomerSection();
              // }
            });
          },
          onItemRemove: () {
            setState(() {
              if (attribute.qty > 1) {
                attribute.qty = attribute.qty - 1;
                attribute.moq =attribute.qty;
                attributeList[attributeList.indexWhere(
                    (element) => element.id == attribute.id)] = attribute;
                _calculateItemPrice();
              }else{
                attribute.qty = 0;
                attribute.moq = attribute.qty;
                attributeList[attributeList.indexWhere(
                        (element) => element.id == attribute.id)] = attribute;
                _calculateItemPrice();
              }
            });
          },
        ),

        // Row(
        //   children: [
        // option.selected
        //     ? Visibility(
        //         visible: true,
        //         child:
        //         Container(
        //             clipBehavior: Clip.antiAlias,
        //             decoration: BoxDecoration(
        //               border: Border.all(color: MAIN_COLOR),
        //               // border: Border.all(color: Colors.yellow.shade800),
        //               color: MAIN_COLOR,
        //               // color: Colors.yellow.shade800,
        //               borderRadius:
        //                   BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
        //             ),
        //             child: const Icon(
        //               Icons.check,
        //               size: 18.0,
        //               color: WHITE_COLOR,
        //             )),

        // ),
        //     :
        // Container(
        //   clipBehavior: Clip.antiAlias,
        //   decoration: BoxDecoration(
        //     border: Border.all(color: BLACK_COLOR),
        //     borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06),
        //   ),
        //   child: const Icon(
        //     null,
        //     size: 20.0,
        //   ),
        // ),
        // widthSpacer(5),
        // Text(
        //   attribute.name,
        //   style: getTextStyle(
        //       fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
        // ),
        // const Spacer(),
        // Text(
        //   "$appCurrency ${attribute.rate.toStringAsFixed(2)}",
        //   style: getTextStyle(
        //       fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.normal),
        // ),
        //   ],
        // ),
      ),
    );
  }



  _optionSection() {
    return Padding(
      padding: isTabletMode ? horizontalSpace() : horizontalSpace(x: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Total Addons: ${attributeList.length}',
            style: getTextStyle(fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.02),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              primary: false,
              physics: const BouncingScrollPhysics(),
              padding: verticalSpace(),
              itemCount: widget.orderItem.attributes.length,
              itemBuilder: (context, index) {
                return _attrioptionsItems(
                    widget.orderItem.attributes[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  _handleOptionSelection(Attribute attribute, int index) {
    Attribute option = attribute;
    debugPrint("index: $index");
    // if (attribute.type == "Multiselect") {
    //   debugPrint("Checkbox type functionality");
    //   if (attribute.moq > 0) {
    //     //TODO::: Do work here
    //     debugPrint(
    //         "check to see that atleast ${attribute.moq} options are selected");
    //   } else {
    //     setState(() {
    //   option.selected = !option.selected;
    //   if (option.selected) {
    //     double optionsTotal =
    //         option.price * widget.orderItem.orderedQuantity;
    //     itemTotal = itemTotal + optionsTotal;
    //     //itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    //   } else {
    //     double optionsTotal =
    //         option.price * widget.orderItem.orderedQuantity;
    //     itemTotal = itemTotal - optionsTotal;
    //     //itemTotal = itemTotal * widget.orderItem.orderedQuantity;
    //   }
    // }
    // );
    // }
    // } else {
    //   debugPrint("Radio button type functionality");
    for (var i = 0; i < attributeList.length; i++) {
      var opt = attributeList[i];

      double optionsTotal = opt.rate * 1;
      itemTotal = itemTotal + optionsTotal;
      // if (i == index) {
      //   if (!opt.selected) {
      //     opt.selected = true;
      widget.orderItem.orderedPrice = widget.orderItem.orderedPrice + opt.rate;
      //   }
      // } else {
      //   if (opt.selected) {
      //     opt.selected = false;
      //     widget.orderItem.orderedPrice =
      //         widget.orderItem.orderedPrice - opt.price;
      //   }
      // }
    }
    setState(() {});
    // }
  }
}
