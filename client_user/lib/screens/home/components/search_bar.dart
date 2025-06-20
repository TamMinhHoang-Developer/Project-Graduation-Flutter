import 'dart:async';

import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/uilt/style/button_style/button_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBars extends StatefulWidget {
  const SearchBars({Key? key}) : super(key: key);

  @override
  State<SearchBars> createState() => _SearchBarsState();
}

class _SearchBarsState extends State<SearchBars> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInputFocused = false;

  bool _isClearVisible = false;

  final tableController = Get.put(ManageTableController());
  var userId = "";

  void _onSearchTextChanged(String value) {
    setState(() {
      _isClearVisible = value.isNotEmpty;
      _isInputFocused = true;
    });

    // Get UserId
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    if (value.isNotEmpty) {
      tableController.searchTableByNamev2(value, userId);
    } else {
      tableController.getListTable(userId);
    }
  }

  void _onClearPressed() {
    setState(() {
      _searchController.clear();
      _isClearVisible = false;
      _isInputFocused = false;
      tableController.getListTable(userId);
    });

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.only(top: 2, bottom: 2, right: 10, left: 10),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              autocorrect: false,
              controller: _searchController,
              autofocus: _isInputFocused,
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
    );
  }
}
