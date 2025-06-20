// ignore_for_file: avoid_print

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:dasboard_admin/controllers/message_helper.dart';
import 'package:dasboard_admin/controllers/new_controller.dart';
import 'package:dasboard_admin/controllers/ticket_controller.dart';
import 'package:dasboard_admin/controllers/total_controller.dart';
import 'package:dasboard_admin/controllers/waltinguser_controller.dart';
import 'package:dasboard_admin/screens/dashboard/components/indicator.dart';
import 'package:dasboard_admin/screens/manager_news/screen_news.dart';
import 'package:dasboard_admin/screens/manager_ticket/screen_ticket_overview.dart';
import 'package:dasboard_admin/screens/manager_user/manager_walting/screen_user_wailting.dart';
import 'package:dasboard_admin/screens/manager_user/screen_user_overview.dart';
import 'package:dasboard_admin/screens/profile/screen_profile.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:dasboard_admin/widgets/components/card_custom.dart';
import 'package:dasboard_admin/widgets/components/list_tile_custom.dart';
import 'package:dasboard_admin/widgets/coupon_card/horizontal_cupon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:badges/badges.dart' as badges;

class ScreenDashboard extends StatefulWidget {
  const ScreenDashboard({super.key});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard> {
  late double width = 7;
  int touchedIndex = -1;
  var count = 0;
  int touchedbarIndex = -1;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late int showingTooltip = -1;

  int _currentIndex = 0;
  int touchedGroupIndex = -1;
  List<Color> gradientColors = [
    Colors.greenAccent,
    Colors.black,
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    showingTooltip = -1;

    // Get Total Message
    MessageHelper.getCountMessage().then((value) {
      setState(() {
        if (count > 0) {
          count = 0;
        } else {
          count = value;
        }
      });
    });

    // Handler Tap Notification
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      MessageHelper.fcmOpenMessageHandler(
          message: remoteMessage,
          context: context,
          messageHandler: (context, message) {
            // Điều hướng đến trang hiển thị chi tiết thông báo.
            Get.to(() => const ScreenNews());
          });
    });

    // Handler Tap In Terminal
    FirebaseMessaging.instance.getInitialMessage().then((value) => {
          if (value != null)
            {
              MessageHelper.fcmOpenMessageHandler(
                  message: value,
                  context: context,
                  messageHandler: (context, message) {
                    // Điều hướng đến trang hiển thị chi tiết thông báo.
                    if (FirebaseAuth.instance.currentUser != null) {
                      Get.to(() => const ScreenNews());
                    } else {
                      Get.to(() => const ScreenDashboard());
                    }
                  })
            }
        });

    FirebaseMessaging.onMessage.listen((event) {
      MessageHelper.fcm_ForegroundHandler(
          message: event,
          context: context,
          messageHandler: (context, message) {
            MessageHelper.getCountMessage().then((value) {
              setState(() {
                count = value;
              });
            });
          });
    });
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y.toDouble()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //final cu = Get.find<TotalController>(tag: "dsuser");
    // ignore: unused_local_variable
    final cu = Get.put(TotalController());
    final controller = Get.put(ManageNewsController());

    final wail = Get.put(WaltingUserController());
    wail.countMyDocuments();
    wail.countMyDocumentsWithStatusFalse();
    wail.countMyDocumentsWithStatusTrue();
    cu.updateTotalCounts();
    controller.getListNews();

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomNavBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 6,
                  color: sparatorColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Hello ${FirebaseAuth.instance.currentUser?.email}",
                              style: headerUser,
                            ),
                            // badges.Badge(
                            //   badgeContent: Text(
                            //     "$count",
                            //     style: textNormalQuicksanBold,
                            //   ),
                            //   showBadge: count > 0,
                            //   badgeStyle: const badges.BadgeStyle(
                            //       badgeColor: Colors.red),
                            //   child: IconButton(
                            //     onPressed: () {},
                            //     icon: const Icon(Icons.notifications),
                            //     color: Colors.black,
                            //   ),
                            // )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Sumary",
                            style: textBigKanit,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Obx(
                              () => GestureDetector(
                                onTap: () =>
                                    {Get.to(() => const UserOverviewScreen())},
                                child: CardCustom(
                                  width: size.width / 2 - 23,
                                  height: 88.9,
                                  mLeft: 0,
                                  mRight: 3,
                                  child: ListTileCustom(
                                    bgColor: purpleLight,
                                    pathIcon: "line.svg",
                                    title: "ALL USER",
                                    subTitle: cu
                                        .countMyDocuments(cu.users)
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => GestureDetector(
                                onTap: () =>
                                    {Get.to(() => const ScreenUserWalting())},
                                child: CardCustom(
                                  width: size.width / 2 - 23,
                                  height: 88.9,
                                  mLeft: 3,
                                  mRight: 0,
                                  child: ListTileCustom(
                                    bgColor: greenLight,
                                    pathIcon: "thumb_up.svg",
                                    title: "WALTING",
                                    subTitle: cu.countAdults(false).toString(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Obx(
                            //   () => GestureDetector(
                            //     onTap: () => {
                            //       Get.to(() => const TicketOverviewScreen())
                            //     },
                            //     child: CardCustom(
                            //       width: size.width / 2 - 23,
                            //       height: 88.9,
                            //       mLeft: 0,
                            //       mRight: 3,
                            //       child: ListTileCustom(
                            //         bgColor: yellowLight,
                            //         pathIcon: "starts.svg",
                            //         title: "TICKET",
                            //         subTitle: ti
                            //             .countMyDocuments(ti.ticketList)
                            //             .toString(),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Obx(
                              () => GestureDetector(
                                onTap: () => {Get.to(() => const ScreenNews())},
                                child: CardCustom(
                                  width: size.width / 2 - 23,
                                  height: 88.9,
                                  mLeft: 3,
                                  mRight: 0,
                                  child: ListTileCustom(
                                    bgColor: blueLight,
                                    pathIcon: "eyes.svg",
                                    title: "NEWS",
                                    subTitle: controller.news.length.toString(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          // ignore: sized_box_for_whitespace
                          child: Text(
                            "Overview",
                            style: textBigKanit,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CardCustom(
                            mLeft: 0,
                            mRight: 0,
                            width: size.width - 40,
                            height: 255,
                            child: AspectRatio(
                              aspectRatio: 1.3,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 28,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Indicator(
                                        color:
                                            Colors.greenAccent.withOpacity(0.3),
                                        text: 'Active',
                                        isSquare: false,
                                        size: touchedIndex == 0 ? 18 : 16,
                                        textColor: touchedIndex == 0
                                            ? Colors.greenAccent
                                                .withOpacity(0.3)
                                            : Colors.greenAccent
                                                .withOpacity(0.3),
                                      ),
                                      Indicator(
                                        color:
                                            Colors.blueAccent.withOpacity(0.3),
                                        text: 'Walting',
                                        isSquare: false,
                                        size: touchedbarIndex == 1 ? 18 : 16,
                                        textColor: touchedbarIndex == 1
                                            ? Colors.blueAccent.withOpacity(0.3)
                                            : Colors.blueAccent
                                                .withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Obx(() => PieChart(
                                            PieChartData(
                                              pieTouchData: PieTouchData(
                                                touchCallback:
                                                    (FlTouchEvent event,
                                                        pieTouchResponse) {
                                                  setState(() {
                                                    if (!event
                                                            .isInterestedForInteractions ||
                                                        pieTouchResponse ==
                                                            null ||
                                                        pieTouchResponse
                                                                .touchedSection ==
                                                            null) {
                                                      touchedIndex = -1;
                                                      touchedbarIndex = -1;
                                                      return;
                                                    }
                                                    touchedIndex =
                                                        pieTouchResponse
                                                            .touchedSection!
                                                            .touchedSectionIndex;
                                                  });
                                                },
                                              ),
                                              startDegreeOffset: 180,
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 1,
                                              centerSpaceRadius: 0,
                                              sections: showingSections(),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        CardCustom(
                            mLeft: 0,
                            mRight: 0,
                            width: size.width - 40,
                            height: 235,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Indicator(
                                        color: Colors.blueAccent,
                                        text: 'Total',
                                        isSquare: false,
                                        size: touchedIndex == 1 ? 14 : 12,
                                        textColor: touchedIndex == 1
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                // Bar Cusstom
                                SizedBox(
                                  width: 340,
                                  height: 150,
                                  child: AspectRatio(
                                      aspectRatio: 2,
                                      child: Obx(() => BarChart(BarChartData(
                                              barGroups: [
                                                generateGroupData(
                                                    1,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        1)),
                                                generateGroupData(
                                                    2,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        2)),
                                                generateGroupData(
                                                    3,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        3)),
                                                generateGroupData(
                                                    4,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        4)),
                                                generateGroupData(
                                                    5,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        5)),
                                                generateGroupData(
                                                    6,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        6)),
                                                generateGroupData(
                                                    7,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        7)),
                                                generateGroupData(
                                                    8,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        8)),
                                                generateGroupData(
                                                    9,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        9)),
                                                generateGroupData(
                                                    10,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        10)),
                                                generateGroupData(
                                                    11,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        11)),
                                                generateGroupData(
                                                    12,
                                                    cu.countUsersInMonth(
                                                        cu.users,
                                                        DateTime.now().year,
                                                        12)),
                                              ],
                                              barTouchData: BarTouchData(
                                                  enabled: true,
                                                  handleBuiltInTouches: false,
                                                  touchCallback:
                                                      (event, response) {
                                                    if (response != null &&
                                                        response.spot != null &&
                                                        event is FlTapUpEvent) {
                                                      setState(() {
                                                        final x = response.spot!
                                                            .touchedBarGroup.x;
                                                        final isShowing =
                                                            showingTooltip == x;
                                                        if (isShowing) {
                                                          showingTooltip = -1;
                                                        } else {
                                                          showingTooltip = x;
                                                        }
                                                      });
                                                    }
                                                  },
                                                  mouseCursorResolver:
                                                      (event, response) {
                                                    return response == null ||
                                                            response.spot ==
                                                                null
                                                        ? MouseCursor.defer
                                                        : SystemMouseCursors
                                                            .click;
                                                  }))))),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //* Define Panigator
  Widget _bottomNavBar() => SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          print(_currentIndex);
          if (_currentIndex == 1) {
            Get.to(() => const ScreenProfile());
          }
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.greenAccent.withOpacity(0.5),
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Setting"),
            selectedColor: Colors.grey,
          ),
        ],
      );
  List<PieChartSectionData> showingSections() {
    final cu = Get.put(TotalController());
    cu.updateTotalCounts();
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.greenAccent.withOpacity(0.3),
              value: double.parse(cu.totalUserActive.value.toString()),
              title: '',
              radius: 80,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: Colors.greenAccent, width: 6)
                  : BorderSide(color: Colors.greenAccent.withOpacity(0.2)),
            );
          case 1:
            return PieChartSectionData(
              color: Colors.blueAccent.withOpacity(0.3),
              value: double.parse(cu.totalUserWalting.value.toString()),
              title: '',
              radius: 65,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(color: Colors.blue, width: 6)
                  : BorderSide(color: Colors.greenAccent.withOpacity(0.2)),
            );

          default:
            throw Error();
        }
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('MON', style: style);
        break;
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.blueAccent.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.blueAccent.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
