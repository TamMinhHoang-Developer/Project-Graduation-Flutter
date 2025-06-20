import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String? list;
  final Widget child;
  final Widget loadingWidget;
  const LoadingOverlay({
    Key? key,
    required this.list,
    required this.child,
    required this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (list == null || list!.isEmpty)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: loadingWidget,
            ),
          ),
      ],
    );
  }
}
