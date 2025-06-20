// ignore_for_file: avoid_unnecessary_containers

import 'package:client_user/controller/manage_orderv3controller.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartOrder extends StatefulWidget {
  const CartOrder({super.key, required this.order});
  final Orders order;

  @override
  State<CartOrder> createState() => _CartOrderState();
}

class _CartOrderState extends State<CartOrder> {
  final OrderV2sController orderController = Get.put(OrderV2sController());
  late DateTime tsdate;
  @override
  Widget build(BuildContext context) {
    if (widget.order.CreateDate != null) {
      tsdate = DateTime.fromMillisecondsSinceEpoch(widget.order.CreateDate!);
    } else {
      tsdate = DateTime.fromMillisecondsSinceEpoch(100);
    }

    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA3014F).withOpacity(0.05),
              offset: const Offset(0, 9),
              blurRadius: 30,
              spreadRadius: 0,
            ),
            BoxShadow(
                color: const Color(0xFFB2036C).withOpacity(0.03),
                offset: const Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(Icons.monetization_on_outlined),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 230,
                          child: Text("Order #${widget.order.Id ?? "No Data"}",
                              style: textNormalKanitBold,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 230,
                          child: Text(widget.order.TableName ?? "No Data",
                              style: textNormalQuicksan,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(
            height: 2,
            color: Colors.grey[400],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        "BALANCE",
                        style: textNormalKanit,
                      ),
                      Obx(() => Text(
                            "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(orderController.totalPrice)}VND",
                            style: textAppKanitRed,
                          ))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "date created".toUpperCase(),
                        style: textNormalKanit,
                      ),
                      Text(
                        DateFormat('dd/MM').format(tsdate),
                        style: textAppKanit,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
