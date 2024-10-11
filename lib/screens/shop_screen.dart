import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdw_app/models/orders_type_model.dart';
import 'package:mdw_app/screens/cart_screen.dart';
import 'package:mdw_app/screens/product_details_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';
import 'package:mdw_app/styles.dart';
import 'package:provider/provider.dart';

import '../models/cart_product_model.dart';
import '../providers/main_screen_index_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int selectedIdx = 0;
  bool _isExpanded = true;
  List<OrdersTypeModel> category = [];
  Position? position;
  List<Placemark> placemarks = [];
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  List<CartProductModel> newArrivalCartModel = [];
  List<CartProductModel> topSellingCartModel = [];
  List<CartProductModel> cartModel = [];

  getData() async {
    position = await AppFunctions.determinePosition();
    if (position != null) {
      placemarks = await AppFunctions.determineAddress(position!);
    }
    setState(() {});
  }

  @override
  void initState() {
    category = [
      OrdersTypeModel(type: "Fitness", index: 0),
      OrdersTypeModel(type: "Essentials", index: 1),
      OrdersTypeModel(type: "Home", index: 2),
      OrdersTypeModel(type: "Skin", index: 3),
    ];
    newArrivalCartModel = [
      CartProductModel("2", "Medicine Name of 2", "1000",
          "assets/medicine-small.png", 2, MedicineCategory.es),
    ];
    topSellingCartModel = [
      CartProductModel("0", "Medicine Name of 2", "1000",
          "assets/medicine-small.png", 1, MedicineCategory.es),
    ];
    cartModel = [
      CartProductModel("1", "Medicine Name of 2", "1000",
          "assets/medicine-small.png", 3, MedicineCategory.es),
    ];
    Future.delayed(Duration(seconds: 3), (() {
      getData();
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.axis == Axis.vertical) {
              setState(() {
                _isExpanded = scrollNotification.metrics.extentBefore == 0;
              });
            }
            return true;
          },
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppColors.white,
                expandedHeight: 120,
                collapsedHeight: 80,
                scrolledUnderElevation: 0,
                elevation: 0,
                centerTitle: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: IconButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((ctx) =>
                                const CartScreen(searchEnabled: true)),
                          ),
                        );
                      }),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 25,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isExpanded)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Prasenjit",
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
                              Text(
                                placemarks.isEmpty
                                    ? "Loading..."
                                    : "${placemarks.first.name}, ${placemarks.first.locality}",
                                style: const TextStyle(
                                    color: AppColors.black,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: (() {
                        Provider.of<MainScreenIndexProvider>(context,
                                listen: false)
                            .changeIndex(newIndex: 1);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _isExpanded
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width - 75,
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
                            SizedBox(
                              width: 10,
                            ),
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
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 25,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemBuilder: ((ctx, idx) {
                      return GestureDetector(
                        onTap: (() {
                          setState(() {
                            selectedIdx = idx;
                          });
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: SizedBox(
                  height: 25,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemBuilder: ((ctx, idx) {
                      final res =
                          AppFunctions.findProductInCart("$idx", cartModel);
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
                            cartModel.add(CartProductModel(
                                "$idx",
                                "Medicine Name of $idx",
                                "2600",
                                "assets/medicine-small.png",
                                1,
                                MedicineCategory.ay));
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
                    }),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: 10,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const SliverToBoxAdapter(
                child: Text(
                  "Top-Selling Medicines",
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
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemBuilder: ((ctx, idx) {
                      final res = AppFunctions.findProductInCart(
                          "$idx", topSellingCartModel);
                      // log(res["exists"].toString());
                      if (res["exists"]) {
                        CartProductModel product =
                            topSellingCartModel[res["index"]];
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
                                topSellingCartModel.removeAt(res["index"]);
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
                            topSellingCartModel.add(CartProductModel(
                                "$idx",
                                "Medicine Name of $idx",
                                "2600",
                                "assets/medicine-small.png",
                                1,
                                MedicineCategory.ay));
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
                    }),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: 10,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(15),
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
              const SliverToBoxAdapter(
                child: Text(
                  "New Arrivals",
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
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemBuilder: ((ctx, idx) {
                      final res = AppFunctions.findProductInCart(
                          "$idx", newArrivalCartModel);
                      // log(res["exists"].toString());
                      if (res["exists"]) {
                        CartProductModel product =
                            newArrivalCartModel[res["index"]];
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
                                newArrivalCartModel.removeAt(res["index"]);
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
                            newArrivalCartModel.add(CartProductModel(
                                "$idx",
                                "Medicine Name of $idx",
                                "2600",
                                "assets/medicine-small.png",
                                1,
                                MedicineCategory.ay));
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
                    }),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: 10,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 25,
                ),
              ),
            ],
          ),
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
        width: 150,
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
            Image.asset(
              image,
              height: 80,
            ),
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
