// ignore_for_file: library_private_types_in_public_api

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderScreenV3 extends StatefulWidget {
  final String tableId;

  const OrderScreenV3({super.key, required this.tableId});

  @override
  _OrderScreenV3State createState() => _OrderScreenV3State();
}

class _OrderScreenV3State extends State<OrderScreenV3> {
  var userId = "";
  Rx<Orders> orderTotal = Rx<Orders>(Orders());

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    CollectionReference ordersCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection("Orders");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.black)),
        title: Text(
          "Order Detail",
          style: textAppKanit,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5, top: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5, top: 7),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersCollection
            .where('TableId', isEqualTo: widget.tableId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders'),
            );
          }

          final orderDoc = snapshot.data!.docs.first;
          final orderId = orderDoc.id;
          final data = Orders.fromJson(orderDoc.data() as Map<String, dynamic>);
          orderTotal.value = data;

          final orderDetailCollection =
              ordersCollection.doc(orderId).collection('OrderDetail');

          return StreamBuilder<QuerySnapshot>(
            stream: orderDetailCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No order details'),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: ListView(
                        children: snapshot.data!.docs.map((doc) {
                          // Hiển thị thông tin chi tiết hóa đơn
                          final orderDetail =
                              OrderDetailSnapshot.fromSnapshot(doc);

                          return ListTile(
                            title: Text(
                                'Product ID: ${orderDetail.orderDetail!.NameProduct!}'),
                            subtitle: Text(
                                'Quantity: ${orderDetail.orderDetail!.Quantity!}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Row(
                    children: [
                      Text(
                        orderTotal.value.Total.toString(),
                        style: textAppKanitNormal,
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: bgBlack, width: 5.0),
                          ),
                          foregroundColor: bgBlack,
                          backgroundColor: bgWhite,
                          padding: const EdgeInsets.symmetric(
                              vertical: sButtonHeight)),
                      onPressed: () => Get.back(),
                      child: Text(
                        "Add Again",
                        style: textNormalQuicksanBold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: bgBlack, width: 5.0),
                          ),
                          foregroundColor: bgWhite,
                          backgroundColor: bgBlack,
                          padding: const EdgeInsets.symmetric(
                              vertical: sButtonHeight)),
                      onPressed: () {},
                      child: Text(
                        "Create Order",
                        style: textNormalQuicksanWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
