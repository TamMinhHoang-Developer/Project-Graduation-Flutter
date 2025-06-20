import 'package:client_user/modal/sellers.dart';
import 'package:client_user/screens/manager_seller/components/modal_bottom_fun.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class CartItemSeller extends StatefulWidget {
  CartItemSeller({super.key, required this.seller});
  Seller seller;

  @override
  State<CartItemSeller> createState() => _CartItemSellerState();
}

class _CartItemSellerState extends State<CartItemSeller> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) => ModalBottomFunSeller(
                  seller: widget.seller,
                  viewMode: true,
                ),
              );
            },
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) => ModalBottomFunSeller(
              seller: widget.seller,
              viewMode: false,
            ),
          );
        },
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
                    Text(
                        // ignore: invalid_use_of_protected_member
                        "${widget.seller.Name}",
                        style: textNormalKanitBold),
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Text(
                          // ignore: invalid_use_of_protected_member
                          "${widget.seller.Email}",
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
