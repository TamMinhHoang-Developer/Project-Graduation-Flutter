import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/screens/manage_product/components/cart_item_products.dart';
import 'package:client_user/screens/manage_product/components/modal_bottom_add.dart';
import 'package:client_user/screens/manage_product/components/modal_filter.dart';
import 'package:client_user/uilt/style/button_style/button_style.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenManagerProduct extends StatefulWidget {
  const ScreenManagerProduct({super.key});

  @override
  State<ScreenManagerProduct> createState() => _ScreenManagerProductState();
}

class _ScreenManagerProductState extends State<ScreenManagerProduct> {
  final productController = Get.put(ManageProductsController());
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
    final homeController = Get.put(HomeController());
    homeController.checkTotalProduct(userId);
    // productController.getListProduct(userId);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black)),
          title: Text(
            tProductTitle,
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => Column(
                  children: [
                    if (homeController.totalProduct.toInt() == 0)
                      SizedBox(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      iHomeNoData,
                                      width: 200,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: sDashboardPadding,
                                ),
                                ElevatedButton(
                                  onPressed: () => showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50.0),
                                        topRight: Radius.circular(50.0),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) =>
                                        const ModalBootomAddProducts(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                    foregroundColor: bgBlack,
                                    backgroundColor: padua,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                  ),
                                  child: SizedBox(
                                    width: 150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Add Product".toUpperCase()),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        const Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    else
                      // ignore: avoid_unnecessary_containers
                      SizedBox(
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
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: size.height - 180,
                                    width: size.width - 40,
                                    child: Obx(
                                      () {
                                        return ListView.separated(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              CartItemProducts(
                                            products: productController
                                                .product[index].products!,
                                          ),
                                          // ignore: invalid_use_of_protected_member
                                          itemCount:
                                              productController.product.length,
                                          padding: const EdgeInsets.only(
                                              bottom: 50 + 16),
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 0),
                                        );
                                      },
                                    ),
                                  ),
                                  ButtonBottomCustom(
                                      textContent: "Add Products",
                                      onPress: () => showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(50.0),
                                                topRight: Radius.circular(50.0),
                                              ),
                                            ),
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) =>
                                                const ModalBootomAddProducts(),
                                          )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
