// ignore_for_file: avoid_print

import 'dart:async';

import 'package:client_user/modal/order_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HistoryOrderV2Controller extends GetxController {
  final RxList<OrdersHistory> orderDetailList = RxList<OrdersHistory>([]);

  final currentMonth = 0.0.obs;
  final oldMonth = 0.0.obs;
  final tottalProducts = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      bindOrdersHistoryStream(FirebaseAuth.instance.currentUser!.uid);
    }

    checkCurrenMonth();
    checkOldMonth();
  }

  checkCurrenMonth() {
    currentMonth.value = totalPaymentByMonth(DateTime.now().month).toDouble();
  }

  checkOldMonth() {
    oldMonth.value = totalPaymentByMonth(DateTime.now().month - 1).toDouble();
  }

  void bindOrdersHistoryStream(id) {
    final collectionRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('OrdersHistory')
        .orderBy("PaymentTime", descending: true);

    collectionRef.snapshots().listen((querySnapshot) {
      final List<OrdersHistory> historyList = querySnapshot.docs
          .map((doc) => OrdersHistory.fromJson(doc.data()))
          .toList();
      orderDetailList.value = historyList;
    });
  }

  double totalPaymentByYear(int year) {
    double totalRevenue = 0;
    for (int month = 1; month <= 12; month++) {
      List<OrdersHistory> monthOrders = orderDetailList.where((order) {
        DateTime orderTime =
            DateTime.fromMillisecondsSinceEpoch(order.PaymentTime!);
        return orderTime.year == year && orderTime.month == month;
      }).toList();

      double monthRevenue =
          monthOrders.fold(0, (sum, order) => sum + order.order!.Total!);
      totalRevenue += monthRevenue;
      print("Count $month: $monthRevenue");
    }

    print("Total payment in $year: $totalRevenue");
    return totalRevenue;
  }

  double get totalPayment {
    double total = 0.0;
    for (final orderHistory in orderDetailList) {
      if (orderHistory.orderDetail != null) {
        for (final orderDetail in orderHistory.orderDetail!) {
          total += orderDetail.Price! * orderDetail.Quantity!;
        }
      }
    }
    return total;
  }

  int get countSoldProducts {
    int count = 0;
    for (final order in orderDetailList) {
      if (order.orderDetail!.isNotEmpty) {
        count += order.orderDetail!.length;
      }
    }
    return count;
  }

  double totalPaymentByMonth(int month) {
    List<OrdersHistory> currentMonthOrders = orderDetailList.where((order) {
      DateTime orderTime =
          DateTime.fromMillisecondsSinceEpoch(order.PaymentTime!);
      return orderTime.month == month;
    }).toList();

    double totalRevenue =
        currentMonthOrders.fold(0, (sum, order) => sum + order.order!.Total!);
    print("Count $month $totalRevenue");
    return totalRevenue;
  }

  double getTotalPaymentByMonth(int month, int year) {
    double total = 0.0;
    for (final orderHistory in orderDetailList) {
      final createdAt = orderHistory.order!.CreateDate;
      final orderMonth = DateTime.fromMillisecondsSinceEpoch(createdAt!).month;
      final orderYear = DateTime.fromMillisecondsSinceEpoch(createdAt).year;

      if (orderMonth == month && orderYear == year) {
        if (orderHistory.orderDetail != null) {
          for (final orderDetail in orderHistory.orderDetail!) {
            total += orderDetail.Price! * orderDetail.Quantity!;
          }
        }
      }
    }
    return total;
  }
}


// import 'package:intl/intl.dart';

// class OrdersHistoryScreen extends StatelessWidget {
//   final OrdersHistoryController _controller = Get.put(OrdersHistoryController());
//   final DateTime now = DateTime.now();
//   final int month = DateTime.now().month;
//   final int year = DateTime.now().year;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders History'),
//       ),
//       body: Column(
//         children: [
//           Text(
//             'Total Payment for ${DateFormat('MMMM yyyy').format(now)}: \$${_controller.getTotalPaymentByMonth(month, year).toStringAsFixed(2)}',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           Obx(() {
//             final ordersHistoryList = _controller.ordersHistoryList;
//             if (ordersHistoryList.isEmpty) {
//               return Center(child: Text('No orders history available.'));
//             }
//             return Expanded(
//               child: ListView.builder(
//                 itemCount: ordersHistoryList.length,
//                 itemBuilder: (context, index) {
//                   final orderHistory = ordersHistoryList[index];
//                   // Hiển thị thông tin của orderHistory
//                   return ListTile(
//                     title: Text(orderHistory.orderName),
//                     subtitle: Text(orderHistory.orderStatus),
//                     // ...
//                   );
//                 },
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
