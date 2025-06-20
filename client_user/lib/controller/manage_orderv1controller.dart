// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum OrderStatus { loading, success, error }

class OrderV2Controller extends GetxController {
  final _order = Orders().obs;
  final _orderDetailList = <OrderDetail>[].obs;

  Stream<Orders> get orderStream => _order.stream;
  Stream<List<OrderDetail>> get orderDetailListStream =>
      _orderDetailList.stream;

  Orders get order => _order.value;
  // ignore: invalid_use_of_protected_member
  List<OrderDetail> get orderDetailList => _orderDetailList.value;

  setOrder(Orders order) {
    _order.value = order;
  }

  setOrderDetailList(List<OrderDetail> orderDetails) {
    _orderDetailList.value = orderDetails;
  }

  Future<void> getOrderDataFromFirestore(String tableId, String userId) async {
    final ordersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders');

    final querySnapshot =
        await ordersRef.where('TableId', isEqualTo: tableId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final orderId = querySnapshot.docs.first.id;
      final orderData = querySnapshot.docs.first.data();
      final order = Orders.fromJson(orderData);
      setOrder(order);
      getOrderDetailDataFromFirestore(orderId, userId);
    }
  }

  Future<void> getOrderDetailDataFromFirestore(
      String orderId, String userId) async {
    final orderDetailsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders')
        .doc(orderId)
        .collection('OrderDetail');

    final querySnapshot = await orderDetailsRef.get();

    final orderDetailList = querySnapshot.docs.map((doc) {
      final orderDetailData = doc.data();
      return OrderDetail.fromJson(orderDetailData);
    }).toList();

    setOrderDetailList(orderDetailList); // Sửa lại thành orderController
    print(
        "Length Order Detail: ${orderDetailList.length} ID: ${orderId} User: ${userId}");
  }

  @override
  void onInit() {
    super.onInit();
    // Bind the streams to the Rx variables
    ever(_order, (_) => {});
    ever(_orderDetailList, (_) => {});
  }
}
