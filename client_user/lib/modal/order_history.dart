// ignore_for_file: non_constant_identifier_names

import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersHistory {
  String? Id, PaymentMenthod;
  Orders? order;
  List<OrderDetail>? orderDetail;
  int? PaymentTime;

  OrdersHistory({
    this.Id,
    this.order,
    this.PaymentMenthod,
    this.orderDetail,
    this.PaymentTime,
  });

  factory OrdersHistory.fromJson(Map<String, dynamic> json) {
    return OrdersHistory(
      Id: json['Id'],
      PaymentMenthod: json['PaymentMethod'],
      order: Orders.fromJson(json['order']),
      orderDetail: parseOrderDetails(json['orderDetail']),
      PaymentTime: json['PaymentTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'PaymentMethod': PaymentMenthod,
      'order': order?.toJson(),
      'orderDetail': orderDetail?.map((detail) => detail.toJson()).toList(),
      'PaymentTime': PaymentTime,
    };
  }

  static List<OrderDetail>? parseOrderDetails(orderDetailsJson) {
    if (orderDetailsJson != null) {
      var list = orderDetailsJson as List;
      return list.map((detail) => OrderDetail.fromJson(detail)).toList();
    }
    return null;
  }
}

class OrderHistorySnapshot {
  OrdersHistory? orderHistory;
  DocumentReference? documentReference;

  OrderHistorySnapshot({
    required this.orderHistory,
    required this.documentReference,
  });

  factory OrderHistorySnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return OrderHistorySnapshot(
        orderHistory:
            OrdersHistory.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }

  static Future<void> themMoiAutoId(
      OrdersHistory orderHistory, String idUser) async {
    // Add
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection("OrdersHistory");
    DocumentReference newDocRef = usersRef.doc();
    orderHistory.Id = newDocRef.id;
    await newDocRef.set(orderHistory.toJson());

    // Change status Tables
    CollectionReference tablesRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection('Tables');
    QuerySnapshot tableQuerySnapshot = await tablesRef
        .where('Id', isEqualTo: orderHistory.order!.TableId)
        .get();
    DocumentSnapshot tableSnapshot = tableQuerySnapshot.docs.first;
    DocumentReference tableDocRef = tablesRef.doc(tableSnapshot.id);
    tableDocRef.update({'Status': 'Normal'});

    // Xóa Order
    if (orderHistory.order != null) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(idUser)
          .collection('Orders')
          .doc(orderHistory.order!.Id)
          .delete()
          // ignore: avoid_print
          .then((value) => print("Delete successful"))
          // ignore: avoid_print
          .catchError((error) => print("Failed to delete document: $error"));
    } else {
      // ignore: avoid_print
      print("No Data Order In His");
    }
  }

  static Future<void> deleteCollectionAndSubcollections(
      String collectionPath) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionPath);

    final QuerySnapshot subCollectionSnapshot =
        await collectionRef.get(); // Lấy tất cả các document trong collection

    // Xóa tất cả các document trong sub-collection
    final List<Future<void>> deleteFutures = [];
    // ignore: avoid_function_literals_in_foreach_calls
    subCollectionSnapshot.docs.forEach((doc) {
      final DocumentReference docRef = collectionRef.doc(doc
          .id); // Đối tượng DocumentReference của document trong sub-collection
      final CollectionReference subCollectionRef = docRef.collection(
          'OrderDetail'); // Thay 'OrderDetail' bằng tên của sub-collection của bạn
      deleteFutures.add(subCollectionRef.doc().delete());
    });

    // Đợi cho tất cả các tác vụ xóa trong sub-collection hoàn thành
    await Future.wait(deleteFutures);

    // Xóa collection chính
    await collectionRef.doc().delete();
  }

  static Stream<List<OrderHistorySnapshot>> getListOrderHistory(String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("OrdersHistory")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => OrderHistorySnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<List<OrdersSnapshot>> getListOrderHistoryOneTime(
      String idUser) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("OrdersHistory")
        .get();
    return qs.docs
        .map((docSnap) => OrdersSnapshot.fromSnapshot(docSnap))
        .toList();
  }
}
