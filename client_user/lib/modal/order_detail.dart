// ignore_for_file: non_constant_identifier_names

import 'package:client_user/modal/products.dart';
import 'package:client_user/modal/tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderDetail {
  String? Unit, IdProduct, NameProduct, Id, OrderId;
  int? Price, Quantity;

  OrderDetail(
      {this.IdProduct,
      this.NameProduct,
      this.Price,
      this.Quantity,
      this.Unit,
      this.Id,
      this.OrderId});

  // hàm tạo từ Json object
  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
        Unit: json['Unit'],
        IdProduct: json['IdProduct'],
        NameProduct: json['NameProduct'],
        Price: json['Price'],
        Quantity: json['Quantity'],
        Id: json['Id'],
        OrderId: json['OrderId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Unit': Unit,
      'IdProduct': IdProduct,
      'NameProduct': NameProduct,
      'Price': Price,
      'Quantity': Quantity,
      'Id': Id,
      'OrderId': OrderId
    };
  }
}

class OrderDetailSnapshot {
  OrderDetail? orderDetail;
  DocumentReference? documentReference;

  OrderDetailSnapshot({
    required this.orderDetail,
    required this.documentReference,
  });

  factory OrderDetailSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return OrderDetailSnapshot(
        orderDetail:
            OrderDetail.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }

  static Future<void> themMoiAutoId(
      OrderDetail order, String idUser, String idOrder) async {
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection("Orders")
        .doc(idOrder)
        .collection("OrderDetail");
    DocumentReference newDocRef = usersRef.doc();
    order.Id = newDocRef.id;
    order.OrderId = idOrder;
    await newDocRef.set(order.toJson());
  }

  static Stream<List<OrderDetailSnapshot>> getListOrder(
      String idUser, String orderId) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Orders")
        .doc(orderId)
        .collection("OrderDetail")
        .snapshots();

    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);

    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => OrderDetailSnapshot.fromSnapshot(docSnap))
        .toList());
  }
}

class OrderDetailLocal {
  Products? products;
  RxInt Quantity;
  Tables? tables;

  OrderDetailLocal({this.products, int Quantity = 0, this.tables})
      : Quantity = Quantity.obs;
}

class OrderDetailFireBase {
  String? Unit, IdProduct, NameProduct, Id, OrderId;
  RxInt Quantity;
  int? Price;

  OrderDetailFireBase(
      {this.IdProduct,
      this.NameProduct,
      this.Price,
      int Quantity = 0,
      this.Unit,
      this.Id,
      this.OrderId})
      : Quantity = Quantity.obs;
}
