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

// ignore: must_be_immutable
class ModalBottomFunTable extends StatefulWidget {
  ModalBottomFunTable({super.key, required this.table, required this.viewMode});

  Tables table;
  bool viewMode;

  @override
  State<ModalBottomFunTable> createState() => _ModalBottomFunTableState();
}

class _ModalBottomFunTableState extends State<ModalBottomFunTable> {
  bool valueStatus = false;
  // ignore: no_leading_underscores_for_local_identifiers
  final _formKey = GlobalKey<FormState>();
  var userId = "";
  bool isKeyboardVisible = false;

  late TextEditingController txtName;
  late TextEditingController txtSlot;

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtSlot = TextEditingController();

    txtName.text = widget.table.Name!;
    txtSlot.text = widget.table.Slot.toString();

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    txtName.dispose();
    txtSlot.dispose();
    super.dispose();
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
                                widget.viewMode ? "Edit" : "Detail",
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
                          enabled: widget.viewMode,
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
                          enabled: widget.viewMode,
                          controller: txtSlot,
                          decoration: InputDecoration(
                              labelStyle: textSmallQuicksan,
                              prefixIcon: const Icon(Icons.numbers),
                              labelText: tInputSlotProducts,
                              border: const OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ignore: sized_box_for_whitespace
                        if (!widget.viewMode)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.table.Status == "Walting") {
                                  Get.snackbar('Delete Error',
                                      "This table is waiting to be paid",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.greenAccent.withOpacity(0.1),
                                      colorText: Colors.black);
                                } else {
                                  tableController.deleteTable(
                                      userId, widget.table.Id!);
                                  // Back
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: const StadiumBorder(),
                                foregroundColor: bgBlack,
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                              ),
                              child: Text(
                                "Delete Table",
                                style: textXLQuicksanBold,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // ignore: avoid_print
                                print(widget.table.Id!);
                                final table = Tables(
                                    Id: widget.table.Id!,
                                    Name: txtName.text,
                                    Status: widget.table.Status,
                                    Slot: int.parse(txtSlot.text));
                                tableController.editTable(
                                    userId, table, widget.table.Id!);
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
                                "Edit Table",
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

  // ignore: unused_element
  Future<void> _dialogBuilder(BuildContext context, String title,
      String description, VoidCallback outFunction) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Done'),
              onPressed: () {
                outFunction();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
