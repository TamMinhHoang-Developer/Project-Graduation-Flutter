// ignore_for_file: invalid_use_of_protected_member

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/screens/manager_table/components/cart_item.dart';
import 'package:client_user/screens/manager_table/components/modal_bottom_add.dart';
import 'package:client_user/uilt/style/button_style/button_style.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenManageTable extends StatefulWidget {
  const ScreenManageTable({super.key});

  @override
  State<ScreenManageTable> createState() => _ScreenManageTableState();
}

class _ScreenManageTableState extends State<ScreenManageTable> {
  final homeController = Get.put(HomeController());
  final tableController = Get.put(ManageTableController());
  var userId = "";

  @override
  Widget build(BuildContext context) {
    //! Logic
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }
    homeController.checkTotalTable(userId);
    tableController.getListTable(userId);
    final size = MediaQuery.of(context).size;

    //! Build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            tManageTableTitle,
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    if (tableController.users.isEmpty) {
                      return SizedBox(
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
                                        const ModalBottomAddTable(),
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
                                        Text("Add Table".toUpperCase()),
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
                      );
                    } else {
                      return SizedBox(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: size.height - 150,
                              width: size.width - 40,
                              child: Obx(
                                () {
                                  return ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        CartItemTable(
                                      table:
                                          tableController.users[index].table!,
                                      parentContext: context,
                                    ),
                                    itemCount:
                                        tableController.users.value.length,
                                    padding:
                                        const EdgeInsets.only(bottom: 50 + 16),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 0),
                                  );
                                },
                              ),
                            ),
                            ButtonBottomCustom(
                                textContent: "Add Table",
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
                                          const ModalBottomAddTable(),
                                    )),
                          ],
                        ),
                      );
                    }
                  })
                ],
              )),
        ),
      ),
    );
  }
}
