import 'package:client_user/modal/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageNewsController extends GetxController {
  RxList<NewsSnapshot> news = RxList<NewsSnapshot>();
  RxList<List<NewsSnapshot>> newListGroup = RxList<List<NewsSnapshot>>([]);
  final CollectionReference tablesRef =
      FirebaseFirestore.instance.collection('Admin');
  static ManageNewsController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      getListNews(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  getListNews(String id) async {
    news.bindStream(NewsSnapshot.getListNewsByUser(id));
  }

  getListNewsGroup(id) {
    newListGroup.bindStream(NewsSnapshot.getListNewsByUserGroupByDate(id));
  }

  markAllRead(id) {
    NewsSnapshot.markAllNewsAsRead(id);
  }

  addNews(News news) {
    NewsSnapshot.themMoiAutoId(news)
        .then((value) => {
              Get.snackbar('Success', "Create Account Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.white)
            })
        .catchError((err) => {
              Get.snackbar('Error', "Create News Fail",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  colorText: Colors.white)
            });
  }
}
