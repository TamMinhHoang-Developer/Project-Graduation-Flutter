import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/modal/tables.dart';
import 'package:get/get.dart';

class OrderLocalController extends GetxController {
  static OrderLocalController get instance => Get.find();
  // final cartItems = <OrderDetailLocal>[].obs;
  RxList<OrderDetailLocal> cartItems = RxList<OrderDetailLocal>();
  final totalOrder = 0.obs;

  void addToCart(Products product, Tables tables) {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final index =
        cartItems.indexWhere((item) => item.products!.Name == product.Name);

    if (index == -1) {
      final orderTemp =
          OrderDetailLocal(Quantity: 1, products: product, tables: tables);
      cartItems.add(orderTemp);
    } else {
      // Nếu sản phẩm đã có trong giỏ hàng, tăng số lượng lên 1
      cartItems[index].Quantity(cartItems[index].Quantity.value + 1);
    }

    getTotalQuantityOrder();
  }

  void clearCart() {
    cartItems.clear();
    getTotalQuantityOrder();
  }

  void removeFromCart(OrderDetailLocal item) {
    final index = cartItems.indexWhere(
        (cartItem) => cartItem.products!.Name == item.products!.Name);
    if (index != -1) {
      if (cartItems[index].Quantity.value == 1) {
        // Nếu số lượng sản phẩm là 1, xóa khỏi danh sách
        cartItems.removeAt(index);
      } else {
        // Nếu số lượng sản phẩm lớn hơn 1, giảm số lượng đi 1
        cartItems[index].Quantity(cartItems[index].Quantity.value - 1);
      }
    }
    getTotalQuantityOrder();
  }

  double get totalPrice => cartItems.fold(
      0, (sum, item) => sum + (item.products!.Price! * item.Quantity.value));

  get total => cartItems
      .map((element) => element.Quantity.value * element.products!.Price!)
      .toList()
      .reduce((value, element) => value + element)
      .toStringAsFixed(2);

  getTotalQuantityOrder() {
    final total = cartItems.fold(0, (sum, item) => sum + item.Quantity.value);
    totalOrder(total);
  }
}
