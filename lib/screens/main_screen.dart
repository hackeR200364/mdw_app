import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mdw_app/providers/main_screen_index_provider.dart';
import 'package:mdw_app/screens/cart_screen.dart';
import 'package:mdw_app/screens/explore_screen.dart';
import 'package:mdw_app/screens/medlist_screen.dart';
import 'package:mdw_app/screens/profile_screen.dart';
import 'package:mdw_app/screens/shop_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles.dart';
import 'code_verification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  Future<void> _launchCal() async {
    final url = Uri.parse('https://cal.com/mdwtherapy/session');
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  // int index = 0;

  // void _changeIndex(int newIndex) {
  //   setState(() {
  //     index = newIndex;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenIndexProvider>(builder: (ctx, provider, child) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: provider.index == 3 || provider.index == 0
            ? null
            : AppBar(
                backgroundColor: AppColors.white,
                centerTitle: provider.index == 0 ? false : true,
                title: provider.index == 0
                    ? null
                    : CustomAppBarTitle(
                        fontSize: 14,
                        title: provider.index == 0
                            ? ""
                            : provider.index == 1
                                ? "BROWSE BY CATEGORIES"
                                : provider.index == 2
                                    ? "MedList"
                                    : "ACCOUNT",
                      ),
                actions: [
                  if (provider.index == 0)
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const CartScreen(
                                    searchEnabled: true,
                                  )),
                        );
                        if (result != null) {
                          setState(() {
                            provider.changeIndex(newIndex: result);
                          });
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.shopping_cart,
                        color: AppColors.black,
                      ),
                    ),
                  if (provider.index == 0)
                    const SizedBox(
                      width: 10,
                    ),
                ],
              ),
        bottomNavigationBar: SizedBox(
          height: (provider.index == 0) ? 150 : 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (provider.index == 0)
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.lightGreen,
                        AppColors.green.withOpacity(0.9),
                        AppColors.green.withOpacity(0.85),
                        AppColors.lightGreen,
                        AppColors.lightGreen,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CALL US TO ORDER",
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: (() async {
                          if (await Permission.phone.serviceStatus.isEnabled) {
                            // await AppFunctions.callNumber("+919230976362");
                          } else {
                            Permission.phone.request();
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.black,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Text(
                            "CALL US",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 10, right: 10),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: BottomNavBarIcon(
                        onTap: (() {
                          setState(() {
                            provider.changeIndex(newIndex: 0);
                          });
                        }),
                        icon: Icons.storefront,
                        text: "Shop",
                        iconColor: provider.index == 0
                            ? AppColors.selectedIconColor
                            : AppColors.black,
                        textColor: provider.index == 0
                            ? AppColors.selectedNavTextColor
                            : AppColors.black,
                      ),
                    ),
                    Expanded(
                      child: BottomNavBarIcon(
                        onTap: (() {
                          setState(() {
                            provider.changeIndex(newIndex: 1);
                          });
                        }),
                        icon: Icons.search_outlined,
                        iconColor: provider.index == 1
                            ? AppColors.selectedIconColor
                            : AppColors.black,
                        text: "Explore",
                        textColor: provider.index == 1
                            ? AppColors.selectedNavTextColor
                            : AppColors.black,
                      ),
                    ),
                    //add here
                    Expanded(
                      child: GestureDetector(
                        onTap: (() async {
                          await _launchCal();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: ((_) => const CalBookingPage()),
                          //   ),
                          // );
                        }),
                        child: Column(
                          children: [
                            Container(
                              height: 28,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.green),
                                image: const DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image: AssetImage(
                                    "assets/bottom-bar-icons/injury.png",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              "Wellness",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: BottomNavBarIcon(
                        onTap: (() {
                          setState(() {
                            provider.changeIndex(newIndex: 2);
                          });
                        }),
                        icon: Icons.bookmark_border_rounded,
                        text: "MedList",
                        iconColor: provider.index == 2
                            ? AppColors.selectedIconColor
                            : AppColors.black,
                        textColor: provider.index == 2
                            ? AppColors.selectedNavTextColor
                            : AppColors.black,
                      ),
                    ),
                    Expanded(
                      child: BottomNavBarIcon(
                        onTap: (() {
                          setState(() {
                            provider.changeIndex(newIndex: 3);
                          });
                        }),
                        icon: Icons.person_outline_rounded,
                        text: "Account",
                        iconColor: provider.index == 3
                            ? AppColors.selectedIconColor
                            : AppColors.black,
                        textColor: provider.index == 3
                            ? AppColors.selectedNavTextColor
                            : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: PopScope(
          canPop: provider.index == 0
              ? true
              : (provider.index == 1 && searchController.text.trim().isEmpty)
                  ? false
                  : false,
          onPopInvoked: ((val) {
            // log((provider.index == 1 && searchController.text.trim().isEmpty)
            //         .toString() +
            //     "Bug is here");
            if (provider.index != 0 && provider.index != 1) {
              provider.changeIndex(newIndex: 0);
            } else if (provider.index == 1 &&
                searchController.text.trim().isNotEmpty) {
              searchController.clear();
            } else if (provider.index == 1 &&
                searchController.text.trim().isEmpty) {
              provider.changeIndex(newIndex: 0);
            } else {
              return;
            }
          }),
          child: Builder(builder: ((ctx) {
            switch (provider.index) {
              case 0:
                return const ShopScreen();
              case 1:
                return ExploreScreen(searchController: searchController);
              case 2:
                return const BookmarksScreen();
              case 3:
                return const ProfileScreen();
            }
            return Container();
          })),
        ),
      );
    });
  }
}

class BottomNavBarIcon extends StatelessWidget {
  const BottomNavBarIcon({
    super.key,
    required this.icon,
    required this.text,
    this.spaceHeight,
    this.upperExtraSpaceHeight,
    required this.textColor,
    required this.onTap,
    this.iconSize,
    required this.iconColor,
  });

  final String text;
  final IconData icon;
  final double? spaceHeight, upperExtraSpaceHeight, iconSize;
  final Color textColor, iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: upperExtraSpaceHeight,
          ),
          Icon(
            icon,
            size: iconSize ?? 27,
            color: iconColor,
          ),
          SizedBox(
            height: spaceHeight ?? 5,
          ),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
