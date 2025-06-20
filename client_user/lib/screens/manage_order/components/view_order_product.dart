import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/controller/manager_order.dart';
import 'package:client_user/controller/order_local.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/tables.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewOrderProducts extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewOrderProducts({super.key, required this.table});

  final Tables table;

  @override
  State<ViewOrderProducts> createState() => _ViewOrderProductsState();
}

class _ViewOrderProductsState extends State<ViewOrderProducts> {
  final productController = Get.put(OrderLocalController());
  final orderController = Get.put(ManagerOrderController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Order ${widget.table.Name!} ",
            style: textAppKanit,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Obx(() => SizedBox(
                  height: 550,
                  child: ListView.builder(
                    itemCount: productController.cartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      productController.cartItems[index]
                                          .products!.Images![0].image),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Text(productController
                                        .cartItems[index].products!.Name!)),
                                IconButton(
                                    onPressed: () {
                                      productController.addToCart(
                                          productController
                                              .cartItems[index].products!,
                                          widget.table);
                                      // ignore: avoid_print, prefer_interpolation_to_compose_strings
                                      print("Quan GUI" +
                                          productController
                                              .cartItems[index].Quantity.value
                                              .toString());
                                    },
                                    icon: const Icon(Icons.add_circle)),
                                Obx(
                                  () => Text(
                                    // ignore: unnecessary_brace_in_string_interps
                                    productController.cartItems[index].Quantity
                                        .toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      final data = OrderDetailLocal(
                                          products: productController
                                              .cartItems[index].products!,
                                          Quantity: productController
                                              .cartItems[index].Quantity.value,
                                          tables: widget.table);
                                      productController.removeFromCart(data);
                                    },
                                    icon: const Icon(Icons.remove_circle)),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 2,
                              color: Colors.black,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          // ignore: sized_box_for_whitespace
          child: Container(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Row(
                      children: [
                        Text(
                          "Total: ${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(productController.totalPrice)}VND",
                          style: textAppKanitNormal,
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: bgBlack, width: 5.0),
                            ),
                            foregroundColor: bgBlack,
                            backgroundColor: bgWhite,
                            padding: const EdgeInsets.symmetric(
                                vertical: sButtonHeight)),
                        onPressed: () => Get.back(),
                        child: Text(
                          "Add Again",
                          style: textNormalQuicksanBold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: bgBlack, width: 5.0),
                            ),
                            foregroundColor: bgWhite,
                            backgroundColor: bgBlack,
                            padding: const EdgeInsets.symmetric(
                                vertical: sButtonHeight)),
                        onPressed: () {
                          List<OrderDetail> orderDetails = productController
                              .cartItems
                              .map((orderDetailLocal) {
                            return OrderDetail(
                              Id: "",
                              OrderId: "",
                              IdProduct: orderDetailLocal.products?.Id,
                              NameProduct: orderDetailLocal.products?.Name,
                              Price: orderDetailLocal.products?.Price,
                              Quantity: orderDetailLocal.Quantity.value,
                              Unit: orderDetailLocal.products?.Unit,
                            );
                          }).toList();
                          final order = Orders(
                              Id: "",
                              TableId: widget.table.Id,
                              TableName: widget.table.Name,
                              CreateDate:
                                  convertInputDateTimetoNumber(DateTime.now()),
                              Total: productController.totalPrice,
                              Status: false,
                              Seller: "minhTam");
                          orderController.addOrderSeller(
                              userId, order, orderDetails);
                          productController.clearCart();
                        },
                        child: Text(
                          "Create Order",
                          style: textNormalQuicksanWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

convertInputDateTimetoNumber(DateTime tiem) {
  int timestamp = tiem.millisecondsSinceEpoch;
  return timestamp;
}
