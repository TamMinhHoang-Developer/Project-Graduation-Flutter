// ignore_for_file: camel_case_types

import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class Modal_Filter extends StatefulWidget {
  const Modal_Filter({super.key});

  @override
  State<Modal_Filter> createState() => _Modal_FilterState();
}

class _Modal_FilterState extends State<Modal_Filter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
                              "Filter Product",
                              style: textAppKanit,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.filter_list,
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
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                    autofocus: true,
                    onPressed: () {},
                    // ignore: sort_child_properties_last
                    child: const Text(
                      "SALE",
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: bgBlack, width: 5.0),
                        ),
                        foregroundColor: bgBlack,
                        side: BorderSide(color: bgBlack),
                        padding: const EdgeInsets.symmetric(
                            vertical: sButtonHeight)),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: OutlinedButton(
                    onPressed: () {},
                    // ignore: sort_child_properties_last
                    child: const Text(
                      "NO SALE",
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: bgBlack, width: 5.0),
                        ),
                        foregroundColor: bgBlack,
                        side: BorderSide(color: bgBlack),
                        padding: const EdgeInsets.symmetric(
                            vertical: sButtonHeight)),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
