import 'package:dasboard_admin/modals/ticket_modal.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class CartItemWalting extends StatefulWidget {
  CartItemWalting({super.key, required this.tiket});
  Ticket tiket;

  @override
  State<CartItemWalting> createState() => _CartItemWaltingState();
}

class _CartItemWaltingState extends State<CartItemWalting> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {},
            foregroundColor: Colors.black,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        // ignore: invalid_use_of_protected_member
                        "Name Plan: ${widget.tiket.Name}",
                        style: textNormalKanitBold),
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Text(
                          // ignore: invalid_use_of_protected_member
                          "Duration: ${widget.tiket.DurationActive} ${widget.tiket.Unit}",
                          style: textNormalQuicksanBold,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
