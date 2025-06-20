import 'package:client_user/controller/getorderdbcontroller.dart';
import 'package:client_user/modal/tables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenOrderV2 extends StatefulWidget {
  const ScreenOrderV2({super.key, required this.table});
  final Tables table;

  @override
  State<ScreenOrderV2> createState() => _ScreenOrderV2State();
}

class _ScreenOrderV2State extends State<ScreenOrderV2> {
  String userId = "";

  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(GetOrderController());
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    orderController.getOrderbyTableId(userId, widget.table.Id!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      body: Column(
        children: [
          // Hiển thị danh sách order
          Obx(() {
            if (orderController.order.isEmpty) {
              return const Text('No orders');
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: orderController.order.length,
              itemBuilder: (context, index) {
                final order = orderController.order[index].order;
                return ListTile(
                  title: Text('Order ID: ${order!.Id}'),
                  subtitle: Text('Table ID: ${order.TableId}'),
                  onTap: () {
                    // Gọi hàm để lấy danh sách order detail khi nhấp vào order
                    orderController.getOrderDetailById(userId, order.Id!);
                    // Hiển thị danh sách chi tiết hóa đơn
                    Get.dialog(
                      Dialog(
                        child: Column(
                          children: [
                            // Hiển thị danh sách chi tiết hóa đơn
                            Obx(() {
                              if (orderController.orderDetailItems.isEmpty) {
                                return const Text('No order details');
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    orderController.orderDetailItems.length,
                                itemBuilder: (context, index) {
                                  final orderDetail =
                                      orderController.orderDetailItems[index];
                                  return ListTile(
                                    title: Text(
                                        'Product ID: ${orderDetail.orderDetail!.IdProduct}'),
                                    subtitle: Text(
                                        'Quantity: ${orderDetail.orderDetail!.Quantity}'),
                                  );
                                },
                              );
                            }),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
