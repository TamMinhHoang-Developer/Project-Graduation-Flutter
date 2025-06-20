// ignore_for_file: avoid_print

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/controller/getorderdbcontroller.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/controller/manager_order.dart';
import 'package:client_user/controller/order_detail.dart';
import 'package:client_user/controller/order_local.dart';
import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/tables.dart';
import 'package:client_user/screens/manage_order/components/cart_item_order.dart';
import 'package:client_user/screens/manage_order/components/view_order_product.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenOrder extends StatefulWidget {
  const ScreenOrder({super.key, required this.table});
  final Tables table;

  @override
  State<ScreenOrder> createState() => _ScreenOrderState();
}

class _ScreenOrderState extends State<ScreenOrder> {
  //*  Controller
  final productController = Get.put(ManageProductsController());
  final orderController = Get.put(OrderLocalController());
  final managerController = Get.put(ManagerOrderController());
  final orderDetailController = Get.put(OrderDetailController());
  final controller = Get.put(GetOrderController());

  void _onSearchTextChanged(String value) {
    setState(() {
      _isClearVisible = value.isNotEmpty;
    });

    // Get UserId
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    if (value.isNotEmpty) {
      productController.searchProductByName(value, userId);
    } else {
      productController.getListProduct(userId);
    }
  }

  void _onClearPressed() {
    setState(() {
      _searchController.clear();
      _isClearVisible = false;
      productController.getListProduct(userId);
    });
  }

  //* Variable
  var userId = "";
  late final Orders order;
  final TextEditingController _searchController = TextEditingController();
  bool _isClearVisible = false;

  //* Init
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    if (widget.table.Status == "Walting") {
      controller.getOrderbyTableId(userId, widget.table.Id!);
    }
  }

  //* Build
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    final size = MediaQuery.of(context).size;
    managerController.getListOrder(userId);
    orderController.getTotalQuantityOrder();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    if (orderController.totalOrder.value == 0) {
                      Get.back();
                    } else {
                      // showDialogWithCustomUI(context);
                      confirm(
                        context,
                        ConfirmDialog(
                          'Are you sure?',
                          message:
                              "Do you want to cancel the current menu selection?",
                          variant: Variant.success,
                          confirmed: () {
                            Get.back();
                          },
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.close, color: Colors.black)),
              title: Text(
                widget.table.Name!,
                style: textAppKanit,
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          top: 2, bottom: 2, right: 10, left: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchTextChanged,
                              decoration: const InputDecoration(
                                  hintText: 'Search...',
                                  border: InputBorder.none),
                            ),
                          ),
                          Visibility(
                            visible: _isClearVisible,
                            child: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _onClearPressed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListDataOrder(
                        size: size,
                        productController: productController,
                        widget: widget)
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: widget.table.Status != "Walting"
                  ? BottomBarNormal(
                      widget: widget, orderController: orderController)
                  // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
                  : BottomBarWalting(controller: GetOrderController.instance),
            )));
  }
}

class BottomBarWalting extends StatelessWidget {
  const BottomBarWalting({
    super.key,
    required this.controller,
  });

  final GetOrderController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            children: [
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
                      padding:
                          const EdgeInsets.symmetric(vertical: sButtonHeight)),
                  onPressed: () async {},
                  child: Text(
                    "Export Invoid",
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
                      padding:
                          const EdgeInsets.symmetric(vertical: sButtonHeight)),
                  onPressed: () {},
                  child: Text(
                    "Payment",
                    style: textNormalQuicksanWhite,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BottomBarNormal extends StatelessWidget {
  const BottomBarNormal({
    super.key,
    required this.widget,
    required this.orderController,
  });

  final ScreenOrder widget;
  final OrderLocalController orderController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
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
                padding: const EdgeInsets.symmetric(vertical: sButtonHeight)),
            onPressed: () {
              Get.to(() => ViewOrderProducts(
                    table: widget.table,
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Go to Order",
                  style: textNormalQuicksanWhite,
                ),
                Obx(() => Text(orderController.totalOrder.value.toString()))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ListDataOrder extends StatelessWidget {
  const ListDataOrder({
    super.key,
    required this.size,
    required this.productController,
    required this.widget,
  });

  final Size size;
  final ManageProductsController productController;
  final ScreenOrder widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height - 150,
      width: size.width - 40,
      child: Obx(
        () {
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) => CartItemOrder(
              product: productController.product[index].products!,
              tables: widget.table,
            ),
            // ignore: invalid_use_of_protected_member
            itemCount: productController.product.value.length,
            padding: const EdgeInsets.only(bottom: 120, top: 10),
            separatorBuilder: (context, index) => const SizedBox(height: 0),
          );
        },
      ),
    );
  }
}

void showDialogWithCustomUI(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16.0), // Đặt border radius tại đây
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Confirmation",
                  style: textNormalKanitBold,
                ),
              ),
              const SizedBox(height: 7.0),
              Text(
                "Do you want to cancel the current menu selection?\n",
                style: textSmallQuicksan,
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.white,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Góc bo tròn với giá trị 8.0
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: textNormalQuicksanBoldGray,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Góc bo tròn với giá trị 8.0
                        )),
                    child: Text(
                      "Confirm",
                      style: textNormalQuicksanBoldWhite,
                    ),
                    onPressed: () {
                      Get.back(canPop: false);
                      Navigator.of(context).pop();
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
