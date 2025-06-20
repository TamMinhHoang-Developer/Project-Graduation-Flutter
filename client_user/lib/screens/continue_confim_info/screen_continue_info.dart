// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/confim_info_controller.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/form/form_header_widget.dart';

class ScreenContinueInfo extends StatefulWidget {
  const ScreenContinueInfo({super.key});

  @override
  State<ScreenContinueInfo> createState() => _ScreenContinueInfoState();
}

class _ScreenContinueInfoState extends State<ScreenContinueInfo> {
  bool _imageChange = false;
  XFile? _xImage;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmInfo());
    final box = GetStorage();
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const FormHeaderWidget(
                    title: tConfirmMoreInfo,
                    image: iSignup,
                    subTitle: tDesSignup),
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
                                    : const Text("Hello"),
                              ),
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
                          controller: controller.address,
                          decoration: InputDecoration(
                              label: Text(
                                tInputAddress,
                                style: textSmallQuicksan,
                              ),
                              prefixIcon: Icon(
                                Icons.place,
                                color: bgBlack,
                              ),
                              labelStyle: TextStyle(color: bgBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2.0, color: bgBlack)),
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Text(FirebaseAuth.instance.currentUser!.uid),
                        // Text(box.read('idCredential')),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side:
                                        BorderSide(color: bgBlack, width: 5.0),
                                  ),
                                  foregroundColor: bgWhite,
                                  backgroundColor: bgBlack,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: sButtonHeight)),
                              onPressed: () async {
                                FirebaseStorage _storage =
                                    FirebaseStorage.instance;
                                Reference reference = _storage
                                    .ref()
                                    .child("images")
                                    .child(
                                        "anh_${FirebaseAuth.instance.currentUser!.uid}");

                                UploadTask uploadTask =
                                    await _uploadTask(reference, _xImage!);
                                uploadTask.whenComplete(() async {
                                  final avatar =
                                      await reference.getDownloadURL();
                                  final updates = [
                                    {'Avatar': avatar},
                                    {'Address': controller.address.text.trim()},
                                  ];
                                  controller.updateUser(
                                      box.read('idCredential'), updates);
                                });
                              },
                              child: Text(
                                tButtonConfirm.toUpperCase(),
                                style: textSmallQuicksanWhite,
                              )),
                        )
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
