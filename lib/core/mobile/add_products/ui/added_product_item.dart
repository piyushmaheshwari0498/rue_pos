import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/models/attribute.dart';
import '../../../../database/models/order_item.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class AddedProductItem extends StatefulWidget {
  Function? onDelete;
  Function? onItemAdd;
  Function? onItemRemove;
  OrderItem product;
  bool? disableDeleteOption;
  bool isUsedinVariantsPopup;

  AddedProductItem(
      {Key? key,
      required this.onDelete,
      required this.onItemAdd,
      required this.onItemRemove,
      this.disableDeleteOption = false,
      required this.product,
      this.isUsedinVariantsPopup = false})
      : super(key: key);

  @override
  State<AddedProductItem> createState() => _AddedProductItemState();
}

class _AddedProductItemState extends State<AddedProductItem> {
  final Widget _greySizedBox =
      SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

  @override
  Widget build(BuildContext context) {
    String selectedQty = widget.product.orderedQuantity < 10
        ? "0${widget.product.orderedQuantity.round()}"
        : "${widget.product.orderedQuantity.round()}";

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            Container(
              height: 90,
              width: 90,
              child: widget.product.productImage.isEmpty
                  ? SvgPicture.asset(
                PRODUCT_IMAGE_SMALL,
                fit: BoxFit.contain,
              )
                  : Image.network(
                "$RUE_IMAGE_BASE_PATH${widget.product!.productImage}",
                fit: BoxFit.cover,
              ),
            ),

            widthSpacer(10),

            // RIGHT SIDE INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PRODUCT NAME + ITEM CODE
                  Text(
                    widget.product.name,
                    style: getTextStyle(
                      fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 :MediaQuery.of(context).size.width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (widget.isUsedinVariantsPopup)
                    Text(
                      'Item Code - ${widget.product.id}',
                      style: getTextStyle(
                        fontSize: Device.get().isTablet ?  MediaQuery.of(context).size.width * 0.0095 : MediaQuery.of(context).size.width * 0.0200,
                        color: DARK_GREY_COLOR,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                  hightSpacer10,

                  // RATE + STOCK + QUANTITY CONTROLS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CENTERED TEXTS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Rate: ${widget.product.price.toStringAsFixed(2)} $appCurrency2',
                              style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.02,
                                color: MAIN_COLOR,
                              ),
                            ),
                            if (widget.isUsedinVariantsPopup && widget.product.stock != null &&widget.product.stock.toInt() != 0)
                              Text(
                                "Available Stock - ${widget.product.stock.toInt()}",
                                style: getTextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.02,
                                  color: GREEN_COLOR,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // QUANTITY BUTTONS
                      Row(
                        children: [
                          InkWell(
                            onTap: () => widget.onItemRemove!(),
                            child: Container(
                              width: Device.get().isTablet ? 60 : 40,
                              height: Device.get().isTablet ? 60 : 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MAIN_COLOR.withOpacity(0.1),
                              ),
                              child: Icon(Icons.remove, size: Device.get().isTablet ? 60 : 20, color: MAIN_COLOR),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              selectedQty,
                              style: getTextStyle(
                                fontSize: Device.get().isTablet ? MediaQuery.of(context).size.width * 0.01 : MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w600,
                                color: MAIN_COLOR,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => widget.onItemAdd!(),
                            child: Container(
                              width: Device.get().isTablet ? 60 : 40,
                              height: Device.get().isTablet ? 60 : 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MAIN_COLOR.withOpacity(0.1),
                              ),
                              child: Icon(Icons.add, size: Device.get().isTablet ? 60 : 20, color: MAIN_COLOR),
                            ),
                          ),
                        ],
                      ),
                      widthSpacer(10),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),

        // CROSS CLOSE BUTTON TOP RIGHT
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: Device.get().isTablet ? EdgeInsets.all(8.0) : EdgeInsets.all(2.0),
              child: SvgPicture.asset(
                CROSS_ICON,
                height: Device.get().isTablet ? 20 : 15,
                color: BLACK_COLOR,
              ),
            ),
          ),
        ),
      ],
    );


  }

  String _getItemVariants(List<Attribute> itemVariants) {
    String variants = '';
    if (itemVariants.isNotEmpty) {
      for (var variantData in itemVariants) {
        for (var selectedOption in variantData.options) {
          if (selectedOption.selected) {
            variants = variants.isEmpty
                ? '${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]'
                : "$variants, ${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]";
          }
        }
      }
    }
    return variants;
  }
}
