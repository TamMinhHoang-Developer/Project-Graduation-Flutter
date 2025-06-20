import 'package:client_user/modal/products.dart';
import 'package:client_user/screens/manage_product/components/modal_bottom_fun.dart';
import 'package:client_user/screens/manage_product/components/page_view_product.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CartItemProducts extends StatefulWidget {
  CartItemProducts({super.key, required this.products});

  Products products;

  @override
  State<CartItemProducts> createState() => _CartItemProductsState();
}

class _CartItemProductsState extends State<CartItemProducts> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    DateTime tsdate =
        DateTime.fromMillisecondsSinceEpoch(widget.products.CreateAt!);
    final data = DateFormat('MMM dd, yyyy | hh:mm aaa').format(tsdate);
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
                builder: (context) => ModalBottomFunProducts(
                  products: widget.products,
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
        onTap: () {},
        child: Card(
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        GFAvatar(
                          shape: GFAvatarShape.circle,
                          child: Image.network(
                            widget.products.Images?[0].image ??
                                "https://w.wallhaven.cc/full/jx/wallhaven-jx1low.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  // ignore: invalid_use_of_protected_member
                                  widget.products.Name!,
                                  style: textXLNunitoBold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.products.Price)}VND",
                                style: textXLNunitoBold,
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // ignore: invalid_use_of_protected_member
                                data.toString(),
                                style: textSmallQuicksan,
                              ),
                              if (widget.products.Sale!)
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.redAccent.withOpacity(0.5)),
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    'Sale',
                                    style: textSmallQuicksanBold,
                                  ),
                                )
                              else
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color:
                                          Colors.greenAccent.withOpacity(0.5)),
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    'Norm',
                                    style: textSmallQuicksanBold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Get.to(() => ViewProduct(
                                product: widget.products,
                              ));
                        },
                        child: Text(
                          "View Products",
                          style: textXLNunitoBold,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
