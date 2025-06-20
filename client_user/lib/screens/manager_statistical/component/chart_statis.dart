import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:client_user/controller/history_order_controller.dart';
import 'package:client_user/screens/manager_statistical/component/bar_chart.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartStatistical extends StatefulWidget {
  const ChartStatistical({
    super.key,
  });

  @override
  State<ChartStatistical> createState() => _ChartStatisticalState();
}

class _ChartStatisticalState extends State<ChartStatistical> {
  var userId = "";
  final controller = Get.put(HistoryOrderV2Controller());
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    controller.bindOrdersHistoryStream(userId);

    return SizedBox(
      height: 400,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orders",
                  style: textAppKanit,
                ),
                SizedBox(
                  child: ButtonsTabBar(
                    backgroundColor: Colors.black,
                    unselectedBackgroundColor: Colors.white,
                    labelStyle: GoogleFonts.quicksand().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    unselectedLabelStyle: GoogleFonts.quicksand().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    unselectedBorderColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: "Monthy",
                      ),
                      Tab(
                        text: "Year",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const BarChartSample4(),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Obx(() => DChartBar(
                                data: [
                                  {
                                    'id': 'Bar',
                                    'data': [
                                      {
                                        'domain': (DateTime.now().year - 3)
                                            .toString(),
                                        'measure': controller
                                            .totalPaymentByYear(
                                                DateTime.now().year - 3)
                                            .toDouble()
                                      },
                                      {
                                        'domain': (DateTime.now().year - 2)
                                            .toString(),
                                        'measure': controller
                                            .totalPaymentByYear(
                                                DateTime.now().year - 2)
                                            .toDouble()
                                      },
                                      {
                                        'domain': (DateTime.now().year - 1)
                                            .toString(),
                                        'measure': controller
                                            .totalPaymentByYear(
                                                DateTime.now().year - 1)
                                            .toDouble()
                                      },
                                      {
                                        'domain':
                                            (DateTime.now().year).toString(),
                                        'measure': controller
                                            .totalPaymentByYear(
                                                DateTime.now().year)
                                            .toDouble()
                                      },
                                    ],
                                  },
                                ],
                                domainLabelPaddingToAxisLine: 16,
                                axisLineTick: 2,
                                axisLinePointTick: 2,
                                axisLinePointWidth: 2,
                                axisLineColor: Colors.black,
                                measureLabelPaddingToAxisLine: 2,
                                barColor: (barData, index, id) => Colors.black,
                                showBarValue: true,
                                showDomainLine: true,
                                showMeasureLine: true,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
