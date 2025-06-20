import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/modal/tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageTableController extends GetxController {
  RxList<TableSnapshot> users = RxList<TableSnapshot>();
  final CollectionReference tablesRef =
      FirebaseFirestore.instance.collection('Users');
  static ManageTableController get instance => Get.find();
  var userId = "";

  // Input variable
  final name = TextEditingController();
  final slot = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getListTable(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  final homeController = Get.put(HomeController());

  void searchTableByName(String tableName, String userId) {
    List<TableSnapshot> searchedTables = users
        .where((table) =>
            table.table!.Name!.toLowerCase().contains(tableName.toLowerCase()))
        .toList();
    users.value = searchedTables;
  }

  void searchTableByNamev2(String tableName, String userId) {
    RegExp regExp = RegExp(tableName, caseSensitive: false);
    List<TableSnapshot> searchedTables =
        users.where((table) => regExp.hasMatch(table.table!.Name!)).toList();
    users.value = searchedTables;
  }

  void addNewTable(String id, Tables table) {
    TableSnapshot.themMoiAutoId(table, id)
        .then((_) => {
              Get.snackbar('Success', "Add Table Success",
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

    homeController.checkTotalTable(id);
    getListTable(id);
  }

  getListTable(String id) async {
    users.bindStream(TableSnapshot.dsUserTuFirebase(id));
  }

  getListTableByStatus(String id, String status) {
    users.bindStream(TableSnapshot.dsUserTuFirebaseFilter(id, status));
  }

  void deleteTable(String id, String tableId) async {
    await tablesRef
        .doc(id)
        .collection("Tables")
        .doc(tableId)
        .delete()
        .then((_) => {
              Get.snackbar('Success', "Remove Table Success",
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
    homeController.checkTotalTable(id);
    getListTable(id);
  }

  void editTable(String userid, Tables tables, String tableId) async {
    await tablesRef
        .doc(userid)
        .collection("Tables")
        .doc(tableId)
        .update(tables.toJson())
        .then((_) => {
              Get.snackbar('Success', "Edit Table Success",
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
    getListTable(userid);
  }
}
