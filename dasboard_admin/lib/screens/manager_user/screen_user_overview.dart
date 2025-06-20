import 'package:dasboard_admin/controllers/total_controller.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:dasboard_admin/widgets/components/cart_item_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserOverviewScreen extends StatefulWidget {
  const UserOverviewScreen({super.key});

  @override
  State<UserOverviewScreen> createState() => _UserOverviewScreenState();
}

class _UserOverviewScreenState extends State<UserOverviewScreen> {
  // ignore: unused_field
  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController txtSearch = TextEditingController();
  final cu = Get.put(TotalController());

  final TextEditingController _searchController = TextEditingController();
  bool _isClearVisible = false;

  void _onSearchTextChanged(String value) {
    setState(() {
      _isClearVisible = value.isNotEmpty;
    });
    if (value.isNotEmpty) {
      cu.searchProductByName(value);
    } else {
      cu.getListUser();
    }
  }

  void _onClearPressed() {
    setState(() {
      _searchController.clear();
      _isClearVisible = false;
      cu.getListUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            "Manager User",
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, right: 10, left: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchTextChanged,
                          decoration: const InputDecoration(
                              hintText: 'Search...', border: InputBorder.none),
                        ),
                      ),
                      Visibility(
                        visible: _isClearVisible,
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _onClearPressed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: size.height - 200,
                      width: size.width - 40,
                      child: Obx(
                        () {
                          return ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) => CartItemUser(
                              user: cu.users[index].user!,
                              parentContext: context,
                            ),
                            // ignore: invalid_use_of_protected_member
                            itemCount: cu.users.value.length,
                            padding: const EdgeInsets.only(bottom: 50 + 16),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 0),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
