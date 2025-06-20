// ignore_for_file: non_constant_identifier_names

import 'package:client_user/modal/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  int? CreateDate;
  double? Total;
  bool? Status;
  String? Seller, TableId, TableName, Id;

  Orders({
    this.Id,
    this.TableId,
    this.TableName,
    this.CreateDate,
    this.Total,
    this.Status,
    this.Seller,
  });

  factory Orders.fromJson(Map<String, dynamic> map) {
    return Orders(
      Id: map['Id'],
      TableId: map['TableId'],
      TableName: map['TableName'],
      CreateDate: map['CreateDate'],
      Total: map['Total'],
      Status: map['Status'],
      Seller: map['Seller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'TableId': TableId,
      'TableName': TableName,
      'CreateDate': CreateDate,
      'Total': Total,
      'Status': Status,
      'Seller': Seller,
    };
  }
}

class OrdersSnapshot {
  Orders? order;
  DocumentReference? documentReference;

  OrdersSnapshot({
    required this.order,
    required this.documentReference,
  });

  factory OrdersSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return OrdersSnapshot(
        order: Orders.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<void> deleteOrder(Orders order, String userId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders')
        .doc(order.Id)
        .delete();

    updateStatusTableActive(userId, order.TableId);
  }

  static Future<void> updateOrder(Orders order, String userId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Orders')
        .doc(order.Id)
        .update(order.toJson());
  }

  static Future<DocumentReference> themMoi(Orders order, String idUser) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders")
        .add(order.toJson());
  }

  static Future<void> themMoiAutoId(
      Orders order, String idUser, List<OrderDetail> details) async {
    // Add the Order
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection("Orders");
    DocumentReference newDocRef = usersRef.doc();
    order.Id = newDocRef.id;
    await newDocRef.set(order.toJson());

    // Change Status Table
    updateStatusTableWalting(idUser, order.TableId);

    // Call add Order Details
    for (var detail in details) {
      detail.OrderId = newDocRef.id;
      await OrderDetailSnapshot.themMoiAutoId(detail, idUser, newDocRef.id);
    }
  }

  static Future<void> updateStatusTableWalting(idUser, idTable) async {
    CollectionReference tablesRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection('Tables');
    QuerySnapshot tableQuerySnapshot =
        await tablesRef.where('Id', isEqualTo: idTable).get();
    DocumentSnapshot tableSnapshot = tableQuerySnapshot.docs.first;
    DocumentReference tableDocRef = tablesRef.doc(tableSnapshot.id);
    tableDocRef.update({'Status': 'Walting'});
  }

  static Future<void> updateStatusTableActive(idUser, idTable) async {
    CollectionReference tablesRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection('Tables');
    QuerySnapshot tableQuerySnapshot =
        await tablesRef.where('Id', isEqualTo: idTable).get();
    DocumentSnapshot tableSnapshot = tableQuerySnapshot.docs.first;
    DocumentReference tableDocRef = tablesRef.doc(tableSnapshot.id);
    tableDocRef.update({'Status': 'Normal'});
  }

  static Stream<List<OrdersSnapshot>> getListOrder(String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => OrdersSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Stream<List<OrdersSnapshot>> getOrderStream(
      String userId, String tableId) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection("Orders")
        .where("TableId", isEqualTo: tableId)
        .snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap
        .map((listDocSnap) => listDocSnap
            .map((docSnap) => OrdersSnapshot.fromSnapshot(docSnap))
            .toList())
        .asBroadcastStream(onCancel: (sub) => sub.cancel());
  }

  static Future<List<OrdersSnapshot>> dsUserTuFirebaseOneTime(
      String idUser) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders")
        .get();
    return qs.docs
        .map((docSnap) => OrdersSnapshot.fromSnapshot(docSnap))
        .toList();
  }

  Future<void> updateOrderDetails(
      String orderId, List<OrderDetail> orderDetails, String userId) async {
    // Lấy đối tượng hóa đơn từ Firestore
    final orderSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Orders")
        .doc(orderId)
        .get();
    if (!orderSnapshot.exists) {
      throw Exception('Không tìm thấy hóa đơn với id $orderId');
    }

    // Tạo danh sách các Map chứa thông tin về OrderDetail
    final orderDetailMaps =
        orderDetails.map((orderDetail) => orderDetail.toJson()).toList();

    // Cập nhật trường OrderDetails của hóa đơn với danh sách mới
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'OrderDetails': orderDetailMaps,
    });
  }
}
