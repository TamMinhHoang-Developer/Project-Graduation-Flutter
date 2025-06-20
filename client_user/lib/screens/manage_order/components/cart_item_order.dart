import 'package:client_user/controller/order_local.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/modal/tables.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CartItemOrder extends StatefulWidget {
  const CartItemOrder({super.key, required this.product, required this.tables});

  final Products product;
  final Tables tables;

  @override
  State<CartItemOrder> createState() => _CartItemOrderState();
}

class _CartItemOrderState extends State<CartItemOrder> {
  final cartController = Get.put(OrderLocalController());

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage(widget.product.Images![0].image),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        // ignore: invalid_use_of_protected_member
                        "${widget.product.Name} ",
                        style: textNormalKanitBold),
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Text(
                          // ignore: invalid_use_of_protected_member
                          "Price: ${widget.product.Price.toString()}",
                          style: textNormalQuicksanBold,
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_sharp),
                  onPressed: () {
                    cartController.addToCart(widget.product, widget.tables);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
