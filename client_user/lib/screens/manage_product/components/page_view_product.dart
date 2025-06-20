// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:client_user/constants/string_context.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/screens/manage_product/screen_manager_product.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key, required this.product});
  final Products product;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  final productController = Get.put(ManageProductsController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
          title: Text(
            "Detail Product",
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  final listImage = [];
                  widget.product.Images!
                      .forEach((ele) => listImage.add(ele.image));
                  preview(context, listImage);
                },
                child: Image.network(
                  widget.product.Images!.isNotEmpty
                      ? widget.product.Images![0].image.toString()
                      : "https://img.freepik.com/free-vector/page-found-concept-illustration_114360-1869.jpg",
                  height: size.height * 0.4,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.Name!,
                      style: textAppKanit,
                    ),
                    Text(
                      widget.product.Type!,
                      style: textNormalQuicksanBoldGray,
                    ),
                    if (widget.product.Sale! == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.product.Price)}VND",
                            style: textCouterKanit.apply(
                                decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.product.Price_Sale)}VND",
                            style: textAppKanitRed,
                          ),
                        ],
                      )
                    else
                      Text(
                        "${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(widget.product.Price)}VND",
                        style: textCouterKanit,
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Description",
                      style: textNormalQuicksanBold,
                    ),
                    Text(
                      widget.product.Description!,
                      style: textNormalQuicksanBold,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const StadiumBorder(),
                            foregroundColor: bgBlack,
                            backgroundColor: Colors.redAccent.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 15)),
                        onPressed: () {
                          productController.deleteProducts(
                              userId, widget.product.Id!);
                          Get.to(() => const ScreenManagerProduct());
                        },
                        child: Text(
                          'Delete Product',
                          style: textNormalQuicksanBold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
