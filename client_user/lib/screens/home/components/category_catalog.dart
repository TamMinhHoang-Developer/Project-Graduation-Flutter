// ignore_for_file: avoid_print

import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/uilt/style/button_style/button_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesCatalog extends StatefulWidget {
  const CategoriesCatalog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesCatalogState createState() => _CategoriesCatalogState();
}

class _CategoriesCatalogState extends State<CategoriesCatalog> {
  final tableController = Get.put(ManageTableController());
  List<Icon> iconArray = const [
    Icon(Icons.home),
    Icon(Icons.settings),
    Icon(Icons.notifications),
  ];

  List<String> stringArray = const [
    "Tất Cả",
    "Sử Dụng",
    "Còn Trống",
  ];
  int _selectedCategory = 1;
  String userId = "";
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: (index == 0)
                  ? const SizedBox(
                      width: 12,
                    )
                  : (_selectedCategory == index)
                      ? SizedBox(
                          height: 47,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PrimaryShadowedButton(
                                  // ignore: sort_child_properties_last
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: SizedBox(
                                            height: 47,
                                            width: 47,
                                            child: WhiteCategoryButton(
                                              updateCategory: () {},
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          stringArray[index - 1],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategory = index;
                                      print("Tab Sellect $_selectedCategory");
                                    });
                                  },
                                  borderRadius: 80,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ],
                          ),
                        )
                      : WhiteCategoryButton(
                          updateCategory: () {
                            setState(() {
                              _selectedCategory = index;
                              print("Tab Sellect $_selectedCategory");
                              switch (_selectedCategory) {
                                case 2:
                                  tableController.getListTableByStatus(
                                      userId, "Walting");
                                  break;
                                case 3:
                                  tableController.getListTableByStatus(
                                      userId, "Normal");
                                  break;
                                default:
                                  tableController.getListTable(userId);
                                  break;
                              }
                            });
                          },
                        ),
            );
          }),
    );
  }
}
