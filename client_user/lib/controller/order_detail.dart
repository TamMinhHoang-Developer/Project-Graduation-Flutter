import 'package:client_user/modal/order_detail.dart';
import 'package:get/get.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get instance => Get.find();
  RxList<OrderDetailSnapshot> orderDetailItems = RxList<OrderDetailSnapshot>();

  getOrderDetailByOrderId(String userId, String orderId) async {
    orderDetailItems
        .bindStream(OrderDetailSnapshot.getListOrder(userId, orderId));
  }
}
