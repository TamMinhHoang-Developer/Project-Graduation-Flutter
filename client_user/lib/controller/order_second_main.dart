import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/modal/tables.dart';
import 'package:get/get.dart';

class OrderSecondController extends GetxController {
  static OrderSecondController get instance => Get.find();
  RxList<OrderDetailFireBase> cartItems = RxList<OrderDetailFireBase>();
  final totalOrder = 0.obs;

  void addDefault(List<OrderDetail> orders) {
    List<OrderDetailFireBase> ordersFireBase = orders
        .map((order) => OrderDetailFireBase(
            IdProduct: order.IdProduct,
            NameProduct: order.NameProduct,
            Price: order.Price,
            Quantity: order.Quantity ?? 0))
        .toList();

    cartItems.addAll(ordersFireBase);
  }

  void addToCart(Products product, Tables tables) {
    final index =
        cartItems.indexWhere((item) => item.NameProduct == product.Name);

    if (index == -1) {
      final orderT = OrderDetailFireBase(
          IdProduct: product.Id,
          NameProduct: product.Name,
          Price: product.Price,
          Quantity: 1);
      cartItems.add(orderT);
    } else {
      cartItems[index].Quantity(cartItems[index].Quantity.value + 1);
    }
  }

  void removeFromCart(OrderDetailFireBase item) {
    final index = cartItems
        .indexWhere((cartItem) => cartItem.NameProduct == item.NameProduct);
    if (index != -1) {
      if (cartItems[index].Quantity.value == 1) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].Quantity(cartItems[index].Quantity.value - 1);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}
