import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mdw_app/providers/main_screen_index_provider.dart';
import 'package:mdw_app/screens/bookmarks_screen.dart';
import 'package:mdw_app/screens/cart_screen.dart';
import 'package:mdw_app/screens/explore_screen.dart';
import 'package:mdw_app/screens/profile_screen.dart';
import 'package:mdw_app/screens/shop_screen.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
import 'code_verification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        appBar: provider.index == 3
            ? null
            : AppBar(
                backgroundColor: AppColors.white,
                centerTitle: provider.index == 0 ? false : true,
                title: provider.index == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Rupam",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : CustomAppBarTitle(
                        fontSize: 14,
                        title: provider.index == 0
                            ? ""
                            : provider.index == 1
                                ? "BROWSE BY CATEGORIES"
                                : provider.index == 2
                                    ? "BOOKMARKS"
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
                      icon: Icon(
                        CupertinoIcons.shopping_cart,
                        color: AppColors.black,
                      ),
                    ),
                  if (provider.index == 0)
                    SizedBox(
                      width: 10,
                    ),
                ],
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavBarIcon(
                onTap: (() {
                  setState(() {
                    provider.changeIndex(newIndex: 0);
                  });
                }),
                icon: provider.index == 0
                    ? "assets/bottom-bar-icons/coloured/icon-1.png"
                    : "assets/bottom-bar-icons/non-coloured/icon-1.png",
                text: "Shop",
                textColor: provider.index == 0
                    ? AppColors.selectedNavTextColor
                    : AppColors.black,
              ),
              BottomNavBarIcon(
                onTap: (() {
                  setState(() {
                    provider.changeIndex(newIndex: 1);
                  });
                }),
                icon: provider.index == 1
                    ? "assets/bottom-bar-icons/coloured/icon-2.png"
                    : "assets/bottom-bar-icons/non-coloured/icon-2.png",
                text: "Explore",
                spaceHeight: 8,
                upperExtraSpaceHeight: 2,
                textColor: provider.index == 1
                    ? AppColors.selectedNavTextColor
                    : AppColors.black,
              ),
              BottomNavBarIcon(
                onTap: (() {
                  setState(() {
                    provider.changeIndex(newIndex: 2);
                  });
                }),
                icon: provider.index == 2
                    ? "assets/bottom-bar-icons/coloured/icon-3.png"
                    : "assets/bottom-bar-icons/non-coloured/icon-3.png",
                text: "Bookmarks",
                textColor: provider.index == 2
                    ? AppColors.selectedNavTextColor
                    : AppColors.black,
              ),
              BottomNavBarIcon(
                onTap: (() {
                  setState(() {
                    provider.changeIndex(newIndex: 3);
                  });
                }),
                icon: provider.index == 3
                    ? "assets/bottom-bar-icons/coloured/icon-4.png"
                    : "assets/bottom-bar-icons/non-coloured/icon-4.png",
                text: "Account",
                textColor: provider.index == 3
                    ? AppColors.selectedNavTextColor
                    : AppColors.black,
              ),
            ],
          ),
        ),
        body: PopScope(
          canPop: provider.index == 0 ? true : false,
          onPopInvoked: ((val) {
            if (provider.index != 0) {
              provider.changeIndex(newIndex: 0);
            } else {
              return;
            }
          }),
          child: Builder(builder: ((ctx) {
            switch (provider.index) {
              case 0:
                return ShopScreen();
              case 1:
                return ExploreScreen();
              case 2:
                return BookmarksScreen();
              case 3:
                return ProfileScreen();
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
  });

  final String icon, text;
  final double? spaceHeight, upperExtraSpaceHeight;
  final Color textColor;
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
          Image.asset(icon),
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
