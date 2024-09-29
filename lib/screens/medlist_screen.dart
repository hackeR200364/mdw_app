import 'package:flutter/material.dart';
import 'package:mdw_app/screens/product_details_screen.dart';

import '../models/cart_product_model.dart';
import '../services/app_function_services.dart';
import '../styles.dart';
import 'explore_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late TextEditingController _searchController;
  List<CartProductModel> cartModel = [];

  @override
  void initState() {
    _searchController = TextEditingController();
    cartModel = [
      CartProductModel("1", "Medicine Name of 2", "1000", "assets/dettol.png",
          3, MedicineCategory.es),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.white,
            expandedHeight: 40.0,
            flexibleSpace: TextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                // Background color
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  borderSide: BorderSide.none, // No visible border
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverAppBar(
            backgroundColor: AppColors.white,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SearchingFilter(
                  onTap: (() {}),
                  text: "Sort",
                ),
                SizedBox(width: 15),
                SearchingFilter(
                  onTap: (() {}),
                  text: "Filter",
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) {
                return GestureDetector(
                  onTap: (() async {
                    final index = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ProductDetailsScreen(),
                      ),
                    );

                    if (index == 1) {}
                  }),
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: idx != 0 ? 10 : 0, bottom: 10, left: 5, right: 5),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: AppColors.black.withOpacity(0.5),
                      //     // Shadow color
                      //     offset: Offset(1, 2),
                      //     // Horizontal and vertical offset (right and bottom)
                      //     blurRadius: 5, // Blur effect
                      //   ),
                      // ],
                    ),
                    child: Builder(
                      builder: (context) {
                        final res =
                            AppFunctions.findProductInCart("$idx", cartModel);
                        if (res["exists"]) {
                          CartProductModel product = cartModel[res["index"]];
                          return Row(
                            children: [
                              Image.asset(product.img),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.pname,
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "MRP ₹${product.pmrp}",
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomAddQntBtn(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    qnt: product.qnt,
                                    onTapMinus: (() {
                                      if (product.qnt >= 1) {
                                        setState(() {
                                          product.qnt--;
                                        });
                                      }
                                    }),
                                    onTapPlus: (() {
                                      if (product.qnt <= 9) {
                                        setState(() {
                                          product.qnt++;
                                        });
                                      }
                                    }),
                                  )
                                ],
                              )
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Image.asset("assets/medicine-medium.png"),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Demo Medicine Name",
                                        style: TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "MRP ₹200",
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      cartModel.add(CartProductModel(
                                          "$idx",
                                          "Medicine Name of $idx",
                                          "2600",
                                          "assets/dettol.png",
                                          1,
                                          MedicineCategory.ay));
                                    }),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              8),
                                      decoration: BoxDecoration(
                                        color: AppColors.individualAddBtnColor,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "MOVE TO CART",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
