import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mdw_app/models/cart_items_model.dart';
import 'package:mdw_app/models/orders_type_model.dart';
import 'package:mdw_app/models/user_login_model.dart';
import 'package:mdw_app/screens/cart_screen.dart';
import 'package:mdw_app/screens/login_screen.dart';
import 'package:mdw_app/screens/product_details_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';
import 'package:mdw_app/services/app_keys.dart';
import 'package:mdw_app/services/storage_services.dart';
import 'package:mdw_app/styles.dart';
import 'package:provider/provider.dart';

import '../models/all_products_model.dart';
import '../models/cart_product_model.dart';
import '../providers/main_screen_index_provider.dart';
import '../utils/snack_bar_utils.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int selectedIdx = 0;
  List<OrdersTypeModel> category = [], doseTypes = [];
  Position? position;
  List<Placemark> placemarks = [];

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  List<CartProductModel> newArrivalCartModel = [];
  List<CartProductModel> topSellingCartModel = [];
  List<CartProductModel> cartModel = [];
  AllProductsListModel? allProducts;
  late ScrollController catScrollController;
  final ScrollController _productScrollController = ScrollController();
  List<AllProductsModel> filteredProducts = [];
  UserLoginModel? user;
  CartListResponse? cartItems;

  Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Location permission not enabled'),
          content: const Text(
            'Please enable location permission for a better delivery experience',
          ),
          actions: [
            TextButton(
                child: const Text('Enable device location'),
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                  setState(() {});
                }),
          ],
        ),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    // log(permission.toString());

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Location permission denied'),
            content: const Text(
                'You have denied the location permission. Please enable it from the "Settings" section of your phone.'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Go to settings'),
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                  setState(() {});
                },
              ),
            ],
          ),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Location permission denied'),
          content: const Text(
              'Location permissions are permanently denied. Please enable it from your device settings.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Go to settings'),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openAppSettings();
                setState(() {});
              },
            ),
          ],
        ),
      );
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      log("position.accuracy".toString());
      var position = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 5),
      );
      log(position.accuracy.toString());

      return position;
    }
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

  getUserData() async {
    user = await StorageServices.getUser();
    log((user == null).toString());
    if (user != null) {
      log(user!.token.toString());
    }
  }

  getData() async {
    log("Calling determinePosition");

    position = await determinePosition(context);
    log((position != null).toString());
    if (position != null) {
      placemarks = await AppFunctions.determineAddress(position!);
    }

    await getUserData();
    // await getCart();
    await getProducts();

    setState(() {});
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
            ..hideCurrentSnackBar()
            ..showSnackBar(AppSnackBar().customizedAppSnackBar(
              message: "Something went wrong \n $e",
              context: context,
            ));
        }
      }
    });
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
  void initState() {
    newArrivalCartModel = [
      // CartProductModel("2", "Medicine Name of 2", "1000",
      //     "assets/medicine-small.png", 2, MedicineCategory.es),
    ];
    topSellingCartModel = [
      // CartProductModel("0", "Medicine Name of 2", "1000",
      //     "assets/medicine-small.png", 1, MedicineCategory.es),
    ];
    cartModel = [
      // CartProductModel("1", "Medicine Name of 2", "1000",
      //     "assets/medicine-small.png", 3, MedicineCategory.es),
    ];
    catScrollController = ScrollController();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: RefreshIndicator(
          onRefresh: (() async {
            await getData();
          }),
          child: (allProducts != null)
              ? CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      backgroundColor: AppColors.white,
                      expandedHeight:
                          110.0 + MediaQuery.of(context).padding.top,
                      collapsedHeight: kToolbarHeight +
                          MediaQuery.of(context).padding.top -
                          (MediaQuery.of(context).size.height /
                              MediaQuery.of(context).size.width) -
                          20,
                      scrolledUnderElevation: 0,
                      elevation: 0,
                      centerTitle: false,
                      leading: Container(),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      const CartScreen(searchEnabled: true),
                                ),
                              );
                            },
                            icon: badges.Badge(
                              badgeContent: Text(
                                cartItems?.carts.length.toString() ?? "0",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              position: badges.BadgePosition.topEnd(top: -20),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: 25,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final topPadding = MediaQuery.of(context).padding.top;
                          final collapsedHeight = kToolbarHeight + topPadding;
                          final expandedHeight = 110.0 + topPadding;

                          // Calculate animation value and clamp it between 0.0 and 1.0
                          final animationValue =
                              ((constraints.maxHeight - collapsedHeight) /
                                      (expandedHeight - collapsedHeight))
                                  .clamp(0.0, 1.0);

                          // log(animationValue.toString());

                          return Stack(
                            children: [
                              // User Info Section
                              AnimatedPositioned(
                                left: 15,
                                top: topPadding + 10,
                                right: 70,
                                duration: Duration(milliseconds: 200),
                                child: AnimatedOpacity(
                                  opacity: animationValue,
                                  duration: Duration(milliseconds: 200),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (user != null)
                                          Text(
                                            user!.user.userfName,
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.location,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                placemarks.isEmpty
                                                    ? "Loading..."
                                                    : "${placemarks.first.name}, ${placemarks.first.locality}",
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Search Bar Section
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 200),
                                left: 10,
                                right: 10 + (150 * (1 - animationValue)),
                                // 70 when collapsed (animationValue=0), 10 when expanded (animationValue=1)
                                bottom: 10 + (19 * animationValue),
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<MainScreenIndexProvider>(
                                            context,
                                            listen: false)
                                        .changeIndex(newIndex: 1);
                                  },
                                  child: Container(
                                    height: 55,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.searchBarColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.search,
                                          color: AppColors.black,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Search Medicines",
                                          style: TextStyle(
                                            color: AppColors.hintTextColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 2),
                          viewportFraction: 0.98,
                          enlargeCenterPage: true,
                          aspectRatio: 2.1,
                        ),
                        itemCount: 10,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, bottom: 15, right: 45),
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
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dettol Anticeptic",
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "UPTO 40% OFF",
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.homeAdLinkBtnColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        "ORDER NOW",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  "assets/dettol.png",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    // In your build method:
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          controller: catScrollController,
                          itemBuilder: ((ctx, idx) {
                            return GestureDetector(
                              onTap: () {
                                filteredProducts.clear();
                                setState(() {
                                  selectedIdx = idx;
                                });
                                filteredProducts =
                                    allProducts!.data.where((element) {
                                  return element.category.name ==
                                      category[idx].type;
                                }).toList();
                                setState(() {});
                                // Animate both category and product lists to start
                                // if (catScrollController.hasClients) {
                                //   catScrollController.animateTo(
                                //     catScrollController
                                //         .position.minScrollExtent,
                                //     duration: const Duration(milliseconds: 300),
                                //     curve: Curves.linear,
                                //   );
                                // }
                                log(filteredProducts.length.toString());

                                if (_productScrollController.hasClients) {
                                  _productScrollController.animateTo(
                                    _productScrollController
                                        .position.minScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.linear,
                                  );
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: selectedIdx == idx
                                      ? AppColors.selectedCatContainerColor
                                          .withOpacity(0.26)
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    category[idx].type,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedIdx == idx
                                          ? AppColors.selectedCatTextColor
                                          : AppColors.catTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 20);
                          },
                          itemCount: category.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 25),
                    ),
                    if (selectedIdx == 0)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.separated(
                            controller: _productScrollController,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 20),
                            itemCount: allProducts!.data.length,
                            itemBuilder: (ctx, idx) {
                              final product = allProducts!.data[idx];
                              CartItemWithProduct? cartItem =
                                  AppFunctions.findCartContainingProduct(
                                cartList: cartItems,
                                productName: product.name,
                              );
                              final item = cartItem?.item;
                              bool loading = false;

                              return CustomProductContainer(
                                onTapAdd: () async {
                                  setState(() {});
                                  // log(loading.toString());
                                  try {
                                    await AppFunctions.addToCart(
                                        product, user, context);
                                    await getCart();
                                    cartItem =
                                        AppFunctions.findCartContainingProduct(
                                      cartList: cartItems,
                                      productName: product.name,
                                    );
                                    log((cartItem == null).toString());
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Error: ${e.toString()}')),
                                      );
                                  }
                                  setState(() {});
                                },
                                onTapProduct: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          const ProductDetailsScreen(),
                                    ),
                                  );
                                },
                                btnHeight: 35,
                                image: product.productImage,
                                name: product.name,
                                mrp: product.amount.toString(),
                                child: (cartItem != null)
                                    ? CustomAddQntBtn(
                                        qnt: item!.quantity,
                                        onTapMinu: () async {
                                          if (item.quantity > 1) {
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
                                          if (item.quantity <
                                              product.quantity) {
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
                                              // Revert if API call fails
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
                                                AppSnackBar()
                                                    .customizedAppSnackBar(
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
                          ),
                        ),
                      ),
                    if (selectedIdx != 0)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Builder(builder: (ctx) {
                            return ListView.separated(
                              controller: _productScrollController,
                              // Use the same controller
                              itemBuilder: ((ctx, idx) {
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
                                      await AppFunctions.addToCart(
                                          product, user, context);
                                      await getCart();
                                      cartItem = AppFunctions
                                          .findCartContainingProduct(
                                        cartList: cartItems,
                                        productName: product.name,
                                      );
                                      log((cartItem == null).toString());
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error: ${e.toString()}')),
                                        );
                                    }
                                    setState(() {});
                                  },
                                  onTapProduct: (() async {
                                    final index = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            const ProductDetailsScreen(),
                                      ),
                                    );
                                    if (index == 1) {}
                                  }),
                                  btnHeight: 35,
                                  image: product.productImage,
                                  name: product.name,
                                  mrp: product.amount.toString(),
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
                                            if (item!.quantity <
                                                product.quantity) {
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
                                                  AppSnackBar()
                                                      .customizedAppSnackBar(
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
                              }),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(width: 20);
                              },
                              itemCount: filteredProducts.length,
                            );
                          }),
                        ),
                      ),

                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: doseTypes.map((dose) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${dose.type} Medicines",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: Builder(builder: (ctx) {
                                  List<AllProductsModel> doseFilteredProducts =
                                      allProducts!.data
                                          .where((product) =>
                                              product.dosageType.name ==
                                              dose.type)
                                          .toList();
                                  return ListView.separated(
                                    itemBuilder: ((ctx, idx) {
                                      final product = doseFilteredProducts[idx];
                                      CartItemWithProduct? cartItem =
                                          AppFunctions
                                              .findCartContainingProduct(
                                        cartList: cartItems,
                                        productName: product.name,
                                      );
                                      final item = cartItem?.item;
                                      return CustomProductContainer(
                                        onTapAdd: () async {
                                          setState(() {});
                                          // log(loading.toString());
                                          try {
                                            await AppFunctions.addToCart(
                                                product, user, context);
                                            await getCart();
                                            cartItem = AppFunctions
                                                .findCartContainingProduct(
                                              cartList: cartItems,
                                              productName: product.name,
                                            );
                                            log((cartItem == null).toString());
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error: ${e.toString()}')),
                                              );
                                          }
                                          setState(() {});
                                        },
                                        onTapProduct: (() async {
                                          final index = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const ProductDetailsScreen(),
                                            ),
                                          );

                                          if (index == 1) {}
                                        }),
                                        btnHeight: 35,
                                        image: product.productImage,
                                        name: product.name,
                                        mrp: product.amount.toString(),
                                        child: cartItem != null
                                            ? CustomAddQntBtn(
                                                qnt: item!.quantity,
                                                onTapMinu: () async {
                                                  if (item!.quantity > 1) {
                                                    setState(
                                                        () => item.quantity--);
                                                    await AppFunctions
                                                        .updateCart(
                                                            product,
                                                            item.quantity,
                                                            cartItem!
                                                                .cart.cartId,
                                                            user,
                                                            context);
                                                    await getCart();
                                                  } else {
                                                    await AppFunctions
                                                        .removeFromCart(
                                                            cartItem!
                                                                .cart.cartId,
                                                            product.productId,
                                                            user,
                                                            context);
                                                    await getCart();
                                                  }
                                                },
                                                onTapPlus: () async {
                                                  // Check if we haven't reached maximum available quantity
                                                  if (item!.quantity <
                                                      product.quantity) {
                                                    // Assuming product has maxQuantity field
                                                    setState(
                                                        () => item.quantity++);
                                                    try {
                                                      await AppFunctions
                                                          .updateCart(
                                                              product,
                                                              item.quantity,
                                                              cartItem!
                                                                  .cart.cartId,
                                                              user,
                                                              context);
                                                      await getCart();
                                                    } catch (e) {
                                                      setState(() =>
                                                          item.quantity--);
                                                      ScaffoldMessenger.of(
                                                          context)
                                                        ..hideCurrentSnackBar()
                                                        ..showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Failed to update quantity: ${e.toString()}')),
                                                        );
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                      ..hideCurrentSnackBar()
                                                      ..showSnackBar(
                                                        AppSnackBar()
                                                            .customizedAppSnackBar(
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
                                    }),
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(width: 20);
                                    },
                                    itemCount: doseFilteredProducts.length,
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    // const SliverToBoxAdapter(
                    //   child: Text(
                    //     "Top-Selling Medicines",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    // const SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 10,
                    //   ),
                    // ),
                    // SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 220,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: ListView.separated(
                    //       itemBuilder: ((ctx, idx) {
                    //         final res = AppFunctions.findProductInCart(
                    //             "$idx", topSellingCartModel);
                    //         // log(res["exists"].toString());
                    //         if (res["exists"]) {
                    //           CartProductModel product =
                    //               topSellingCartModel[res["index"]];
                    //           return CustomProductContainer(
                    //             onTapProduct: (() async {
                    //               final index = await Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (ctx) =>
                    //                       const ProductDetailsScreen(),
                    //                 ),
                    //               );
                    //
                    //               if (index == 1) {}
                    //             }),
                    //             btnHeight: 40,
                    //             image: product.img,
                    //             name: product.pname,
                    //             mrp: product.pmrp,
                    //             child: CustomAddQntBtn(
                    //               qnt: product.qnt,
                    //               onTapMinu: (() {
                    //                 if (product.qnt > 1) {
                    //                   setState(() {
                    //                     product.qnt--;
                    //                   });
                    //                 } else if (product.qnt == 1) {
                    //                   topSellingCartModel
                    //                       .removeAt(res["index"]);
                    //                   setState(() {});
                    //                 }
                    //               }),
                    //               onTapPlus: (() {
                    //                 if (product.qnt <= 4) {
                    //                   setState(() {
                    //                     product.qnt++;
                    //                   });
                    //                 }
                    //               }),
                    //             ),
                    //           );
                    //         } else {
                    //           return CustomProductContainer(
                    //             onTapAdd: (() {
                    //               // topSellingCartModel.add(CartProductModel(
                    //               //     "$idx",
                    //               //     "Medicine Name of $idx",
                    //               //     "2600",
                    //               //     "assets/medicine-small.png",
                    //               //     1,
                    //               //     MedicineCategory.ay));
                    //               setState(() {});
                    //             }),
                    //             onTapProduct: (() async {
                    //               final index = await Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (ctx) =>
                    //                       const ProductDetailsScreen(),
                    //                 ),
                    //               );
                    //
                    //               if (index == 1) {}
                    //             }),
                    //             btnHeight: 40,
                    //             image: "assets/default-product-img.png",
                    //             name: "Liveasy",
                    //             mrp: "250",
                    //           );
                    //         }
                    //       }),
                    //       scrollDirection: Axis.horizontal,
                    //       separatorBuilder:
                    //           (BuildContext context, int index) {
                    //         return const SizedBox(width: 20);
                    //       },
                    //       itemCount: 10,
                    //     ),
                    //   ),
                    // ),
                    // const SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 20,
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 15, right: 25, top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          color: AppColors.imageUploadContainerColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Can’t figure which medicine to order?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: (() {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: ((ctx) =>
                                          //         UploadPrescriptionScreen()),
                                          //   ),
                                          // );
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: AppColors.homeAdLinkBtnColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            "UPLOAD",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "SEND US YOUR PRESCRIPTION",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Image.asset("assets/image-upload.png"),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    // const SliverToBoxAdapter(
                    //   child: Text(
                    //     "New Arrivals",
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    // const SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 10,
                    //   ),
                    // ),
                    // SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 220,
                    //     width: MediaQuery.of(context).size.width,
                    //     child: ListView.separated(
                    //       itemBuilder: ((ctx, idx) {
                    //         final res = AppFunctions.findProductInCart(
                    //             "$idx", newArrivalCartModel);
                    //         // log(res["exists"].toString());
                    //         if (res["exists"]) {
                    //           CartProductModel product =
                    //               newArrivalCartModel[res["index"]];
                    //           return CustomProductContainer(
                    //             onTapProduct: (() async {
                    //               final index = await Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (ctx) =>
                    //                       const ProductDetailsScreen(),
                    //                 ),
                    //               );
                    //
                    //               if (index == 1) {}
                    //             }),
                    //             btnHeight: 40,
                    //             image: product.img,
                    //             name: product.pname,
                    //             mrp: product.pmrp,
                    //             child: CustomAddQntBtn(
                    //               qnt: product.qnt,
                    //               onTapMinu: (() {
                    //                 if (product.qnt > 1) {
                    //                   setState(() {
                    //                     product.qnt--;
                    //                   });
                    //                 } else if (product.qnt == 1) {
                    //                   newArrivalCartModel
                    //                       .removeAt(res["index"]);
                    //                   setState(() {});
                    //                 }
                    //               }),
                    //               onTapPlus: (() {
                    //                 if (product.qnt <= 4) {
                    //                   setState(() {
                    //                     product.qnt++;
                    //                   });
                    //                 }
                    //               }),
                    //             ),
                    //           );
                    //         } else {
                    //           return CustomProductContainer(
                    //             onTapAdd: (() {
                    //               // newArrivalCartModel.add(CartProductModel(
                    //               //     "$idx",
                    //               //     "Medicine Name of $idx",
                    //               //     "2600",
                    //               //     "assets/medicine-small.png",
                    //               //     1,
                    //               //     MedicineCategory.ay));
                    //               setState(() {});
                    //             }),
                    //             onTapProduct: (() async {
                    //               final index = await Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (ctx) =>
                    //                       const ProductDetailsScreen(),
                    //                 ),
                    //               );
                    //
                    //               if (index == 1) {}
                    //             }),
                    //             btnHeight: 40,
                    //             image: "assets/medicine-small.png",
                    //             name: "Liveasy",
                    //             mrp: "250",
                    //           );
                    //         }
                    //       }),
                    //       scrollDirection: Axis.horizontal,
                    //       separatorBuilder:
                    //           (BuildContext context, int index) {
                    //         return const SizedBox(width: 20);
                    //       },
                    //       itemCount: 10,
                    //     ),
                    //   ),
                    // ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 25,
                      ),
                    ),
                  ],
                )
              : const CustomLoadingIndicator(),
        ),
      ),
    );
  }
}

class CustomProductContainer extends StatelessWidget {
  const CustomProductContainer({
    super.key,
    required this.onTapProduct,
    required this.image,
    required this.name,
    required this.mrp,
    this.btnHeight,
    this.onTapAdd,
    this.child,
  });

  final VoidCallback? onTapProduct, onTapAdd;
  final String image, name, mrp;
  final double? btnHeight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapProduct,
      child: AnimatedContainer(
        width: 170,
        duration: const Duration(milliseconds: 300),
        // margin: EdgeInsets.only(bottom: 20),
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (image.isEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // Adjust radius as needed
                child: Image.asset(
                  "assets/default-product-img.png",
                  height: 80,
                  fit: BoxFit
                      .cover, // Ensures the image fills the rounded corners
                ),
              ),
            if (image.isNotEmpty && image.startsWith('assets'))
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // Same radius for consistency
                child: Image.asset(
                  image,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            if (image.isNotEmpty && image.startsWith('https'))
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Same radius
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CustomLoadingIndicator(),
                    ),
                    errorWidget: (context, url, error) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "MRP ₹$mrp",
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (child == null)
                  GestureDetector(
                    onTap: onTapAdd,
                    child: Container(
                      height: btnHeight ?? 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.individualAddBtnColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          "ADD",
                        ),
                      ),
                    ),
                  ),
                if (child != null) SizedBox(child: child),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
