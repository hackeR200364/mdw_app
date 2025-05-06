import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw_app/models/cart_product_model.dart';
import 'package:mdw_app/screens/login_screen.dart';
import 'package:mdw_app/screens/product_details_screen.dart';
import 'package:mdw_app/screens/shop_screen.dart';

import '../models/all_products_model.dart';
import '../models/cart_items_model.dart';
import '../models/orders_type_model.dart';
import '../models/user_login_model.dart';
import '../services/app_function_services.dart';
import '../services/app_keys.dart';
import '../services/storage_services.dart';
import '../styles.dart';
import '../utils/snack_bar_utils.dart';

enum SortOption {
  nameAscending,
  nameDescending,
  priceLowToHigh,
  priceHighToLow,
  newestFirst,
  oldestFirst,
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<CartProductModel> cartModel = [];
  AllProductsListModel? allProducts;
  List<AllProductsModel> filteredProducts = [];
  List<OrdersTypeModel> category = [], doseTypes = [];
  bool showFiltered = false, showSort = false;
  OrdersTypeModel? selectedCat, selectedDose;
  String searchQuery = "";
  SortOption sortOption = SortOption.nameAscending;
  CartListResponse? cartItems;
  UserLoginModel? user;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await getUserData();
    await getCart();
    await getProducts();
  }

  void removeDuplicatesByProductId(AllProductsListModel allProductsList) {
    Set<String> seenIds = {};
    allProductsList.data.removeWhere((product) {
      if (seenIds.contains(product.productId)) {
        return true; // Remove this product (duplicate productId)
      } else {
        seenIds.add(product.productId);
        return false; // Keep this product (first time seeing this productId)
      }
    });
  }

  getProducts() async {
    Uri uri = Uri.parse(
        AppKeys.baseUrlKey + AppKeys.productKey + AppKeys.allProductsKey);
    http.get(uri).then((res) async {
      log(res.statusCode.toString());
      if (res.statusCode == 200) {
        log((res.contentLength ?? 0).toString());
        try {
          allProducts = AllProductsListModel.fromRawJson(res.body);

          if (allProducts != null) {
            removeDuplicatesByProductId(allProducts!);

            List<String> distinctCategories =
                allProducts!.data.map((e) => e.category.name).toSet().toList();

            distinctCategories.insert(0, "ALL");

            category = List.generate(
              distinctCategories.length,
              (index) => OrdersTypeModel(
                type: distinctCategories[index],
                index: index,
              ),
            );

            List<String> distinctDoseTypes = allProducts!.data
                .map((e) => e.dosageType.name)
                .toSet()
                .toList();

            doseTypes = List.generate(
                distinctDoseTypes.length,
                (index) => OrdersTypeModel(
                      type: distinctDoseTypes[index],
                      index: index,
                    ));
            setState(() {});
          }
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(AppSnackBar().customizedAppSnackBar(
            message: "Something went wrong \n $e",
            context: context,
          ));
        }
      }
    });
  }

  filterProducts() {
    filteredProducts = allProducts!.data.where((element) {
      // Handle category filter
      final categoryMatch = selectedCat == null ||
          selectedCat!.type == "ALL" ||
          element.category.name == selectedCat!.type;

      // Handle dosage type filter
      final dosageMatch = selectedDose == null ||
          selectedDose!.type == "ALL" ||
          element.dosageType.name == selectedDose!.type;

      return categoryMatch && dosageMatch;
    }).toList();

    // Apply search filter if query exists
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((element) {
        return element.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    sortFilteredProducts(sortOption);

    log('Filtered products count: ${filteredProducts.length}');
  }

  void sortFilteredProducts(SortOption sortOption) {
    if (filteredProducts.isEmpty) return;

    switch (sortOption) {
      case SortOption.nameAscending:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDescending:
        filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceLowToHigh:
        filteredProducts.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case SortOption.priceHighToLow:
        filteredProducts.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.newestFirst:
        filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldestFirst:
        filteredProducts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }

  getUserData() async {
    user = await StorageServices.getUser();
    if (user != null) {
      log(user!.token.toString());
    }
  }

  Future<void> getCart() async {
    if (user != null) {
      http.Response res = await http.get(
          Uri.parse(AppKeys.baseUrlKey +
              AppKeys.apiUrlKey +
              AppKeys.cartKey +
              AppKeys.getCartKey),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          });

      log(res.statusCode.toString());
      log(res.body.toString());

      if (res.statusCode == 200) {
        cartItems = CartListResponse.fromRawJson(res.body);
      } else if (res.statusCode == 401) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar().customizedAppSnackBar(
            message: "User not logged in",
            context: context,
          ));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const LoginScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar().customizedAppSnackBar(
              message: 'Something went wrong', context: context));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allProducts == null) {
      return const CustomLoadingIndicator();
    } else {
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
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  // Background color
                  hintText: 'Search',
                  // prefixIcon: const Icon(
                  //   Icons.search,
                  //   color: Colors.black,
                  // ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      onPressed: (() {
                        filterProducts();
                        if (searchQuery.isEmpty) {
                          showFiltered = true;
                        }
                        setState(() {});
                      }),
                      icon: Icon(Icons.search),
                    ),
                  ),
                  prefix: (selectedCat != null || selectedDose != null)
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "${selectedCat?.type ?? ""}${(selectedCat != null && selectedDose != null) ? ", " : ""}${selectedDose?.type ?? ""}",
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    // Rounded corners
                    borderSide: BorderSide.none, // No visible border
                  ),
                ),
                onChanged: ((q) {
                  searchQuery = q;
                  filterProducts();
                  setState(() {});
                }),
                onFieldSubmitted: ((q) {
                  searchQuery = q;
                  filterProducts();
                  showFiltered = true;
                  setState(() {});
                }),
              ),
            ),
            if (!showFiltered)
              const SliverToBoxAdapter(
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!showFiltered)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
            if (!showFiltered)
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    return GestureDetector(
                      onTap: (() {
                        if (selectedCat != null && selectedCat!.index == idx) {
                          selectedCat = null;
                        } else {
                          selectedCat = category[idx];
                        }
                        filterProducts();
                        setState(() {});
                      }),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              selectedCat != null && selectedCat!.index == idx
                                  ? AppColors.exploreCardOrangeColor
                                  : AppColors.exploreCardOrangeColor
                                      .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.exploreCardOrangeColor
                                .withOpacity(0.7),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category[idx].type,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: category.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 16 / 4,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
              ),
            if (!showFiltered)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
            if (!showFiltered)
              const SliverToBoxAdapter(
                child: Text(
                  "Dose Types",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!showFiltered)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
            if (!showFiltered)
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    return GestureDetector(
                      onTap: (() {
                        if (selectedDose != null &&
                            selectedDose!.index == idx) {
                          selectedDose = null;
                        } else {
                          selectedDose = doseTypes[idx];
                        }
                        filterProducts();
                        setState(() {});
                      }),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              selectedDose != null && selectedDose!.index == idx
                                  ? AppColors.exploreCardGreenColor
                                  : AppColors.exploreCardGreenColor
                                      .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.exploreCardGreenColor
                                .withOpacity(0.7),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            doseTypes[idx].type,
                            style: TextStyle(
                              color: selectedDose != null &&
                                      selectedDose!.index == idx
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: doseTypes.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 16 / 4,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
              ),
            if (showSort)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Sort By',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8, // Horizontal space between chips
                        runSpacing: 8, // Vertical space between lines
                        children: [
                          _buildSortChip(
                            label: 'Name (A-Z)',
                            selected: sortOption == SortOption.nameAscending,
                            onTap: () {
                              setState(() {
                                sortOption = SortOption.nameAscending;
                                sortFilteredProducts(sortOption);
                              });
                            },
                          ),
                          _buildSortChip(
                            label: 'Name (Z-A)',
                            selected: sortOption == SortOption.nameDescending,
                            onTap: () {
                              setState(() {
                                sortOption = SortOption.nameDescending;
                                sortFilteredProducts(sortOption);
                              });
                            },
                          ),
                          _buildSortChip(
                            label: 'Price (Low to High)',
                            selected: sortOption == SortOption.priceLowToHigh,
                            onTap: () {
                              setState(() {
                                sortOption = SortOption.priceLowToHigh;
                                sortFilteredProducts(sortOption);
                              });
                            },
                          ),
                          _buildSortChip(
                            label: 'Price (High to Low)',
                            selected: sortOption == SortOption.priceHighToLow,
                            onTap: () {
                              setState(() {
                                sortOption = SortOption.priceHighToLow;
                                sortFilteredProducts(sortOption);
                              });
                            },
                          ),
                          _buildSortChip(
                            label: 'Newest First',
                            selected: sortOption == SortOption.newestFirst,
                            onTap: () {
                              setState(() {
                                sortOption = SortOption.newestFirst;
                                sortFilteredProducts(sortOption);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
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
                    onTap: (() {
                      setState(() {
                        showSort = !showSort;
                      });
                    }),
                    text: "Sort",
                    containerColor: showSort ? AppColors.green : null,
                  ),
                  const SizedBox(width: 15),
                  SearchingFilter(
                    onTap: (() {
                      setState(() {
                        showFiltered = !showFiltered;
                      });
                    }),
                    text: "Filter",
                    containerColor: !showFiltered ? AppColors.green : null,
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            if ((widget.searchController.text.isNotEmpty &&
                    filteredProducts.isNotEmpty) ||
                (showFiltered && filteredProducts.isNotEmpty))
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    final product = filteredProducts[idx];
                    CartItemWithProduct? cartItem =
                        AppFunctions.findCartContainingProduct(
                      cartList: cartItems,
                      productName: product.name,
                    );
                    final item = cartItem?.item;
                    return CustomProductContainer(
                      onTapAdd: () async {
                        setState(() {});
                        // log(loading.toString());
                        try {
                          await AppFunctions.addToCart(product, user, context);
                          await getCart();
                          cartItem = AppFunctions.findCartContainingProduct(
                            cartList: cartItems,
                            productName: product.name,
                          );
                          log((cartItem == null).toString());
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                        }
                        setState(() {});
                      },
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
                      image: filteredProducts[idx].productImage,
                      name: filteredProducts[idx].name,
                      mrp: filteredProducts[idx].amount.toString(),
                      child: cartItem != null
                          ? CustomAddQntBtn(
                              qnt: item?.quantity ?? 0,
                              onTapMinu: () async {
                                if (item!.quantity > 1) {
                                  setState(() => item.quantity--);
                                  await AppFunctions.updateCart(
                                      product,
                                      item.quantity,
                                      cartItem!.cart.cartId,
                                      user,
                                      context);
                                  await getCart();
                                } else {
                                  await AppFunctions.removeFromCart(
                                      cartItem!.cart.cartId,
                                      product.productId,
                                      user,
                                      context);
                                  await getCart();
                                }
                              },
                              onTapPlus: () async {
                                // Check if we haven't reached maximum available quantity
                                if (item!.quantity < product.quantity) {
                                  // Assuming product has maxQuantity field
                                  setState(() => item.quantity++);
                                  try {
                                    await AppFunctions.updateCart(
                                        product,
                                        item.quantity,
                                        cartItem!.cart.cartId,
                                        user,
                                        context);
                                    await getCart();
                                  } catch (e) {
                                    setState(() => item.quantity--);
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update quantity: ${e.toString()}')),
                                      );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      AppSnackBar().customizedAppSnackBar(
                                        message:
                                            'Maximum quantity reached (${product.quantity})',
                                        context: context,
                                      ),
                                    );
                                }
                              },
                            )
                          : null,
                    );
                  },
                  childCount: filteredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 11 / 16,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
              ),
            if ((widget.searchController.text.isNotEmpty || showFiltered) &&
                filteredProducts.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Text("No medicines found"),
                ),
              ),
          ],
        ),
      );
    }
  }

  // Helper widget for sort chips
  Widget _buildSortChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class SearchingFilter extends StatelessWidget {
  const SearchingFilter({
    super.key,
    required this.text,
    required this.onTap,
    this.containerColor,
  });

  final String text;
  final VoidCallback onTap;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: containerColor ?? AppColors.black.withOpacity(0.05),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: containerColor == null ? AppColors.black : AppColors.white,
          ),
        ),
      ),
    );
  }
}
