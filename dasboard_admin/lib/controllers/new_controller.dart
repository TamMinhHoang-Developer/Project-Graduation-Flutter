import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dasboard_admin/modals/news_modal.dart';
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
      getListNews();
    }
  }

  getListNews() async {
    news.bindStream(NewsSnapshot.getListNewsByAdmin());
  }

  getListNewsGroup(id) {
    newListGroup.bindStream(NewsSnapshot.getListNewsByUserGroupByDate(id));
  }

  markAllRead(id) {
    NewsSnapshot.markAllNewsAsRead(id);
  }

  addNews(News news, String userId) {
    NewsSnapshot.themMoiAutoId(news, userId)
        .then((value) => {
              Get.snackbar('Success', "Add News Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.white)
            })
        .catchError((err) => {
              Get.snackbar('Error', "Add News Fail",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  colorText: Colors.white)
            });
  }
}
