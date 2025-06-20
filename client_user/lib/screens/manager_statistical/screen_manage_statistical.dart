// ignore_for_file: avoid_print
import 'package:client_user/controller/history_order_controller.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/controller/manage_seller.dart';
import 'package:client_user/screens/manager_statistical/component/chart_statis.dart';
import 'package:client_user/screens/manager_statistical/component/overview_dashboard.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScreenManageStatistical extends StatefulWidget {
  const ScreenManageStatistical({super.key});

  @override
  State<ScreenManageStatistical> createState() =>
      _ScreenManageStatisticalState();
}

class _ScreenManageStatisticalState extends State<ScreenManageStatistical>
    with TickerProviderStateMixin {
  final controller = Get.put(HistoryOrderV2Controller());
  final sellerController = Get.put(ManageSellerController());
  final homeController = Get.put(HomeController());
  late Future<void> initFuture;
  var userId = "";

  @override
  void initState() {
    super.initState();
    initFuture = initializeData();
  }

  Future<void> initializeData() async {
    await controller.checkCurrenMonth();
    await controller.checkOldMonth();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.checkCurrenMonth();
    controller.checkOldMonth();
    homeController.checkTotalHistory(userId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.black)),
          title: Text(
            "DashBoard T${DateTime.now().month}",
            style: textAppKanit,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (homeController.totalHistory > 0) {
                return Column(
                  children: [
                    const OverviewDashboard(),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Obx(() {
                              if (controller.totalPaymentByMonth(
                                          DateTime.now().month) !=
                                      0 ||
                                  controller.totalPaymentByMonth(
                                          DateTime.now().month - 1) !=
                                      0) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () => Text(
                                        "Total Price (${((controller.totalPaymentByMonth(DateTime.now().month) - controller.totalPaymentByMonth(DateTime.now().month - 1)) / controller.totalPaymentByMonth(DateTime.now().month) + controller.totalPaymentByMonth(DateTime.now().month - 1)) * 100}%)",
                                        style: textCouterKanitSmail,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: Obx(() => Text(
                                                  controller
                                                      .totalPaymentByMonth(
                                                          DateTime.now().month)
                                                      .toString(),
                                                  style: textAppKanitRed.apply(
                                                    color: controller
                                                                .totalPaymentByMonth(
                                                                    DateTime.now()
                                                                        .month) >
                                                            controller
                                                                .totalPaymentByMonth(
                                                                    DateTime.now()
                                                                            .month -
                                                                        1)
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ),
                                          Icon(
                                            controller.totalPaymentByMonth(
                                                        DateTime.now().month) >
                                                    controller
                                                        .totalPaymentByMonth(
                                                            DateTime.now()
                                                                    .month -
                                                                1)
                                                ? Icons.arrow_outward
                                                : Icons.arrow_downward,
                                            color: controller
                                                        .totalPaymentByMonth(
                                                            DateTime.now()
                                                                .month) >
                                                    controller
                                                        .totalPaymentByMonth(
                                                            DateTime.now()
                                                                    .month -
                                                                1)
                                                ? Colors.green
                                                : Colors.red,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Column(
                              children: [
                                Text(
                                  "Product Pay",
                                  style: textCouterKanitSmail,
                                ),
                                Text(
                                  controller.countSoldProducts.toString(),
                                  style: textAppKanit,
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.5))),
                        child: Obx(() => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Price in Month: ",
                                      style: textCouterKanit,
                                    ),
                                    Text(
                                      "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(controller.totalPaymentByMonth(DateTime.now().month))}VND",
                                      style: textAppKanitRed,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Employee Salary: ",
                                      style: textCouterKanit,
                                    ),
                                    Text(
                                      "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(sellerController.calculateTotalSalary())}VND",
                                      style: textAppKanitRed,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total Month: ",
                                      style: textCouterKanit,
                                    ),
                                    Text(
                                      "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(controller.totalPaymentByMonth(DateTime.now().month) - sellerController.calculateTotalSalary())}VND",
                                      style: textAppKanitRed,
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ChartStatistical(),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    "Please setup and generate invoices to use the statistics function",
                    style: textAppKanit,
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
