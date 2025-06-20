// ignore_for_file: unused_local_variable, avoid_print, unnecessary_brace_in_string_interps, unnecessary_null_comparison, invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dasboard_admin/controllers/waltinguser_controller.dart';
import 'package:dasboard_admin/modals/users_modal.dart';
import 'package:get/get.dart';

class TotalController extends GetxController {
  RxList<UserSnapshot> users = RxList<UserSnapshot>();
  var selectedUser = UserSnapshot(user: Users(), documentReference: null).obs;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');
  final walt = Get.put(WaltingUserController());

  final totalUserWalting = 0.obs;
  final totalUserActive = 0.obs;

  @override
  void onInit() {
    // Gọi phương thức lấy dữ liệu từ Firebase và gán cho biến users
    bindingUser();
    super.onInit();
  }

  bindingUser() {
    users.bindStream(UserSnapshot.dsUserTuFirebase());
  }

  void updateTotalCounts() {
    int waitingCount = 0;
    int activeCount = 0;

    for (var element in users.value) {
      if (element.user!.Status == false) {
        waitingCount++;
      } else {
        activeCount++;
      }
    }

    totalUserWalting.value = waitingCount;
    totalUserActive.value = activeCount;
  }

  void setSelectedUser(UserSnapshot user) {
    selectedUser.value = user;
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

  bool isOver30Days(Users userSnapshot) {
    const int millisecondsInADay = 24 * 60 * 60 * 1000;

    if (userSnapshot != null && userSnapshot.ActiveAt != null) {
      int activeAt = userSnapshot.ActiveAt!;
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      int daysDiff = (currentTimestamp - activeAt) ~/ millisecondsInADay;

      return daysDiff > 30;
    }

    return false;
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

  void getSinhviens() async {
    final value = await UserSnapshot.dsUserTuFirebaseOneTime();
    users.value = value;
    users.refresh();
  }

  getListUser() async {
    users.bindStream(UserSnapshot.dsUserTuFirebase());
  }

  void searchUser(String keyword) {
    final dataSearch = usersRef
        .where('Name', isGreaterThanOrEqualTo: keyword)
        // ignore: prefer_interpolation_to_compose_strings
        .where('Name', isLessThanOrEqualTo: keyword + '\uf8ff')
        .snapshots();
    dataSearch.listen((snapshot) {
      users.value =
          snapshot.docs.map((doc) => UserSnapshot.fromSnapshot(doc)).toList();
    });
  }

  void sendNotificationToUser(String userToken, String notificationTitle,
      String notificationBody) async {
    const String serverKey =
        'AAAAAQaiVfI:APA91bGn_dXpSEwAU7qg4WXV54tdS15B_LcFRN5ubCnLkcijDOzXHJRVfcnO0GNs_kiSZahvjVuAe64VwT5rQQVK0GcJHhjq2RaegF7NXK-EUChoqIgPOe9_yPzEsSxsn9Z9CDmH1KOj';
    const String fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

    Map<String, dynamic> notificationData = {
      'to': userToken,
      'notification': {
        'title': notificationTitle,
        'body': notificationBody,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    };
  }

  void searchProductByName(String productName) {
    List<UserSnapshot> searchedTables = users
        .where((table) =>
            table.user!.Name!.toLowerCase().contains(productName.toLowerCase()))
        .toList();
    users.value = searchedTables;
  }

  void updateUserStatus(String userId, bool status) {
    usersRef.doc(userId).update({
      'Status': status,
    });
    walt.countMyDocuments();
    walt.countMyDocumentsWithStatusFalse();
    walt.countMyDocumentsWithStatusTrue();
  }

  int countUsersByMonth(int month) {
    int count = 0;

    for (var user in users) {
      DateTime orderTime =
          DateTime.fromMillisecondsSinceEpoch(user.user!.CreatedAt!);
      if (orderTime.month == month) {
        count++;
      }
    }

    return count;
  }

  int countMyDocuments(RxList<UserSnapshot> documents) {
    return documents.length;
  }

  int countAdults(bool status) {
    return users.where((snapshot) => snapshot.user!.Status == status).length;
  }

  void searchUsers(List<Map<String, dynamic>> queries) async {
    try {
      Query<Object?> query = usersRef;
      for (var q in queries) {
        query = query.where(q['field'], isEqualTo: q['value']);
      }
      var snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        users.assignAll(snapshot.docs
            .map((doc) => UserSnapshot.fromSnapshot(doc))
            .toList());
      } else {
        users = ((await usersRef.get()) as RxList<UserSnapshot>?)!;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Phương thức tìm kiếm theo tên
  List<UserSnapshot> searchByName(String name) {
    return users
        .where((user) =>
            user.user!.Name!.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<void> addUser(Users user) async {
    await usersRef.add(user.toJson());
  }

  Future<void> updateUser(String id, Users user) async {
    await usersRef.doc(id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await usersRef.doc(id).delete();
  }
}
