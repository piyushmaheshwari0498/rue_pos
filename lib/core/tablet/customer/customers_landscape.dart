import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/shimmer_widget.dart';
import '../../../constants/app_constants.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../../utils copy/ui_utils/padding_margin.dart';
import '../../../utils copy/ui_utils/text_styles/custom_text_style.dart';
import '../../../utils/helper.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/create_customer_popup.dart';
import '../widget/delete_customer_popup.dart';
import '../widget/title_search_bar.dart';

class CustomersLandscape extends StatefulWidget {
  const CustomersLandscape({Key? key}) : super(key: key);

  @override
  State<CustomersLandscape> createState() => _CustomersLandscapeState();
}

class _CustomersLandscapeState extends State<CustomersLandscape> {
  late TextEditingController searchCtrl;
  List<Customer> customers = [];
  bool isCustomersFound = true;

  @override
  void initState() {
    // verify();
    searchCtrl = TextEditingController();
    super.initState();
    getCustomersFromDB(0);
  }

  Future<void> getCustomersFromDB(val) async {
    //Fetch the data from local database
    customers = await DbCustomer().getOfflineCustomers();
    isCustomersFound = customers.isEmpty ? false : true;
    // if (val == 0)
    setState(() {});
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
    return SingleChildScrollView(
        // color: const Color(0xFFF9F8FB),
        // padding: paddingXY(),
        child: GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          TitleAndSearchBar(
            focusNode: _focusNode,
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12)
            ],
            title: "Customers",
            keyboardType: TextInputType.number,
            onSubmit: (text) {
              if (text.isNotEmpty) {
                filterCustomerData(text);
              } else {
                getCustomersFromDB(0);
              }
            },
            onTextChanged: (text) {
              if (text.isNotEmpty) {
                filterCustomerData(text);
              } else {
                getCustomersFromDB(0);
              }
            },
            searchCtrl: searchCtrl,
            searchHint: "Enter customer mobile number",
          ),
          InkWell(
              onTap: () async {
                // verify();
                // debugPrint("Logout clicked need to show popup");
                await Get.defaultDialog(
                  // contentPadding: paddingXY(x: 0, y: 0),
                  title: "",
                  titlePadding: paddingXY(x: 0, y: 0),
                  // custom: Container(),
                  content: CreateCustomerPopup(
                    phoneNo: '',
                  ),
                );
                getCustomersFromDB(0);
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/add_icon.svg",
                      // color: MAIN_COLOR,
                      width: 35,
                    ),
                    Text("Add Customer",
                        style: getTextStyle(
                            fontSize: MEDIUM_MINUS_FONT_SIZE,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
          hightSpacer20,
          isCustomersFound
              ? customerGrid()
              : const Center(
                  child: Text("No Customer found!"),
                ),
        ],
      ),
    ));
  }

  Widget customerGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 15, 15),
      child: GridView.builder(
        itemCount: customers.isEmpty ? 10 : customers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6.5,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, position) {
          if (customers.isEmpty) {
            return const ShimmerWidget();
          } else {
            return InkWell(
                onTap: () async {
                  // verify();
                  // debugPrint("Logout clicked need to show popup");
                  await Get.defaultDialog(
                    // contentPadding: paddingXY(x: 0, y: 0),
                    title: "",
                    titlePadding: paddingXY(x: 0, y: 0),
                    // custom: Container(),
                    content: DeleleCusPopupView(
                      customer: customers[position]
                    ),
                  );

                  // Get.();
                  getCustomersFromDB(0);
                  // await DbCustomer().deleteCustomer(tempCustomer.id);
                },
                child: CustomerTile(
                  isCheckBoxEnabled: false,
                  isDeleteButtonEnabled: false,
                  customer: customers[position],
                  isSubtitle: true,
                ));

            getCustomersFromDB(0);
          }
        },
      ),
    );
  }

  void filterCustomerData(String searchText) async {
    await getCustomersFromDB(1);
    customers = customers
        .where((element) =>
            // element.name.toLowerCase().contains(searchText.toLowerCase()) ||
            element.phone.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    isCustomersFound = customers.isNotEmpty;

    // if (!isCustomersFound) {
    //   // CommanResponse response =
    //   //     await CustomerService().getCustomers(searchTxt: searchText);
    // }

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
