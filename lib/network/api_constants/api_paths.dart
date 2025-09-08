// ignore_for_file: constant_identifier_names

import '../../constants/app_constants.dart';
import '../api_helper/api_server.dart';

///Base API URL for development environment
const DEV_URL = 'https://getpos.in/api/';
const DEV_ERP_URL = 'getpos.in';
// const DEV_URL = 'https://agriboratest.nestorhawk.com/api/';

///Base API URL for staging/test environment
const TEST_URL = 'https://tst.erp.nbpos.com/api/';
const TEST_ERP_URL = 'getpos.in';

///Base API URL for production environment
const PROD_URL = 'https://prd.erp.nbpos.com/api/';
const PROD_ERP_URL = 'getpos.in';

///Default URL for POS instance
String instanceUrl = ENVIRONMENT == ApiServer.DEV
    ? DEV_ERP_URL
    : ENVIRONMENT == ApiServer.TEST
        ? TEST_ERP_URL
        : PROD_ERP_URL;

///Base API URL for production environment
// ignore: non_constant_identifier_names
final BASE_URL = ENVIRONMENT == ApiServer.DEV
    ? DEV_URL
    : ENVIRONMENT == ApiServer.TEST
        ? TEST_URL
        : PROD_URL;

//RUE URL
const RUE_BASE = 'https://ruecateringdemo.asatechbh.com/';
const RUE_BASE_PATH = 'https://ruecateringdemo.asatechbh.com/api/Mobile/';
const RUE_IMAGE_BASE_PATH = 'https://ruecatering.asatechbh.com/Uploads/Product/';
const RUE_LOGIN_PATH = '${RUE_BASE_PATH}getLoginbyPin';
const CATEGORY_PATH = 'getCategory';
const CATEGORYALL_PATH = 'getCategoryAll';
const TABLE_PATH = '${RUE_BASE_PATH}getTable';
const STOCK_PATH = '${RUE_BASE_PATH}getAllProductbyStore';
const PRODUCT_PATH = 'getProduct';
const CAT_PRODUCT_PATH = '${RUE_BASE_PATH}getProductAll1';
const SALES_PATH = '${RUE_BASE_PATH}getOrderDtlbyId';
const TODAY_SALES_PATH = '${RUE_BASE_PATH}getTodaySales';
const LOCATION_PATH = '${RUE_BASE_PATH}getLocation';
const TABLE_LOCATION_PATH = '${RUE_BASE_PATH}getTableLocation';
const BRANCH_PATH = "${RUE_BASE_PATH}getBranch";
const COUNTER_PATH = "${RUE_BASE_PATH}getCounter";

const WITHDRAW_CASH = "${RUE_BASE_PATH}insWithdrawCash";
const CLOSE_DAY = "${RUE_BASE_PATH}insCloseDay";
const START_SHIFT_DAY = "${RUE_BASE_PATH}insOpeningBalance";

const INSERT_CategoryAllocate = "${RUE_BASE_PATH}insCategoryAllocate";
const INSERT_ProductAllocate = "${RUE_BASE_PATH}insProductAllocate";
const INSERT_CART_TAKEAWAY = "${RUE_BASE_PATH}insTakeawayOrder";
const INSERT_CART_POS_ORDER = "${RUE_BASE_PATH}insPOSorder";
const INSERT_CART_DINESAVE = "${RUE_BASE_PATH}insTableOrder";
const GET_CategoryAllocate = "${RUE_BASE_PATH}getCategoryAllocate";
const GET_ProductAllocate = "${RUE_BASE_PATH}getProductAllocate";
const DELETE_CategoryAllocate = "${RUE_BASE_PATH}delCategoryAllocate";
const DELET_ProductAllocate = "${RUE_BASE_PATH}delProductAllocate";
const GET_Printers = "${RUE_BASE_PATH}getPrinters";
const CANCEL_ORDER = "${RUE_BASE_PATH}CancelPOSOrder";
const GET_DELIVERY_SERVICE = "${RUE_BASE_PATH}getDeliveryService";

const ALL_ORDERS_PATH = "${RUE_BASE_PATH}getAllOrderList";
const PICKUP_ORDERS_PATH = "${RUE_BASE_PATH}getAllPickUpOrder";
const OPEN_ORDERS_PATH = "${RUE_BASE_PATH}getAllOpenOrder";
const CLOSE_ORDERS_PATH = "${RUE_BASE_PATH}getAllClosedOrder";
const DETAILS_ORDERS_PATH = "${RUE_BASE_PATH}getOrderDtlbyId";

///LOGIN API PATH
const LOGIN_PATH = 'method/nbpos.nbpos.api.login';

const Verify_URL = 'https://control-centre.nestorbird.com/api/method/control_centre.api.validate';

///CUSTOMERS LIST API PATH
const CUSTOMERS_PATH = 'method/nbpos.nbpos.api.get_customer_list_by_hubmanager';

const CUSTOMER_PATH = 'method/nbpos.nbpos.api.get_customer';

const CREATE_CUSTOMER_PATH = 'method/nbpos.nbpos.api.create_customer';

const NEW_GET_ALL_CUSTOMERS_PATH = 'method/nbpos.nbpos.api.get_all_customer';

//PRODUCTS LIST API PATH
const PRODUCTS_PATH = 'method/nbpos.nbpos.api.get_item_list_by_hubmanager';

//CREATE SALE ORDER PATH
// const CREATE_SALES_ORDER_PATH = 'method/nbpos.nbpos.api.create_sales_order';
const CREATE_SALES_ORDER_PATH = 'method/nbpos.nbpos.api.create_sales_order';

//TOPICS API (PRIVACY POLICY AND TERMS & CONDITIONS)
const TOPICS_PATH = 'method/nbpos.nbpos.api.privacy_policy_and_terms';

//FORGET PASSWORD PATH
const FORGET_PASSWORD = 'method/nbpos.nbpos.api.forgot_password';

//MY ACCOUNT API
const MY_ACCOUNT_PATH = 'method/nbpos.nbpos.api.get_details_by_hubmanager';

//SALES HISTORY PATH
const SALES_HISTORY = 'method/nbpos.nbpos.api.get_sales_order_list';

//MY ACCOUNT API
const CHANGE_PASSWORD_PATH = 'method/nbpos.nbpos.api.change_password';

// New Product api with category and variants
const CATEGORY_PRODUCTS_PATH =
    'method/nbpos.custom_api.item_variant_api.get_items';

//PROMO CODES API PATH
const GET_ALL_PROMO_CODES_PATH = '';
