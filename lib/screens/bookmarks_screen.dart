import 'package:flutter/material.dart';
import 'package:mdw_app/screens/product_details_screen.dart';

import '../styles.dart';
import 'explore_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
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
                    child: Row(
                      children: [
                        Image.asset("assets/medicine-medium.png"),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "MRP ₹mrp",
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 8),
                              decoration: BoxDecoration(
                                color: AppColors.individualAddBtnColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  "MOVE TO CART",
                                ),
                              ),
                            )
                          ],
                        )
                      ],
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
