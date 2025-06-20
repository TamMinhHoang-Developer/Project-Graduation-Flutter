import 'package:client_user/controller/manage_orderv3controller.dart';
import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartItemUpdate extends StatefulWidget {
  const CartItemUpdate(
      {super.key,
      required this.orderDetail,
      required this.order,
      required this.length});

  final OrderDetail orderDetail;
  final Orders order;
  final int length;

  @override
  State<CartItemUpdate> createState() => _CartItemUpdateState();
}

class _CartItemUpdateState extends State<CartItemUpdate> {
  final OrderV2sController orderController = Get.put(OrderV2sController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    return SizedBox(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.cancel_outlined),
                          onTap: () {
                            if (widget.length > 1) {
                              orderController.deleteOrderDetail(
                                  widget.orderDetail, userId, widget.order.Id!);
                            } else {
                              confirm(
                                context,
                                ConfirmDialog(
                                  'Are you sure?',
                                  message:
                                      "This action cannot be undone!. Your invoice will be deleted.",
                                  variant: Variant.danger,
                                  confirmed: () {
                                    orderController.deleteOrderDetail(
                                        widget.orderDetail,
                                        userId,
                                        widget.order.Id!);
                                    orderController.deleteOrder(
                                        userId, widget.order);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          // ignore: invalid_use_of_protected_member
                          "${widget.orderDetail.NameProduct} ${widget.length}",
                          style: textAppKanitNormal, textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: [
                          Text(
                            // ignore: invalid_use_of_protected_member
                            "Price: ${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.orderDetail.Price)}VND",
                            style: textSmallQuicksanBold,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            final orderDt = OrderDetail(
                                Id: widget.orderDetail.Id,
                                IdProduct: widget.orderDetail.IdProduct,
                                NameProduct: widget.orderDetail.NameProduct,
                                Price: widget.orderDetail.Price,
                                Quantity: widget.orderDetail.Quantity! + 1,
                                Unit: widget.orderDetail.Unit,
                                OrderId: widget.orderDetail.OrderId);
                            orderController.updateOrderDetail(
                                orderDt, userId, widget.order.Id!);
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.orderDetail.Quantity}",
                          style: textSmallQuicksanBold,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            final orderDt = OrderDetail(
                                Id: widget.orderDetail.Id,
                                IdProduct: widget.orderDetail.IdProduct,
                                NameProduct: widget.orderDetail.NameProduct,
                                Price: widget.orderDetail.Price,
                                Quantity: widget.orderDetail.Quantity! - 1,
                                Unit: widget.orderDetail.Unit,
                                OrderId: widget.orderDetail.OrderId);
                            orderController.updateOrderDetail(
                                orderDt, userId, widget.order.Id!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
