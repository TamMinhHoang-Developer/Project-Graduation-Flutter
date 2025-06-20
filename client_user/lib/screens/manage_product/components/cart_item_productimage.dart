import 'package:client_user/modal/product_image.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class CartItemProductImage extends StatefulWidget {
  CartItemProductImage({super.key, required this.products});

  ProductImage products;

  @override
  State<CartItemProductImage> createState() => _CartItemProductImageState();
}

class _CartItemProductImageState extends State<CartItemProductImage> {
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        // ignore: invalid_use_of_protected_member
                        "Table: ${widget.products.image}",
                        style: textNormalKanitBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Text(
                          // ignore: invalid_use_of_protected_member
                          "Slot: ${widget.products.uploadAt}",
                          style: textNormalQuicksanBold,
                        ),
                      ],
                    )
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
