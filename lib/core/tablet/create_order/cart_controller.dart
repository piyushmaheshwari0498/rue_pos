// file: cart_controller.dart
import 'package:get/get.dart';

import '../../../database/models/order_item.dart';

class CartController extends GetxController {
  var orderItems = <OrderItem>[].obs;
  var cartSize = 0.obs;
  var totalAmount = 0.0.obs;

  void addItem(OrderItem item) {
    orderItems.add(item);
    _updateCartState();
  }

  void clearCart() {
    orderItems.clear();
    _updateCartState();
  }

  void _updateCartState() {
    cartSize.value = orderItems.length;
    totalAmount.value = orderItems.fold(0.0, (sum, item) => sum + (item.price * item.orderedQuantity));
  }
}
