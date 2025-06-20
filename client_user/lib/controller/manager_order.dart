import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/screens/home/screen_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerOrderController extends GetxController {
  static ManagerOrderController get instance => Get.find();
  RxList<OrdersSnapshot> orderLists = RxList<OrdersSnapshot>();
  Rx<OrdersSnapshot> order =
      Rx<OrdersSnapshot>(OrdersSnapshot(order: null, documentReference: null));
  final totalOrder = 0.obs;
  final tableontrol = Get.put(ManageTableController());

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getListOrder(FirebaseAuth.instance.currentUser!.uid);
      checkTotalProduct(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  getListOrder(String id) async {
    orderLists.bindStream(OrdersSnapshot.getListOrder(id));
  }

  checkTotalProduct(id) async {
    if (id != "") {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      print("Checl Product" + id);
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('Users');
      DocumentReference userDocRef = usersRef.doc(id);
      CollectionReference productsRef = userDocRef.collection('Orders');
      productsRef.get().then((querySnapshot) {
        int numProducts = querySnapshot.docs.length;
        // ignore: avoid_print
        print('Số lượng order: $numProducts');
        totalOrder(numProducts);
      });
    }
  }

  void addOrderSeller(
      String idUser, Orders seller, List<OrderDetail> orderDetail) {
    OrdersSnapshot.themMoiAutoId(seller, idUser, orderDetail)
        .then((_) => {
              Get.snackbar('Success', "Add Order Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            })
        .catchError((err) => {
              Get.snackbar('Error', err.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            });

    tableontrol.getListTable(FirebaseAuth.instance.currentUser!.uid);
    Get.to(() => const ScreenHome());
  }

  void updateOrder(String idUser, Orders seller) {
    OrdersSnapshot.updateOrder(seller, idUser)
        .then((_) => {
              Get.snackbar('Success', "Update Order Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            })
        .catchError((err) => {
              Get.snackbar('Error', err.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            });
  }

  void deleteOrder(String idUser, Orders order) {
    OrdersSnapshot.deleteOrder(order, idUser)
        .then((_) => {
              Get.snackbar('Success', "Delete Order Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black),
              // ignore: list_remove_unrelated_type
              orderLists.remove(order)
            })
        .catchError((err) => {
              Get.snackbar('Error', err.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            });
  }
}
