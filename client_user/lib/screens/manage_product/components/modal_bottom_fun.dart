import 'package:client_user/constants/string_button.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/controller/productimage_controller.dart';
import 'package:client_user/modal/product_image.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class ModalBottomFunProducts extends StatefulWidget {
  const ModalBottomFunProducts({super.key, required this.products});
  final Products products;

  @override
  State<ModalBottomFunProducts> createState() => _ModalBottomFunProductsState();
}

class _ModalBottomFunProductsState extends State<ModalBottomFunProducts> {
  final sellerController = Get.put(ManageProductsController());
  final productimageController = Get.put(ProductImageController());
  final GFBottomSheetController controller = GFBottomSheetController();
  bool isChecked = true;
  var userId = "";
  bool isKeyboardVisible = false;

  late TextEditingController txtName;
  late TextEditingController txtDesScript;
  late TextEditingController txtType;
  late TextEditingController txtPrice;
  late TextEditingController txtSale;
  late TextEditingController txtPriceSale;
  late TextEditingController txtUnit;

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtDesScript = TextEditingController();
    txtType = TextEditingController();
    txtPrice = TextEditingController();
    txtSale = TextEditingController();
    txtPriceSale = TextEditingController();
    txtUnit = TextEditingController();

    txtName.text = widget.products.Name!;
    txtDesScript.text = widget.products.Description!;
    txtType.text = widget.products.Type!;
    txtPrice.text = widget.products.Price.toString();
    txtSale.text = widget.products.Sale.toString();
    txtPriceSale.text = widget.products.Price_Sale.toString();
    txtUnit.text = widget.products.Unit!.toString();
    isChecked = widget.products.Sale!;

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    return Container(
      height: isKeyboardVisible ? 750 : 500,
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Text(
                              "Edit Product",
                              style: textAppKanit,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.edit,
                          size: 30,
                        ),
                        // Obx(() => Text(homeController.totalTable.toString()))
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        weight: 900,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: txtName,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.abc),
                        labelText: tInputNameProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: txtDesScript,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.text_snippet),
                        labelText: tInputDesProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: txtType,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.type_specimen),
                        labelText: tInputTypeProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: txtPrice,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.price_change),
                        labelText: tInputPriceProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                        // ignore: avoid_print
                        print(isChecked);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ignore: avoid_unnecessary_containers
                          Container(
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.keyboard_double_arrow_down_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Sales",
                                  style: textSmallQuicksan,
                                ),
                              ],
                            ),
                          ),
                          GFCheckbox(
                            onChanged: (value) {
                              // setState(() {
                              //   isChecked = value;
                              // });
                            },
                            value: isChecked,
                            type: GFCheckboxType.circle,
                            size: 26,
                            activeBgColor: Colors.green,
                            inactiveIcon: null,
                            activeIcon: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    enabled: isChecked,
                    controller: txtPriceSale,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.price_change_outlined),
                        labelText: tInputPriceSaleProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: txtUnit,
                    decoration: InputDecoration(
                        labelStyle: textSmallQuicksan,
                        prefixIcon: const Icon(Icons.ad_units),
                        labelText: tInputUnitProducts,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        var image = widget.products.Images;
                        var product = Products(
                          Id: widget.products.Id,
                          Name: txtName.text,
                          Description: txtDesScript.text,
                          Type: txtType.text,
                          CreateAt: widget.products.CreateAt,
                          Price: int.parse(txtPrice.text),
                          Price_Sale: isChecked
                              ? int.parse(txtPriceSale.text)
                              : int.parse(txtPrice.text),
                          Sale: isChecked,
                          Unit: txtUnit.text,
                          Images: image,
                        );
                        sellerController.editProduct(
                            userId, product, widget.products.Id!);
                        // print(
                        //     "${txtName.text} ${txtDesScript.text} ${txtPrice.text} ${product}");

                        // Back
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        foregroundColor: bgBlack,
                        backgroundColor: padua,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                      ),
                      child: Text(
                        "Edit Product",
                        style: textXLQuicksanBold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

convertInputDateTimetoNumber(String tiem) {
  String activeDate = tiem; // giá trị ngày tháng dưới dạng chuỗi
  DateTime dateTime =
      DateTime.parse(activeDate); // chuyển đổi thành đối tượng DateTime
  int timestamp = dateTime.millisecondsSinceEpoch; // chuyển đổi thành số
  return timestamp;
}
