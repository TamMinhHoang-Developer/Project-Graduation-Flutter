import 'package:client_user/controller/history_order_controller.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarChartSample4 extends StatefulWidget {
  const BarChartSample4({super.key});

  final Color dark = AppColors.contentColorCyan;
  final Color normal = Colors.red;
  final Color light = Colors.blueAccent;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  var userId = "";
  final controller = Get.put(HistoryOrderV2Controller());
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    // 1
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    return AspectRatio(
      aspectRatio: 1.66,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barsSpace = 4.0 * constraints.maxWidth / 400;
          final barsWidth = 8.0 * constraints.maxWidth / 400;
          return Obx(() => BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData:
                          BarTouchTooltipData(tooltipBgColor: Colors.blueGrey)),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: bottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 10 == 0,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.yellow.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: true,
                  ),
                  borderData: FlBorderData(
                    show: true,
                  ),
                  groupsSpace: 20,
                  barGroups: getData(barsWidth, barsSpace),
                ),
              ));
        },
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(1), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(2), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(3), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(4), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(5), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(6), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(7), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 7,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(8), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 8,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(9), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 9,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(10), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 10,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(11), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 11,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            color: Colors.transparent,
            toY: 10000000,
            rodStackItems: [
              BarChartRodStackItem(
                  0, controller.totalPaymentByMonth(12), widget.dark),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
}
