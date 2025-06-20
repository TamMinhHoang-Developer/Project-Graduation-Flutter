import 'package:client_user/modal/custom_modal/home_category.dart';
import 'package:client_user/modal/custom_modal/home_special.dart';
import 'package:client_user/screens/home/components/special_offer_widget.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

typedef WaltingSetUpOnTapSeeAll = void Function();

class WaltingSetUp extends StatefulWidget {
  final WaltingSetUpOnTapSeeAll? onTapSeeAll;
  const WaltingSetUp(
      {super.key,
      this.onTapSeeAll,
      required this.category,
      required this.specials});
  final List<Category> category;
  final List<SpecialOffer> specials;

  @override
  State<WaltingSetUp> createState() => _WaltingSetUpState();
}

class _WaltingSetUpState extends State<WaltingSetUp> {
  // late final List<Category> categories = homeCategries;
  // late final List<SpecialOffer> specials = homeSpecialOffers;
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 10),
        Stack(children: [
          Container(
            height: 181,
            decoration: const BoxDecoration(
              color: Color(0xFFE7E7E7),
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: PageView.builder(
              itemBuilder: (context, index) {
                final data = widget.specials[index];
                return SpecialOfferWidget(context, data: data, index: index);
              },
              itemCount: widget.specials.length,
              allowImplicitScrolling: true,
              onPageChanged: (value) {
                setState(() => selectIndex = value);
              },
            ),
          ),
          _buildPageIndicator()
        ]),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Set Up Now',
            style: textBigQuicksan,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.specials.length; i++) {
      list.add(i == selectIndex ? _indicator(true) : _indicator(false));
    }
    return Container(
      height: 181,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: 4.0,
        width: isActive ? 16 : 4.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: isActive ? const Color(0XFF101010) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
