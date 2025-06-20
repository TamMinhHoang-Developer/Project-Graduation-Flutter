import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/controller/profile_controller.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScreenUpdateProfile extends StatefulWidget {
  const ScreenUpdateProfile({super.key});

  @override
  State<ScreenUpdateProfile> createState() => _ScreenUpdateProfileState();
}

class _ScreenUpdateProfileState extends State<ScreenUpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  bool _imageChange = false;
  XFile? _xImage;
  var userId = "";
  bool isTooglePassword = false;

  late TextEditingController txtName;
  late TextEditingController txtEmail;
  late TextEditingController txtPhone;
  late TextEditingController txtPassword;
  late TextEditingController txtCreateDate;

  final controller = Get.put(AuthenticationRepository());
  final profilecontroller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    controller.bindingUser(userId);
    DateTime tsdatecreate = DateTime.fromMillisecondsSinceEpoch(
        controller.users.value.user!.CreatedAt ?? 0);
    txtName = TextEditingController();
    txtEmail = TextEditingController();
    txtPhone = TextEditingController();
    txtPassword = TextEditingController();
    txtCreateDate = TextEditingController();

    txtName.text = controller.users.value.user!.Name!;
    txtEmail.text = controller.users.value.user!.Email!;
    txtPhone.text = controller.users.value.user!.Phone!;
    txtPassword.text = controller.users.value.user!.Password!;
    txtCreateDate.text = DateFormat('dd-MM-yyyy').format(tsdatecreate);
  }

  void toggleShowPass() {
    setState(() {
      isTooglePassword = !isTooglePassword;
    });
  }

  @override
  void dispose() {
    txtName.dispose();
    txtCreateDate.dispose();
    txtEmail.dispose();
    txtPhone.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    controller.bindingUser(userId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            tUpdateProfileTitle,
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _imageChange
                                ? Image.file(
                                    File(_xImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    controller.users.value.user!.Avatar!,
                                    fit: BoxFit.cover,
                                  ))),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: padua),
                        child: IconButton(
                          icon: const Icon(Icons.photo_camera),
                          color: bgBlack,
                          onPressed: () => _pickerImage(context),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: txtName,
                          decoration: InputDecoration(
                              label: Text(
                                tInputFullname,
                                style: textSmallQuicksan,
                              ),
                              prefixIcon: Icon(
                                Icons.person_2_outlined,
                                color: bgBlack,
                              ),
                              labelStyle: TextStyle(color: bgBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(width: 2.0, color: bgBlack)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100))),
                        ),
                        const SizedBox(
                          height: sButtonHeight,
                        ),
                        TextFormField(
                          controller: txtEmail,
                          decoration: InputDecoration(
                              label: Text(
                                tEmail,
                                style: textSmallQuicksan,
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: bgBlack,
                              ),
                              labelStyle: TextStyle(color: bgBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(width: 2.0, color: bgBlack)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              )),
                        ),
                        const SizedBox(
                          height: sButtonHeight,
                        ),
                        TextFormField(
                          controller: txtPhone,
                          decoration: InputDecoration(
                              label: Text(
                                tInputPhone,
                                style: textSmallQuicksan,
                              ),
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: bgBlack,
                              ),
                              labelStyle: TextStyle(color: bgBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(width: 2.0, color: bgBlack)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              )),
                        ),
                        const SizedBox(
                          height: sButtonHeight,
                        ),
                        TextFormField(
                          obscureText: !isTooglePassword,
                          controller: txtPassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: toggleShowPass,
                                  icon: Icon(isTooglePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off)),
                              label: Text(
                                tPassword,
                                style: textSmallQuicksan,
                              ),
                              prefixIcon: Icon(
                                Icons.fingerprint,
                                color: bgBlack,
                              ),
                              labelStyle: TextStyle(color: bgBlack),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:
                                      BorderSide(width: 2.0, color: bgBlack)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              )),
                        ),
                        const SizedBox(
                          height: sDashboardPadding,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                // ignore: avoid_print
                                print(txtName.text);
                                // ignore: avoid_print
                                print(txtPhone.text);
                                // ignore: avoid_print
                                print(txtPassword.text);
                                // ignore: avoid_print
                                print(txtEmail.text);
                                if (_imageChange) {
                                  // ignore: no_leading_underscores_for_local_identifiers
                                  FirebaseStorage _storage =
                                      FirebaseStorage.instance;
                                  Reference reference = _storage
                                      .ref()
                                      .child("images")
                                      .child(
                                          "anh_${controller.users.value.user!.Id!}");

                                  UploadTask uploadTask =
                                      await _uploadTask(reference, _xImage!);
                                  uploadTask.whenComplete(() async {
                                    final avatar =
                                        await reference.getDownloadURL();
                                    profilecontroller.updateUserData(
                                        controller.users.value.user!.Id!,
                                        txtName.text,
                                        txtEmail.text,
                                        txtPassword.text,
                                        txtPhone.text,
                                        avatar);
                                  });
                                } else {
                                  profilecontroller.updateUserData(
                                      controller.users.value.user!.Id!,
                                      txtName.text,
                                      txtEmail.text,
                                      txtPassword.text,
                                      txtPhone.text,
                                      controller.users.value.user!.Avatar!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: const StadiumBorder(),
                                  foregroundColor: bgBlack,
                                  backgroundColor: padua,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: sDashboardPadding)),
                              child: const Text(tUpdateProfileTitle)),
                        ),
                        const SizedBox(
                          height: sDashboardPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(TextSpan(
                                text: "Joined at ${txtCreateDate.text}",
                                style: textNormalQuicksanBold)),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: const StadiumBorder(),
                                    foregroundColor: Colors.red,
                                    backgroundColor:
                                        Colors.redAccent.withOpacity(0.1),
                                    padding:
                                        const EdgeInsets.all(sButtonHeight)),
                                child: Text(
                                  "Lock Account",
                                  style: textNormalQuicksanRed,
                                ))
                          ],
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
