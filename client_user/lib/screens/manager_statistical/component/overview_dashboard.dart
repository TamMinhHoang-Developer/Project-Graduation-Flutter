import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewDashboard extends StatefulWidget {
  const OverviewDashboard({
    super.key,
  });

  @override
  State<OverviewDashboard> createState() => _OverviewDashboardState();
}

class _OverviewDashboardState extends State<OverviewDashboard> {
  var userId = "";
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.checkTotalHistory(userId);
    controller.checkTotalProduct(userId);
    controller.checkTotalSeller(userId);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            height: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), color: sinbad),
                    child: const Icon(
                      Icons.done,
                      weight: 800,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.totalHistory.value.toString(),
                          style: textCouterKanit,
                        )),
                    Text(
                      "Order Complete",
                      style: textNormalQuicksan,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: 170,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.totalProduct.toString(),
                              style: textCouterKanit,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Products',
                              style: textNormalQuicksan,
                            )
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blueAccent.withOpacity(0.8)),
                            child: const Icon(
                              Icons.album_outlined,
                              weight: 800,
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.totalSeller.toString(),
                              style: textCouterKanit,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Seller',
                              style: textNormalQuicksan,
                            )
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.amber),
                            child: const Icon(
                              Icons.people,
                              weight: 800,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
