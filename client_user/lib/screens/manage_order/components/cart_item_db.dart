import 'package:client_user/modal/order_detail.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItemDb extends StatefulWidget {
  const CartItemDb({super.key, required this.order});

  final OrderDetail order;

  @override
  State<CartItemDb> createState() => _CartItemDbState();
}

class _CartItemDbState extends State<CartItemDb> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      // ignore: invalid_use_of_protected_member
                      "${widget.order.NameProduct} ",
                      style: textAppKanitNormal, textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: [
                      Text(
                        // ignore: invalid_use_of_protected_member
                        "Price: ${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.order.Price)}VND",
                        style: textSmallQuicksanBold,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "${widget.order.Quantity} ${widget.order.Unit!}",
                    style: textSmallQuicksanBold,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
