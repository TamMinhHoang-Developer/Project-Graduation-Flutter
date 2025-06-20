import 'package:dasboard_admin/controllers/ticket_controller.dart';
import 'package:dasboard_admin/screens/manager_user/manager_walting/components/cart_item_walting.dart';
import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:dasboard_admin/widgets/components/button_bottom_custom.dart';
import 'package:dasboard_admin/widgets/coupon_card/horizontal_cupon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketOverviewScreen extends StatefulWidget {
  const TicketOverviewScreen({super.key});

  @override
  State<TicketOverviewScreen> createState() => _TicketOverviewScreenState();
}

class _TicketOverviewScreenState extends State<TicketOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cu = Get.put(TicketController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            "Manager Ticket",
            style: textAppKanit,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height - 150,
                    width: size.width - 40,
                    child: Obx(
                      () {
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              cu.ticketList[index].ticket != null
                                  ? HorizontalCouponExample2(
                                      ticket: cu.ticketList[index].ticket!)
                                  : const CircularProgressIndicator(),
                          // ignore: invalid_use_of_protected_member
                          itemCount: cu.ticketList.value.length,
                          padding: const EdgeInsets.only(bottom: 50 + 16),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 0),
                        );
                      },
                    ),
                  ),
                  const ButtonBottomCustom(),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
