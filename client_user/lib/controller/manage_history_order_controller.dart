import 'package:client_user/modal/order_history.dart';
import 'package:client_user/screens/home/screen_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageHistoryOrderController extends GetxController {
  static ManageHistoryOrderController get instance => Get.find();
  RxList<OrderHistorySnapshot> listHistoryOrdr = RxList<OrderHistorySnapshot>();
  final CollectionReference productRef =
      FirebaseFirestore.instance.collection('Users');

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getListOrderHistory(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  getListOrderHistory(String id) {
    listHistoryOrdr.bindStream(OrderHistorySnapshot.getListOrderHistory(id));
  }

  void addNewOrderHistory(String id, OrdersHistory orderHistory) {
    OrderHistorySnapshot.themMoiAutoId(orderHistory, id)
        .then((_) => {
              Get.snackbar('Success', "Add Order History Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            })
        .catchError((err) => {
              Get.snackbar('Error', err.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black),
            });
    Get.to(() => const ScreenHome());
    // // ignore: avoid_print
    // print("Order" + orderHistory.order!.Total.toString());
    // print("Id Order" + id);
  }
}
