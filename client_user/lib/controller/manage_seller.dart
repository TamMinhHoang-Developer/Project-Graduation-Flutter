import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/modal/sellers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageSellerController extends GetxController {
  RxList<SellerSnapshot> users = RxList<SellerSnapshot>();
  final CollectionReference tablesRef =
      FirebaseFirestore.instance.collection('Users');
  static ManageSellerController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getListSeller(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  // Input variable
  final name = TextEditingController();
  final address = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final salary = TextEditingController();
  final sex = TextEditingController();
  final age = TextEditingController();
  final birthday = TextEditingController();

  final homeController = Get.put(HomeController());

  getListSeller(String id) async {
    users.bindStream(SellerSnapshot.dsSellerTuFirebase(id));
  }

  void searchSellerByName(String productName, String userId) {
    List<SellerSnapshot> searchedTables = users
        .where((table) => table.seller!.Name!
            .toLowerCase()
            .contains(productName.toLowerCase()))
        .toList();
    users.value = searchedTables;
  }

  void searchProducts(String keyword, String userId) {
    final dataSearch = tablesRef
        .doc(userId)
        .collection("Sellers")
        .where('Name', isGreaterThanOrEqualTo: keyword)
        // ignore: prefer_interpolation_to_compose_strings
        .where('Name', isLessThanOrEqualTo: keyword + '\uf8ff')
        .snapshots();
    dataSearch.listen((snapshot) {
      users.value =
          snapshot.docs.map((doc) => SellerSnapshot.fromSnapshot(doc)).toList();
    });
  }

  void addNewSeller(String id, Seller seller) {
    SellerSnapshot.themMoiAutoId(seller, id)
        .then((_) => {
              Get.snackbar('Success', "Add Seller Success",
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
  }

  void deleteSeller(String id, String tableId) async {
    await tablesRef
        .doc(id)
        .collection("Sellers")
        .doc(tableId)
        .delete()
        .then((_) => {
              Get.snackbar('Success', "Remove Seller Success",
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
  }

  double calculateTotalSalary() {
    double totalSalary = 0;

    for (var sellerSnapshot in users) {
      double salary =
          double.tryParse(sellerSnapshot.seller!.Salary ?? '0') ?? 0;
      totalSalary += salary;
    }

    return totalSalary;
  }

  void editSeller(String userid, Seller seller, String sellerId) async {
    await tablesRef
        .doc(userid)
        .collection("Sellers")
        .doc(sellerId)
        .update(seller.toJson())
        .then((_) => {
              Get.snackbar('Success', "Edit Seller Success",
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
    getListSeller(userid);
  }
}
