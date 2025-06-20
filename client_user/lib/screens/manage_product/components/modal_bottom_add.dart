import 'package:client_user/constants/string_button.dart';
import 'package:client_user/controller/manage_product.dart';
import 'package:client_user/controller/productimage_controller.dart';
import 'package:client_user/modal/products.dart';
import 'package:client_user/screens/manage_product/components/test_multi_file.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class ModalBootomAddProducts extends StatefulWidget {
  const ModalBootomAddProducts({super.key});

  @override
  State<ModalBootomAddProducts> createState() => _ModalBootomAddProductsState();
}

class _ModalBootomAddProductsState extends State<ModalBootomAddProducts> {
  final sellerController = Get.put(ManageProductsController());
  final productimageController = Get.put(ProductImageController());
  final GFBottomSheetController controller = GFBottomSheetController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = true;
  var userId = "";
  bool isKeyboardVisible = false;

  bool _validateName = false;
  bool _validateDes = false;
  bool _validatePrice = false;
  bool _validateUnit = false;

  @override
  void initState() {
    super.initState();
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
                              "Add Product",
                              style: textAppKanit,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.add,
                          size: 30,
                        ),
                        // Obx(() => Text(homeController.totalTable.toString()))
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        productimageController.clearListImage();
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
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: const StadiumBorder(),
                                  foregroundColor: bgBlack,
                                  backgroundColor: padua,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                ),
                                onPressed: () {
                                  Get.to(() => TestMultiPicker(
                                        pickMode: true,
                                      ));
                                },
                                icon: const Icon(Icons.image),
                                label: Text("Pick Image".toUpperCase())),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Obx(() => Column(
                                children: [
                                  // ignore: invalid_use_of_protected_member
                                  productimageController
                                          .product.value.isNotEmpty
                                      ? TextButton(
                                          onPressed: () {
                                            Get.to(() => TestMultiPicker(
                                                  pickMode: false,
                                                ));
                                          },
                                          child: Text(
                                            // ignore: invalid_use_of_protected_member
                                            "${productimageController.product.value.length} Image Picker",
                                            style: textNormalKanitBold,
                                          ),
                                        )
                                      : Text(
                                          "No Image Picker",
                                          style: textNormalKanitBold,
                                        )
                                ],
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: sellerController.name,
                        decoration: InputDecoration(
                            labelStyle: textSmallQuicksan,
                            prefixIconColor: _validateName ? Colors.red : null,
                            prefixIcon: const Icon(Icons.abc),
                            labelText: tInputNameProducts,
                            errorText: _validateName
                                ? 'Please enter product name'
                                : null,
                            border: const OutlineInputBorder()),
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _validateName = value.isEmpty;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: sellerController.description,
                        decoration: InputDecoration(
                            labelStyle: textSmallQuicksan,
                            prefixIconColor: _validateDes ? Colors.red : null,
                            prefixIcon: const Icon(Icons.text_snippet),
                            labelText: tInputDesProducts,
                            errorText: _validateDes
                                ? 'Please enter product description'
                                : null,
                            border: const OutlineInputBorder()),
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              _validateDes = value.isEmpty;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: sellerController.type,
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
                        controller: sellerController.price,
                        decoration: InputDecoration(
                            labelStyle: textSmallQuicksan,
                            prefixIconColor: _validatePrice ? Colors.red : null,
                            prefixIcon: const Icon(Icons.price_change),
                            labelText: tInputPriceProducts,
                            errorText: _validatePrice
                                ? 'Please enter product price'
                                : null,
                            border: const OutlineInputBorder()),
                        onChanged: (value) {
                          if (mounted) {
                            _validatePrice = value.isEmpty;
                          }
                        },
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
                                    const Icon(Icons
                                        .keyboard_double_arrow_down_rounded),
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
                        controller: sellerController.priceSale,
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
                          controller: sellerController.unit,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.ad_units),
                              prefixIconColor:
                                  _validatePrice ? Colors.red : null,
                              labelText: tInputUnitProducts,
                              errorText: _validateUnit
                                  ? 'Please enter product unit'
                                  : null,
                              border: const OutlineInputBorder()),
                          onChanged: (value) {
                            if (mounted) {
                              _validateUnit = value.isEmpty;
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var product = Products(
                                Id: "",
                                Name: sellerController.name.text,
                                Description: sellerController.description.text,
                                Type: sellerController.type.text,
                                CreateAt: convertInputDateTimetoNumber(
                                    DateTime.now().toString()),
                                Price: int.parse(sellerController.price.text),
                                Price_Sale: isChecked
                                    ? int.parse(sellerController.priceSale.text)
                                    : int.parse(sellerController.price.text),
                                Sale: isChecked,
                                Unit: sellerController.unit.text,
                                // ignore: invalid_use_of_protected_member
                                Images: productimageController.product.value,
                              );
                              sellerController.addNewProduct(userId, product);

                              // Clear
                              productimageController.clearListImage();
                              sellerController.name.clear();
                              sellerController.description.clear();
                              sellerController.type.clear();
                              sellerController.price.clear();
                              sellerController.priceSale.clear();
                              sellerController.unit.clear();

                              // Back
                              Navigator.pop(context);
                            }
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
                            "Add Product",
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
