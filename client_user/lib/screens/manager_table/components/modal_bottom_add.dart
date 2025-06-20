import 'package:client_user/constants/string_button.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/modal/tables.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class ModalBottomAddTable extends StatefulWidget {
  const ModalBottomAddTable({super.key});

  @override
  State<ModalBottomAddTable> createState() => _ModalBottomAddTableState();
}

class _ModalBottomAddTableState extends State<ModalBottomAddTable> {
  bool valueStatus = false;
  // ignore: no_leading_underscores_for_local_identifiers
  final _formKey = GlobalKey<FormState>();
  var userId = "";
  bool isKeyboardVisible = false;

  bool _validateName = false;
  bool _validateSlot = false;

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

    final tableController = Get.put(ManageTableController());
    final homeController = Get.put(HomeController());
    homeController.checkTotalTable(userId);
    return SingleChildScrollView(
      child: Container(
        height: isKeyboardVisible ? 650 : 400,
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
                                "Add Tables",
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
                        TextFormField(
                          controller: tableController.name,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIconColor:
                                  _validateName ? Colors.red : null,
                              prefixIcon: const Icon(Icons.abc),
                              errorText: _validateName
                                  ? 'Please enter table name'
                                  : null,
                              labelText: tInputNameProducts,
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
                          controller: tableController.slot,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIconColor:
                                  _validateSlot ? Colors.red : null,
                              prefixIcon: const Icon(Icons.numbers),
                              errorText: _validateSlot
                                  ? 'Please enter table slot'
                                  : null,
                              labelText: tInputSlotProducts,
                              border: const OutlineInputBorder()),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                _validateSlot = value.isEmpty;
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final table = Tables(
                                    Id: "",
                                    Name: tableController.name.text,
                                    Status: "Normal",
                                    Slot: int.parse(tableController.slot.text));
                                tableController.addNewTable(userId, table);
                                // Clear
                                tableController.slot.clear();
                                tableController.name.clear();

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
                              "Add Table",
                              style: textXLQuicksanBold,
                            ),
                          ),
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
}
