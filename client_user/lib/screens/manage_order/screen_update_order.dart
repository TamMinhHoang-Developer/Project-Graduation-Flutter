import 'package:client_user/controller/manage_orderv3controller.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/tables.dart';
import 'package:client_user/screens/manage_order/components/cart_item_update.dart';
import 'package:client_user/screens/manage_order/components/cart_update_product.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ScreenUpdateOrder extends StatefulWidget {
  ScreenUpdateOrder(
      {super.key,
      required this.table,
      required this.listOrder,
      required this.order});
  Tables table;
  Orders order;
  List<OrderDetail> listOrder;

  @override
  State<ScreenUpdateOrder> createState() => _ScreenUpdateOrderState();
}

class _ScreenUpdateOrderState extends State<ScreenUpdateOrder> {
  final OrderV2sController orderController = Get.put(OrderV2sController());
  final ManageProductsController productController =
      Get.put(ManageProductsController());
  var userId = "";

  final TextEditingController _searchController = TextEditingController();
  bool _isClearVisible = false;

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

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    orderController.fetchOrderDataFromFirestore(userId, widget.table.Id!);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.black)),
          title: Text(
            "Edit Order Detail",
            style: textAppKanit,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5, top: 7),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                onPressed: () {
                  updateProduct(
                    context,
                    SingleChildScrollView(
                      child: ConfirmUpdateDialog(
                        'Add Products',
                        variant: Variant.success,
                        widget: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
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
                                  SizedBox(
                                    height: 400,
                                    child: Obx(
                                      () {
                                        final productList =
                                            productController.product;
                                        return SingleChildScrollView(
                                          child: SizedBox(
                                            height:
                                                400, // Đặt chiều cao cho SizedBox
                                            child: ListView.separated(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                final product =
                                                    productList[index].products;
                                                return CartUpdateProduct(
                                                  product: product!,
                                                  orders: widget.order,
                                                );
                                              },
                                              itemCount: productList.length,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(height: 0),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        confirmed: () {},
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (orderController.orderDetailList.isNotEmpty) {
              return SizedBox(
                height: 650,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderController.orderDetailList.length,
                  itemBuilder: (context, index) {
                    final orderDetail = orderController.orderDetailList[index];
                    return CartItemUpdate(
                      orderDetail: orderDetail,
                      order: widget.order,
                      length: orderController.orderDetailList.length,
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ),
      ),
    );
  }
}
