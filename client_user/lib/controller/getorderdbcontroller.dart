// ignore_for_file: avoid_print

import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetOrderController extends GetxController {
  static GetOrderController get instance => Get.find();
  RxList<OrdersSnapshot> order = RxList<OrdersSnapshot>();
  RxList<OrderDetailSnapshot> orderDetailItems = RxList<OrderDetailSnapshot>();

  void getOrderbyTableId(String idUser, String idTable) async {
    final collection = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders");
    final query = collection.where("TableId", isEqualTo: idTable);
    order.bindStream(query.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((doc) => OrdersSnapshot(
              order: Orders(
                Id: doc.id,
                TableId: doc.data()["TableId"],
                TableName: doc.data()["TableName"],
                CreateDate: doc.data()["CreateDate"],
                Total: doc.data()["Total"],
                Status: doc.data()["Status"],
                Seller: doc.data()["Seller"],
              ),
              documentReference: doc.reference,
            ))
        .toList()));
  }

  void getOrderDetailById(String idUser, String orderId) {
    final collection = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders")
        .doc(orderId)
        .collection("OrderDetail")
        .snapshots();

    orderDetailItems.bindStream(collection.map((querySnapshot) => querySnapshot
        .docs
        .map((doc) => OrderDetailSnapshot.fromSnapshot(doc))
        .toList()));
  }
}
