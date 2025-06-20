import 'package:client_user/controller/history_order_controller.dart';
import 'package:client_user/screens/manage_history/components/item_history_order.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScreenHistory extends StatefulWidget {
  const ScreenHistory({super.key});

  @override
  State<ScreenHistory> createState() => _ScreenHistoryState();
}

class _ScreenHistoryState extends State<ScreenHistory> {
  final historyController = Get.put(HistoryOrderV2Controller());
  var userId = "";
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    historyController.bindOrdersHistoryStream(userId);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: Colors.black)),
          title: Text(
            "History Order",
            style: textAppKanit,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Obx(() => Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.8,
                      width: size.width - 40,
                      child: ListView.builder(
                        itemCount: historyController.orderDetailList.length,
                        itemBuilder: (context, index) {
                          final isExpanded = index == _expandedIndex;
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: ExpandableNotifier(
                              child: ScrollOnExpand(
                                child: ExpandablePanel(
                                  collapsed: Container(),
                                  header: Builder(
                                    builder: (context) {
                                      var controller =
                                          ExpandableController.of(context);
                                      return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order history',
                                                  style:
                                                      textSmailQuicksanBoldGray,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    "#${historyController.orderDetailList[index].Id}",
                                                    style:
                                                        textNormalQuicksanBold,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              DateFormat('MMM dd').format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                  historyController
                                                      .orderDetailList[index]
                                                      .PaymentTime!,
                                                ),
                                              ),
                                              style: textNormalQuicksanBold,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (isExpanded) {
                                              _expandedIndex = -1;
                                            } else {
                                              _expandedIndex = index;
                                            }
                                          });
                                          controller!.toggle();
                                        },
                                      );
                                    },
                                  ),
                                  expanded: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (historyController
                                                .orderDetailList[index]
                                                .orderDetail !=
                                            null)
                                          SingleChildScrollView(
                                            child: SizedBox(
                                              height: 150,
                                              width: size.width * 0.9,
                                              child: ListView.builder(
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index2) {
                                                  final his = historyController
                                                      .orderDetailList[index]
                                                      .orderDetail![index2];
                                                  return SizedBox(
                                                    child: ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            his.NameProduct
                                                                .toString(),
                                                            style:
                                                                textNormalQuicksanBold,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${his.Quantity.toString()} x ",
                                                                style:
                                                                    textNormalQuicksanBold,
                                                              ),
                                                              Text(
                                                                "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(his.Price)}VND",
                                                                style:
                                                                    textNormalQuicksanBold,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: historyController
                                                    .orderDetailList[index]
                                                    .orderDetail!
                                                    .length,
                                              ),
                                            ),
                                          )
                                        else
                                          const Text('No Sub Data'),
                                        Container(
                                          color: Colors.grey.withOpacity(0.4),
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total',
                                                style: textNormalQuicksanBold,
                                              ),
                                              Text(
                                                '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(historyController.orderDetailList[index].order!.Total)}VND',
                                                style: textAppSmailKanitRed,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Payment menthod',
                                                style: textQuicksanGrayItatic,
                                              ),
                                              Text(
                                                historyController
                                                    .orderDetailList[index]
                                                    .PaymentMenthod!,
                                                style: textQuicksanItaticBold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
