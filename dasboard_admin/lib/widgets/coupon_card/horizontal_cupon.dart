import 'package:dasboard_admin/modals/ticket_modal.dart';
import 'package:dasboard_admin/widgets/coupon_card/cupon_cart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalCouponExample2 extends StatefulWidget {
  const HorizontalCouponExample2({Key? key, required this.ticket})
      : super(key: key);
  final Ticket ticket;

  @override
  State<HorizontalCouponExample2> createState() =>
      _HorizontalCouponExample2State();
}

class _HorizontalCouponExample2State extends State<HorizontalCouponExample2> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xfff1e3d3);
    const Color secondaryColor = Color(0xffd88c9a);

    return CouponCard(
      height: 150,
      backgroundColor: primaryColor,
      clockwise: true,
      curvePosition: 135,
      curveRadius: 30,
      curveAxis: Axis.vertical,
      borderRadius: 10,
      firstChild: Container(
        decoration: const BoxDecoration(
          color: secondaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.ticket.DurationActive.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.ticket.Unit ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white54, height: 0),
            const Expanded(
              child: Center(
                child: Text(
                  'EDIT PLANING IS\nHERE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Planing Pricing',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.ticket.IdTicket!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              convertNumberToDateTimeString(widget.ticket.CreateAt!),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

convertInputDateTimetoNumber(String tiem) {
  String activeDate = tiem; // giá trị ngày tháng dưới dạng chuỗi
  DateTime dateTime =
      DateTime.parse(activeDate); // chuyển đổi thành đối tượng DateTime
  int timestamp = dateTime.millisecondsSinceEpoch; // chuyển đổi thành số
  return timestamp;
}

String convertNumberToDateTimeString(int number) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(number);
  final dateFormat = DateFormat('yyyy-MM-dd');
  String dateTimeString = dateFormat.format(dateTime);
  return dateTimeString;
}
