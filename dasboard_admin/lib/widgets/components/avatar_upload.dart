import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AvatarUpload extends StatefulWidget {
  AvatarUpload({
    super.key,
    required this.image,
  });

  String image;
  @override
  // ignore: library_private_types_in_public_api
  _AvatarUploadState createState() => _AvatarUploadState();
}

class _AvatarUploadState extends State<AvatarUpload> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEvent event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (PointerEvent event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _isHovering ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
        ),
        child: CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage(widget.image),
          child: Visibility(
            visible: _isHovering,
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: const Icon(Icons.upload),
            ),
          ),
        ),
      ),
    );
  }
}
