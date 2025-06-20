import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/screens/home/components/box_content_manager.dart';
import 'package:client_user/screens/manage_product/screen_manager_product.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var userId = "";
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    final controller = Get.put(AuthenticationRepository());
    final homeController = Get.put(HomeController());
    controller.checkData(userId);
    homeController.checkTotalTable(userId);
    homeController.checkTotalSeller(userId);
    homeController.checkTotalProduct(userId);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(sDashboardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  tHomeTitle + controller.user.value.Email.toString(),
                  style: textXLQuicksan,
                )),
            Text(
              tHomeHeading,
              style: textBigQuicksan,
            ),
            const SizedBox(
              height: sDashboardPadding,
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(left: BorderSide(width: 4))),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tHomeSearch,
                    style: textBigQuicksan,
                  ),
                  const Icon(
                    Icons.mic,
                    size: 25,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: sDashboardPadding,
            ),
            SizedBox(
              height: 50,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Obx(() => BoxContentManager(
                          nameManager: "PR",
                          subnameManager: "Product",
                          total: homeController.totalProduct.toInt(),
                          onPressed: () {
                            Get.to(() => const ScreenManagerProduct());
                          },
                        )),
                    Obx(() => BoxContentManager(
                          nameManager: "SE",
                          subnameManager: "Seller",
                          total: homeController.totalSeller.toInt(),
                        )),
                    Obx(
                      () => BoxContentManager(
                        nameManager: "TA",
                        subnameManager: "Table",
                        total: homeController.totalTable.toInt(),
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: sDashboardPadding,
            ),

            // Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: sparatorColor),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(child: Icon(Icons.bookmark)),
                            Flexible(
                              child: Image.asset(
                                iHomeContent1,
                                height: 100,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          tHomeBannerTitle1,
                          style: textXLQuicksanBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          tHomeBannerTitle2,
                          style: textNormalQuicksan,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: sDashboardCardPadding,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: sparatorColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(child: Icon(Icons.bookmark)),
                              Flexible(
                                  child: Image.asset(
                                iHomeContent1,
                                height: 80,
                              ))
                            ],
                          ),
                          Text(
                            tHomeBannerTitle1,
                            style: textXLQuicksanBold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            tHomeBannerTitle2,
                            style: textNormalQuicksan,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(color: bgBlack, width: 5.0),
                              ),
                              foregroundColor: bgBlack,
                              backgroundColor: bgWhite,
                              padding: const EdgeInsets.symmetric(
                                  vertical: sButtonHeight)),
                          onPressed: () {
                            controller.logout();
                          },
                          child: Text(
                            tHomeButton,
                            style: textXLQuicksanBold,
                          )),
                    )
                  ],
                )),
              ],
            ),

            const SizedBox(
              height: sDashboardPadding,
            ),

            Text(
              tHomeTopProduct,
              style: textBigQuicksan,
            ),
            SizedBox(
              height: 200,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: size.width - 40,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: sparatorColor),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Flutter Crash Course",
                                      style: textNormalKanit,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Image.asset(
                                      iHomeContent1,
                                      height: 110,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: bgBlack,
                                          elevation: 0,
                                          shape: const CircleBorder()),
                                      onPressed: () {},
                                      child: const Icon(Icons.play_arrow)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "3 Section",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "fwefwefwe",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width - 40,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: sparatorColor),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Flutter Crash Course",
                                      style: textNormalKanit,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Image.asset(
                                      iHomeContent1,
                                      height: 110,
                                    ),
                                  )
                                ],
                              ),
                              // Text(box.read("idCredential")),
                              Row(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: bgBlack,
                                          elevation: 0,
                                          shape: const CircleBorder()),
                                      onPressed: () {},
                                      child: const Icon(Icons.play_arrow)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "3 Section",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "fwefwefwe",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width - 40,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: sparatorColor),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Flutter Crash Course",
                                      style: textNormalKanit,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Flexible(
                                    child: Image.asset(
                                      iHomeContent1,
                                      height: 110,
                                    ),
                                  )
                                ],
                              ),
                              // Text(box.read("idCredential")),
                              Row(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: bgBlack,
                                          elevation: 0,
                                          shape: const CircleBorder()),
                                      onPressed: () {},
                                      child: const Icon(Icons.play_arrow)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "3 Section",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "fwefwefwe",
                                        style: textNormalQuicksan,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
