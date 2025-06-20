// ignore_for_file: non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dasboard_admin/modals/users_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaltingUserController extends GetxController {
  RxList<UserSnapshot> listUsers = RxList<UserSnapshot>();
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  final totalActive = 0.obs;
  final totalWalting = 0.obs;
  final totalAll = 0.obs;
  final userCountMonth1 = 0.obs;
  final userCountMonth2 = 0.obs;
  final userCountMonth3 = 0.obs;
  final userCountMonth4 = 0.obs;
  final userCountByMonth = <int, RxInt>{};
  final numberOfMonths = 12;

  @override
  void onInit() {
    // Gọi phương thức lấy dữ liệu từ Firebase và gán cho biến users
    getListUser();
    countMyDocuments();
    countMyDocumentsWithStatusFalse();
    countMyDocumentsWithStatusTrue();
    countNewUsers();
    super.onInit();
  }

  void updateUserStatus(String userId) {
    final usersRef = FirebaseFirestore.instance.collection('Users');

    usersRef.doc(userId).get().then((DocumentSnapshot document) {
      if (document.exists) {
        UserSnapshot userSnapshot = UserSnapshot.fromSnapshot(document);
        Users? user = userSnapshot.user;

        if (user != null && (user.ActiveAt == null || user.ActiveAt == 0)) {
          usersRef.doc(userId).update({
            'Status': true,
            'ActiveAt': DateTime.now().millisecondsSinceEpoch,
          });
        } else {
          usersRef.doc(userId).update({'Status': true});
        }
      }
    }).catchError((error) {
      Get.snackbar('Error', "Active User Error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);
    });
    countMyDocuments();
    countMyDocumentsWithStatusFalse();
    countMyDocumentsWithStatusTrue();
  }

  getListUser() async {
    listUsers.bindStream(UserSnapshot.dsUserTuFirebaseBool(false));
  }

  int countUsersInMonth(List<UserSnapshot> users, int year, int month) {
    print("Month ${month} ${users.where((user) {
      // Chuyển đổi CreatedAt thành đối tượng DateTime
      DateTime createdAt =
          convertTimestampToDate(int.parse(user.user!.CreatedAt!.toString()));
      // Kiểm tra xem năm và tháng của CreatedAt có khớp với year và month đã cho
      return createdAt.year == year && createdAt.month == month;
    }).length}");
    return users.where((user) {
      // Chuyển đổi CreatedAt thành đối tượng DateTime
      DateTime createdAt =
          convertTimestampToDate(int.parse(user.user!.CreatedAt!.toString()));
      // Kiểm tra xem năm và tháng của CreatedAt có khớp với year và month đã cho
      return createdAt.year == year && createdAt.month == month;
    }).length;
  }

  DateTime convertTimestampToDate(int timestamp) {
    // Chuyển đổi số timestamp thành chuỗi
    String dateString = timestamp.toString();
    // Lấy ra độ dài của chuỗi timestamp
    int length = dateString.length;

    // Kiểm tra xem chuỗi timestamp có đủ 13 ký tự hay không (đại diện cho milliseconds)
    if (length == 13) {
      // Chia chuỗi thành 2 phần (giây và milliseconds)
      String seconds = dateString.substring(0, 10);
      String milliseconds = dateString.substring(10);

      // Chuyển đổi giây và milliseconds thành số
      int secondsValue = int.parse(seconds);
      int millisecondsValue = int.parse(milliseconds);

      // Tạo đối tượng DateTime từ giây và milliseconds
      return DateTime.fromMillisecondsSinceEpoch(
          secondsValue * 1000 + millisecondsValue);
    }

    // Nếu không đủ 13 ký tự, trả về ngày mặc định (hoặc giá trị null tùy theo yêu cầu)
    return DateTime.now(); // Hoặc trả về null: return null;
  }

  Future<void> countNewUsers() async {
    final currentDate = DateTime.now();
    final dateNMonthsAgo =
        currentDate.subtract(Duration(days: numberOfMonths * 30));

    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('CreatedAt', isGreaterThan: Timestamp.fromDate(dateNMonthsAgo))
        .get();

    // Khởi tạo số lượng người đăng ký cho từng tháng
    for (int i = 1; i <= numberOfMonths; i++) {
      userCountByMonth[i] = 0.obs;
    }

    for (var doc in snapshot.docs) {
      Timestamp createdAtTimestamp = doc.data()['CreatedAt'];
      DateTime createdAt = createdAtTimestamp.toDate();

      // Tính toán tháng và năm từ giá trị createdAt
      int monthDifference = currentDate.month - createdAt.month;
      int yearDifference = currentDate.year - createdAt.year;
      int monthIndex = numberOfMonths - (yearDifference * 12 + monthDifference);
      if (monthIndex >= 1 && monthIndex <= numberOfMonths) {
        userCountByMonth[monthIndex]?.value++;
      }
    }
  }

  void searchUser(String keyword) {
    final dataSearch = usersRef
        .where('Name', isGreaterThanOrEqualTo: keyword)
        // ignore: prefer_interpolation_to_compose_strings
        .where('Name', isLessThanOrEqualTo: keyword + '\uf8ff')
        .snapshots();
    dataSearch.listen((snapshot) {
      listUsers.value =
          snapshot.docs.map((doc) => UserSnapshot.fromSnapshot(doc)).toList();
    });
  }

  void countMyDocumentsWithStatusTrue() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Status', isEqualTo: true)
        .get();
    totalActive(snapshot.docs.length);
    print("Active ${totalActive.value}");
  }

  void countMyDocumentsWithStatusFalse() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Status', isEqualTo: false)
        .get();
    totalWalting(snapshot.docs.length);
    print("Walting ${totalWalting.value}");
  }

  void countMyDocuments() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    totalAll(snapshot.docs.length);
    print("All ${totalAll.value}");
  }
}
