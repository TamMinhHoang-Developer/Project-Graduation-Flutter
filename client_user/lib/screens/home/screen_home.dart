// ignore_for_file: unnecessary_null_comparison
import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/controller/manage_table.dart';
import 'package:client_user/controller/message_helper.dart';
import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/modal/custom_modal/home_category.dart';
import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/screens/home/components/box_content_manager.dart';
import 'package:client_user/screens/home/components/category_catalog.dart';
import 'package:client_user/screens/home/components/search_bar.dart';
import 'package:client_user/screens/home/drawer/drawer_header.dart';
import 'package:client_user/screens/home/set_up/walting_setup.dart';
import 'package:client_user/screens/login/screen_login.dart';
import 'package:client_user/screens/manage_history/screen_history.dart';
import 'package:client_user/screens/manage_order/screen_homev5.dart';
import 'package:client_user/screens/manage_order/screen_order.dart';
import 'package:client_user/screens/manage_product/screen_manager_product.dart';
import 'package:client_user/screens/manager_seller/screen_manager_seller.dart';
import 'package:client_user/screens/manager_statistical/screen_manage_statistical.dart';
import 'package:client_user/screens/manager_table/screen_manage_table.dart';
import 'package:client_user/screens/nofication/read_list_nofication.dart';
import 'package:client_user/screens/profile/screen_profile.dart';
import 'package:client_user/screens/screen_news/screen_news.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final box = GetStorage();
  var userId = "";
  var count = 0;
  var currentPage = DrawerSections.dashboard;
  final List<SpecialOffer> specialOffer = [];

  final controller = Get.put(AuthenticationRepository());
  final tableController = Get.put(ManageTableController());
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    // Get Total Message
    MessageHelper.getCountMessage().then((value) {
      setState(() {
        if (count > 0) {
          count = 0;
        } else {
          count = value;
        }
      });
    });

    // Handler Tap Notification
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      MessageHelper.fcmOpenMessageHandler(
          message: remoteMessage,
          context: context,
          messageHandler: (context, message) {
            // Điều hướng đến trang hiển thị chi tiết thông báo.
            Get.to(() => const ScreenNews());
          });
    });

    // Handler Tap In Terminal
    FirebaseMessaging.instance.getInitialMessage().then((value) => {
          if (value != null)
            {
              MessageHelper.fcmOpenMessageHandler(
                  message: value,
                  context: context,
                  messageHandler: (context, message) {
                    // Điều hướng đến trang hiển thị chi tiết thông báo.
                    if (FirebaseAuth.instance.currentUser != null) {
                      Get.to(() => const ScreenNews());
                    } else {
                      Get.to(() => const ScreenLogin());
                    }
                  })
            }
        });

    FirebaseMessaging.onMessage.listen((event) {
      MessageHelper.fcm_ForegroundHandler(
          message: event,
          context: context,
          messageHandler: (context, message) {
            MessageHelper.getCountMessage().then((value) {
              setState(() {
                count = value;
              });
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      userId = "";
    }

    controller.checkData(userId);
    controller.bindingUser(userId);
    controller.bindingAdminUser();

    tableController.getListTable(userId);
    homeController.checkTotalTable(userId);
    homeController.checkTotalSeller(userId);
    homeController.checkTotalProduct(userId);

    if (specialOffer.isNotEmpty) {
      specialOffer.clear();
    }

    if (homeController.totalProduct.value.toInt() == 0) {
      if (!specialOffer.contains(SpecialOffer(
        discount: 'Product',
        title: "Manager Product For Now!",
        detail: 'Create Product Now',
        icon: iSetup2,
      ))) {
        specialOffer.add(SpecialOffer(
          discount: 'Product',
          title: "Manager Product For Now!",
          detail: 'Create Product Now',
          icon: iSetup2,
        ));
      }
    }

    if (homeController.totalSeller.value.toInt() == 0) {
      if (!specialOffer.contains(
        SpecialOffer(
          discount: 'Seller',
          title: "Manager Seller For Now!",
          detail: 'Create Seller Now',
          icon: iSetup3,
        ),
      )) {
        specialOffer.add(
          SpecialOffer(
            discount: 'Seller',
            title: "Manager Seller For Now!",
            detail: 'Create Seller Now',
            icon: iSetup3,
          ),
        );
      }
    }

    if (homeController.totalTable.value.toInt() == 0) {
      if (!specialOffer.contains(
        SpecialOffer(
          discount: 'Table',
          title: "Manager Table For Now!",
          detail: 'Create Table Now',
          icon: iSetup1,
        ),
      )) {
        specialOffer.add(SpecialOffer(
          discount: 'Table',
          title: "Manager Table For Now!",
          detail: 'Create Table Now',
          icon: iSetup1,
        ));
      }
    }

    return WillPopScope(
      onWillPop: () async {
        bool confirmExit = await confirm(
          context,
          ConfirmDialog(
            'Are you sure?',
            message: "Do you want to exit the application?",
            variant: Variant.warning,
            confirmed: () {
              Navigator.of(context).pop(true);
              controller.logout();
            },
            canceled: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
          ),
        );

        return confirmExit ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.black),
            ),
            title: Text(
              tAppName,
              style: textAppKanit,
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20, top: 7),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: badges.Badge(
                  badgeContent: Text(
                    "$count",
                    style: textNormalQuicksanBoldWhite,
                  ),
                  position: badges.BadgePosition.topEnd(top: -7, end: -7),
                  showBadge: count > 0,
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                  child: IconButton(
                    onPressed: () {
                      if (count > 0) {
                        Get.to(() => const ReadListNofication());
                        setState(() {
                          count = 0;
                        });
                      }
                    },
                    icon: Obx(() {
                      final user = controller.users.value.user;
                      if (user == null) {
                        return Image.asset(iHomeProfileTemp2);
                      } else if (user.Avatar == null || user.Avatar == "") {
                        return Image.asset(iHomeProfileTemp2);
                      } else {
                        return Image(image: NetworkImage(user.Avatar!));
                      }
                    }),
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: SingleChildScrollView(
              // ignore: avoid_unnecessary_containers
              child: Container(
                child: Column(
                  children: [
                    Obx(() => MyHeaderDrawer(
                          user: controller.users.value.user,
                        )),
                    MyDrawerList()
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(sDashboardPadding),
                child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$tHomeTitle${controller.users.value.user!.Email}",
                          style: textXLQuicksan,
                        ),
                        if (homeController.totalProduct.value.toInt() > 0 &&
                            homeController.totalSeller.value.toInt() > 0 &&
                            homeController.totalTable.value.toInt() > 0)
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tHomeHeading,
                                  style: textBigQuicksan,
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
                                              total: homeController.totalProduct
                                                  .toInt(),
                                              onPressed: () {
                                                Get.to(() =>
                                                    const ScreenManagerProduct());
                                              },
                                            )),
                                        Obx(() => BoxContentManager(
                                              nameManager: "SE",
                                              subnameManager: "Seller",
                                              total: homeController.totalSeller
                                                  .toInt(),
                                              onPressed: () {
                                                Get.to(() =>
                                                    const ScreenManageSeller());
                                              },
                                            )),
                                        Obx(
                                          () => BoxContentManager(
                                            nameManager: "TA",
                                            subnameManager: "Table",
                                            total: homeController.totalTable
                                                .toInt(),
                                            onPressed: () {
                                              Get.to(() =>
                                                  const ScreenManageTable());
                                            },
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: [
                              WaltingSetUp(
                                onTapSeeAll: () {},
                                category: const [],
                                specials: specialOffer,
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: sDashboardPadding,
                        ),
                        Text(
                          tHomeTopProduct,
                          style: textBigQuicksan,
                        ),
                        const SizedBox(
                          height: sDashboardPadding,
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              if (homeController.totalTable.value.toInt() > 0)
                                SizedBox(
                                  child: Column(
                                    children: [
                                      const SearchBars(),
                                      const CategoriesCatalog(),
                                      const SizedBox(
                                        height: sDashboardPadding,
                                      ),
                                      SizedBox(
                                        height: 500,
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                2, // Số cột trong lưới
                                            childAspectRatio:
                                                1, // Tỷ lệ khung hình của mỗi phần tử trong lưới
                                            crossAxisSpacing:
                                                10.0, // khoảng cách giữa các phần tử trong cột
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemCount:
                                              tableController.users.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (tableController
                                                        .users[index].table !=
                                                    null) {
                                                  if (tableController
                                                          .users[index]
                                                          .table!
                                                          .Status ==
                                                      "Walting") {
                                                    Get.to(() => ExampleScreen(
                                                        table: tableController
                                                            .users[index]
                                                            .table!));
                                                  } else {
                                                    Get.to(() => ScreenOrder(
                                                        table: tableController
                                                            .users[index]
                                                            .table!));
                                                  }
                                                }
                                              },
                                              child: Obx(() => Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: tableController
                                                                    .users[
                                                                        index]
                                                                    .table !=
                                                                null
                                                            ? tableController
                                                                        .users[
                                                                            index]
                                                                        .table!
                                                                        .Status ==
                                                                    "Walting"
                                                                ? sinbad
                                                                : sparatorColor
                                                            : Colors.white),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      " ${tableController.users[index].table!.Name!}",
                                                      style: textXLQuicksanBold,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              else
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            iHomeNoData,
                                            width: 200,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[
                                              200], // màu nền của đoạn văn bản
                                          borderRadius: BorderRadius.circular(
                                              8.0), // bo tròn cạnh của hộp
                                        ),
                                        padding: const EdgeInsets.all(
                                            10.0), // khoảng cách giữa nội dung và cạnh của hộp
                                        child: const Text(
                                          'Currently there is no data about your table. Please make more tables',
                                          style: TextStyle(fontSize: 16.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: sDashboardPadding,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.to(
                                              () => const ScreenManageTable());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          shape: const StadiumBorder(),
                                          foregroundColor: bgBlack,
                                          backgroundColor: padua,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 20),
                                        ),
                                        child: SizedBox(
                                          width: 250,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Go to add new Tables"
                                                  .toUpperCase()),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(
                                                  Icons.arrow_forward_ios)
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        )
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  Widget menuItem(
      int id, IconData icon, String text, bool selected, VoidCallback? fun) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.table;
              Get.to(() => const ScreenManageTable())!
                  .then((_) => currentPage = DrawerSections.dashboard);
            } else if (id == 3) {
              currentPage = DrawerSections.seller;
              Get.to(() => const ScreenManageSeller())!
                  .then((_) => currentPage = DrawerSections.dashboard);
            } else if (id == 4) {
              currentPage = DrawerSections.product;
              Get.to(() => const ScreenManagerProduct())!
                  .then((_) => currentPage = DrawerSections.dashboard);
            } else if (id == 5) {
              currentPage = DrawerSections.history;
              Get.to(() => const ScreenHistory());
            } else if (id == 6) {
              currentPage = DrawerSections.statistical;
              Get.to(() => const ScreenManageStatistical());
            } else if (id == 7) {
              currentPage = DrawerSections.profile;
              Get.to(() => const ScreenProfile());
            } else if (id == 8) {
              currentPage = DrawerSections.logout;
              controller.logout();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              )),
              Expanded(
                flex: 3,
                child: Text(
                  text,
                  style: textXLQuicksan,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          menuItem(1, Icons.dashboard_outlined, "Dashboard",
              currentPage == DrawerSections.dashboard ? true : false, () {}),
          menuItem(2, Icons.table_restaurant_rounded, "Table",
              currentPage == DrawerSections.table ? true : false, () {}),
          menuItem(3, Icons.supervised_user_circle_sharp, "Seller",
              currentPage == DrawerSections.seller ? true : false, () {}),
          menuItem(4, Icons.production_quantity_limits, "Product",
              currentPage == DrawerSections.product ? true : false, () {}),
          const Divider(
            thickness: 2,
          ),
          menuItem(5, Icons.blinds_closed, "History",
              currentPage == DrawerSections.history ? true : false, () {}),
          menuItem(6, Icons.bar_chart_outlined, "Statistical",
              currentPage == DrawerSections.statistical ? true : false, () {}),
          menuItem(7, Icons.person_pin_sharp, "Profile",
              currentPage == DrawerSections.profile ? true : false, () {}),
          menuItem(8, Icons.logout, "LogOut",
              currentPage == DrawerSections.logout ? true : false, () {}),
        ],
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  table,
  seller,
  product,
  history,
  statistical,
  profile,
  logout
}
