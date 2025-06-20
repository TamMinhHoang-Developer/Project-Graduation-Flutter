// ignore_for_file: avoid_print, duplicate_ignore, non_constant_identifier_names, constant_identifier_names

import 'dart:convert';

import 'package:client_user/constants/string_context.dart';
import 'package:client_user/controller/manage_history_order_controller.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/order_history.dart';
import 'package:client_user/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

// ignore: must_be_immutable
class ModalBottomPayment extends StatefulWidget {
  ModalBottomPayment({super.key, required this.order, required this.listOrder});

  Orders order;
  final List<OrderDetail> listOrder;

  @override
  State<ModalBottomPayment> createState() => _ModalBottomPaymentState();
}

class _ModalBottomPaymentState extends State<ModalBottomPayment> {
  Map<String, dynamic>? paymentIntent;
  var userId = "";
  String responseCode = '';
  String zpTransToken = "";
  String payResult = "";
  String payAmount = "10000";
  bool showResult = false;
  final SECRET_KEY =
      "sk_test_51NErBXGDIUTvV4PmuelNiZh2h5jdmS0cChahzQU6sHbBhc8Tech0IOHFhtFmqJps1seWr3qHlwepm2GYDx2B3P5y00GStQ5oQ0";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    final orderHistoryController = Get.put(ManageHistoryOrderController());

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tPaymentOrderTitle,
              style: textBigKanit,
            ),
            Text(
              tPaymentOrderDes,
              style: textNormalQuicksan,
            ),
            // const SizedBox(
            //   height: 30,
            // ),
            // ForgetPasswordBtnWidget(
            //   btnIcon: Icons.qr_code,
            //   title: tPaymentQRCodeOption,
            //   subTitle: tPaymentQRCodeOptionDes,
            //   onTap: () {},
            // ),
            const SizedBox(
              height: 20,
            ),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.payment,
              title: tPaymentCashOption,
              subTitle: tPaymentCashOptionDes,
              onTap: () {
                final order = OrdersHistory(
                    Id: "",
                    order: widget.order,
                    PaymentMenthod: "Cash",
                    orderDetail: widget.listOrder,
                    PaymentTime: convertInputDateTimetoNumber(DateTime.now()));
                orderHistoryController.addNewOrderHistory(userId, order);
              },
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // ForgetPasswordBtnWidget(
            //   btnIcon: Icons.payments_outlined,
            //   title: "VN PAY",
            //   subTitle: tPaymentPayPalOptionDes,
            //   onTap: () =>
            //       orderPayment(double.parse(widget.order.Total.toString())),
            // ),
          ],
        ),
      ),
    );
  }

  // Payment width VN Pay
  void orderPayment(double total) async {
    final orderHistoryController = Get.put(ManageHistoryOrderController());

    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
        command: 'pay',
        url: "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html",
        version: "2.0.1",
        tmnCode: '1L0S5HD3',
        txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: total,
        orderInfo: 'Payment Order | Total $total',
        returnUrl: 'https://sandbox.vnpayment.vn/merchant_webapi/merchant.html',
        ipAdress: '10.2.0.133',
        vnpayHashKey: 'ZAFDMRHXKPBBZEKLOIXHJWWXYEUYBWDJ',
        vnPayHashType: VNPayHashType.HMACSHA512);
    VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
        setState(() {
          responseCode = params['vnp_ResponseCode'];
        });
        // Thanh toán xong thì thực hiện thông báo 2.0.1 2QXUI4J4 '10.228.189.246'
        final order = OrdersHistory(
            Id: "",
            order: widget.order,
            PaymentMenthod: "VN Pay",
            orderDetail: widget.listOrder,
            PaymentTime: convertInputDateTimetoNumber(DateTime.now()));
        orderHistoryController.addNewOrderHistory(userId, order);
      },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
      },
    );
  }
}

convertInputDateTimetoNumber(DateTime tiem) {
  int timestamp = tiem.millisecondsSinceEpoch;
  return timestamp;
}
