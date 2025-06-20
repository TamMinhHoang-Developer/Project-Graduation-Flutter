import 'package:client_user/controller/manage_orderv1controller.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenOrderV4 extends StatefulWidget {
  const ScreenOrderV4({super.key, required this.table});
  final Tables table;

  @override
  State<ScreenOrderV4> createState() => _ScreenOrderV4State();
}

class _ScreenOrderV4State extends State<ScreenOrderV4> {
  final OrderV2Controller orderController = Get.put(OrderV2Controller());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    orderController.getOrderDataFromFirestore(widget.table.Id!, userId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
                  final Orders order = orderController.order;
                  return Text(
                    'Order ID: ${order.Id ?? ''} ${order.Total}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 16),
              Obx(
                () {
                  final List<OrderDetail> orderDetails =
                      orderController.orderDetailList;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderDetails.length,
                    itemBuilder: (context, index) {
                      final OrderDetail orderDetail = orderDetails[index];
                      return ListTile(
                        title: Text(orderDetail.NameProduct!),
                        subtitle: Text('Quantity: ${orderDetail.Quantity}'),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
