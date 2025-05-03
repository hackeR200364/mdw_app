import 'package:flutter/material.dart';
import 'package:mdw_app/models/cart_product_model.dart';
import 'package:mdw_app/screens/product_details_screen.dart';
import 'package:mdw_app/screens/shop_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';

import '../styles.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<CartProductModel> cartModel = [];

  @override
  void initState() {
    cartModel = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.white,
            expandedHeight: 40.0,
            flexibleSpace: TextFormField(
              controller: widget.searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                // Background color
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
          if (widget.searchController.text.isEmpty)
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  return GestureDetector(
                    onTap: (() {
                      widget.searchController.text = idx.toString();
                      setState(() {});
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                      child: const Align(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 11,
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
            ),
          // if (widget.searchController.text.isNotEmpty)
          //   const SliverToBoxAdapter(
          //     child: SizedBox(
          //       height: 10,
          //     ),
          //   ),
          if (widget.searchController.text.isNotEmpty)
            SliverAppBar(
              backgroundColor: AppColors.white,
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchingFilter(
                    onTap: (() {}),
                    text: "Sort",
                  ),
                  const SizedBox(width: 15),
                  SearchingFilter(
                    onTap: (() {}),
                    text: "Filter",
                  ),
                ],
              ),
            ),
          // if (widget.searchController.text.isNotEmpty)
          //   const SliverToBoxAdapter(
          //     child: SizedBox(
          //       height: 10,
          //     ),
          //   ),
          if (widget.searchController.text.isNotEmpty)
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
                            builder: (ctx) => const ProductDetailsScreen(),
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
                        onTapMinu: (() {
                          if (product.qnt > 1) {
                            setState(() {
                              product.qnt--;
                            });
                          } else if (product.qnt == 1) {
                            cartModel.removeAt(res["index"]);
                            setState(() {});
                          }
                        }),
                        onTapPlus: (() {
                          if (product.qnt <= 4) {
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
                        // cartModel.add(CartProductModel(
                        //     "$idx",
                        //     "Medicine Name of $idx",
                        //     "2600",
                        //     "assets/dettol.png",
                        //     1,
                        //     MedicineCategory.ay));
                        setState(() {});
                      }),
                      onTapProduct: (() async {
                        final index = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const ProductDetailsScreen(),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.black.withOpacity(0.05),
        ),
        child: Text(text),
      ),
    );
  }
}
