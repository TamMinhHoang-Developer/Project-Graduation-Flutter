import 'package:client_user/controller/manage_orderv3controller.dart';
import 'package:client_user/modal/order.dart';
import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartUpdateProduct extends StatefulWidget {
  const CartUpdateProduct(
      {super.key, required this.product, required this.orders});

  final Products product;
  final Orders orders;

  @override
  State<CartUpdateProduct> createState() => _CartUpdateProductState();
}

class _CartUpdateProductState extends State<CartUpdateProduct> {
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
        width: 500,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          // ignore: invalid_use_of_protected_member
                          "${widget.product.Name} ",
                          style: textAppKanitNormal, textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        children: [
                          Text(
                            // ignore: invalid_use_of_protected_member
                            "Price: ${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.product.Price)}VND",
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
                                Id: "",
                                IdProduct: widget.product.Id,
                                OrderId: widget.orders.Id,
                                Price: widget.product.Price,
                                Unit: widget.product.Unit,
                                Quantity: 1,
                                NameProduct: widget.product.Name);
                            orderController.addOrUpdateOrderDetailOnFirestore(
                                orderDt, userId, widget.orders.Id!);
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
