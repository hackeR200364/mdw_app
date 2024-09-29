import 'package:flutter/material.dart';
import 'package:mdw_app/models/cart_product_model.dart';
import 'package:mdw_app/screens/product_details_screen.dart';
import 'package:mdw_app/screens/shop_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';

import '../styles.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late TextEditingController _searchController;
  List<CartProductModel> cartModel = [];

  @override
  void initState() {
    cartModel = [
      CartProductModel("2", "Medicine Name of 2", "1000", "assets/dettol.png",
          2, MedicineCategory.es),
    ];
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
          if (_searchController.text.isEmpty)
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  return GestureDetector(
                    onTap: (() {
                      _searchController.text = idx.toString();
                    }),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: idx % 2 != 0
                            ? AppColors.exploreCardOrangeColor.withOpacity(0.1)
                            : AppColors.exploreCardGreenColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: idx % 2 != 0
                              ? AppColors.exploreCardOrangeColor
                                  .withOpacity(0.7)
                              : AppColors.exploreCardGreenColor
                                  .withOpacity(0.7),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Summer",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 11,
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
            ),
          if (_searchController.text.isNotEmpty)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          if (_searchController.text.isNotEmpty)
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
          if (_searchController.text.isNotEmpty)
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
          if (_searchController.text.isNotEmpty)
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  final res = AppFunctions.findProductInCart("$idx", cartModel);
                  if (res["exists"]) {
                    CartProductModel product = cartModel[res["index"]];
                    return CustomProductContainer(
                      onTapProduct: (() async {
                        final index = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ProductDetailsScreen(),
                          ),
                        );

                        if (index == 1) {}
                      }),
                      btnHeight: 40,
                      image: product.img,
                      name: product.pname,
                      mrp: product.pmrp,
                      child: CustomAddQntBtn(
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
                      ),
                    );
                  } else {
                    return CustomProductContainer(
                      onTapAdd: (() {
                        cartModel.add(CartProductModel(
                            "$idx",
                            "Medicine Name of $idx",
                            "2600",
                            "assets/dettol.png",
                            1,
                            MedicineCategory.ay));
                      }),
                      onTapProduct: (() async {
                        final index = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ProductDetailsScreen(),
                          ),
                        );

                        if (index == 1) {}
                      }),
                      btnHeight: 40,
                      image: "assets/medicine-small.png",
                      name: "Liveasy",
                      mrp: "250",
                    );
                  }
                },
                childCount: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 11 / 16,
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
            ),
        ],
      ),
    );
  }
}

class SearchingFilter extends StatelessWidget {
  const SearchingFilter({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.black.withOpacity(0.05),
        ),
        child: Text(text),
      ),
    );
  }
}
