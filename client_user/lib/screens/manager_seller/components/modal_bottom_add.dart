// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:client_user/constants/string_button.dart';
import 'package:client_user/controller/manage_seller.dart';
import 'package:client_user/modal/sellers.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ModalBottomAddSeller extends StatefulWidget {
  const ModalBottomAddSeller({super.key});

  @override
  State<ModalBottomAddSeller> createState() => _ModalBottomAddSellerState();
}

class _ModalBottomAddSellerState extends State<ModalBottomAddSeller> {
  bool _imageChange = false;
  XFile? _xImage;
  var userId = "";
  final sellerController = Get.put(ManageSellerController());
  final _formKey = GlobalKey<FormState>();
  bool isKeyboardVisible = false;

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
    return SingleChildScrollView(
      child: Container(
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
                                "Add Seller",
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
                        Stack(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              padding: const EdgeInsets.all(
                                  4), // thêm khoảng cách giữa viền và CircleAvatar
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              child: ClipOval(
                                  child: _imageChange
                                      ? Image.file(
                                          File(_xImage!.path),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: padua,
                                        )),
                            ),
                            Positioned(
                                left: 105,
                                top: 105,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () => _pickerImage(context),
                                      icon: const Icon(Icons.add_a_photo)),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.name,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.abc),
                              labelText: tInputNameSeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.address,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.map),
                              labelText: tInputAddress,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: sellerController
                              .birthday, //editing controller of this TextField
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.numbers),
                              labelText: tInputBirthdaySeller,
                              border: const OutlineInputBorder()),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              // ignore: avoid_print
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              // ignore: avoid_print
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                sellerController.birthday.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              // ignore: avoid_print
                              print("Date is not selected");
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.phone,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.numbers),
                              labelText: tInputPhoneSeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.email,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.email),
                              labelText: tInputEmailSeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.salary,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.money),
                              labelText: tInputSalarySeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.sex,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.people),
                              labelText: tInputSexSeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: sellerController.age,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.near_me_rounded),
                              labelText: tInputAgeSeller,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_imageChange) {
                                  final seller = Seller(
                                      Id: "",
                                      Name: sellerController.name.text,
                                      Address: sellerController.address.text,
                                      Email: sellerController.email.text,
                                      Phone: sellerController.phone.text,
                                      Salary: sellerController.salary.text,
                                      Sex: sellerController.sex.text,
                                      Age: int.parse(sellerController.age.text),
                                      Birthday: convertInputDateTimetoNumber(
                                          sellerController.birthday.text));
                                  // ignore: no_leading_underscores_for_local_identifiers
                                  FirebaseStorage _storage =
                                      FirebaseStorage.instance;
                                  Reference reference = _storage
                                      .ref()
                                      .child("images_seller")
                                      .child("anh_${sellerController.phone}");

                                  UploadTask uploadTask =
                                      await _uploadTask(reference, _xImage!);
                                  uploadTask.whenComplete(() async {
                                    seller.Avatar =
                                        await reference.getDownloadURL();
                                    sellerController.addNewSeller(
                                        userId, seller);
                                  });
                                } else {
                                  Get.snackbar('Error', "Please Upload Avatar",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.1),
                                      colorText: Colors.black);
                                }

                                // Clear
                                sellerController.name.clear();
                                sellerController.address.clear();
                                sellerController.email.clear();
                                sellerController.phone.clear();
                                sellerController.salary.clear();
                                sellerController.sex.clear();
                                sellerController.age.clear();
                                sellerController.birthday.clear();

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
                              "Add Seller",
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
      ),
    );
  }

  _pickerImage(BuildContext context) async {
    _xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_xImage != null) {
      setState(() {
        _imageChange = true;
      });
    }
  }
}

convertInputDateTimetoNumber(String tiem) {
  String activeDate = tiem; // giá trị ngày tháng dưới dạng chuỗi
  DateTime dateTime =
      DateTime.parse(activeDate); // chuyển đổi thành đối tượng DateTime
  int timestamp = dateTime.millisecondsSinceEpoch; // chuyển đổi thành số
  return timestamp;
}

Future<UploadTask> _uploadTask(Reference reference, XFile xImage) async {
  final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': xImage.path});
  UploadTask uploadTask;
  if (kIsWeb) {
    uploadTask = reference.putData(await xImage.readAsBytes(), metadata);
  } else {
    uploadTask = reference.putFile(File(xImage.path), metadata);
  }
  return Future.value(uploadTask);
}
