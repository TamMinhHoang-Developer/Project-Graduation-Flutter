// import 'package:flutter/material.dart';

// import '../../Constrant/constants.dart';
// import 'text_field_container.dart';

// class RoundedPasswordField extends StatefulWidget {
//   final String hintText;
//   final ValueChanged<String> onChanged;
//   final TextEditingController controller;
//   const RoundedPasswordField({
//     Key? key,
//     required this.onChanged,
//     required this.controller,
//     required this.hintText,
//   }) : super(key: key);

//   @override
//   State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
// }

// class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
//   bool obserText = true;
//   String error = "";
//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//         child: TextField(
//       controller: widget.controller,
//       obscureText: obserText,
//       onChanged: widget.onChanged,
//       decoration: InputDecoration(
//           hintText: widget.hintText,
//           icon: const Icon(
//             Icons.lock,
//           ),
//           suffixIcon: GestureDetector(
//             onTap: () {
//               setState(() {
//                 obserText = !obserText;
//               });
//             },
//             child: Icon(
//               obserText == true ? Icons.visibility : Icons.visibility_off,
//               color: Colors.black,
//             ),
//           ),
//           border: InputBorder.none),
//     ));
//   }
// }
