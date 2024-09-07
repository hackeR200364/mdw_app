import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:mdw_app/styles.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: (() {}),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: AppColors.searchBarColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
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
          SizedBox(
            height: 25,
          ),
          CarouselSlider(
            items: [
              Container(
                padding:
                    EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 45),
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
                        Column(
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.homeAdLinkBtnColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
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
              )
            ],
            options: CarouselOptions(
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 2),
              viewportFraction: 0.98,
              enlargeCenterPage: true,
              aspectRatio: 2.1,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
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
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIdx == idx
                          ? AppColors.selectedCatContainerColor
                              .withOpacity(0.26)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Fitness",
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
                return SizedBox(width: 20);
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemBuilder: ((ctx, idx) {
                return CustomProductContainer(
                  onTap: () {},
                  image: "assets/medicine-small.png",
                  name: "Liveasy",
                  mrp: "250",
                );
              }),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 20);
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Top-Selling Medicines",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemBuilder: ((ctx, idx) {
                return CustomProductContainer(
                  onTap: () {},
                  image: "assets/medicine-small.png",
                  name: "Liveasy",
                  mrp: "250",
                );
              }),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 20);
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 170,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 15, right: 25, top: 15, bottom: 15),
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
                      Expanded(
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
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.homeAdLinkBtnColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "UPLOAD",
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
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
                SizedBox(
                  width: 15,
                ),
                Image.asset("assets/image-upload.png"),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "New Arrivals",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemBuilder: ((ctx, idx) {
                return CustomProductContainer(
                  onTap: () {},
                  image: "assets/medicine-small.png",
                  name: "Liveasy",
                  mrp: "250",
                );
              }),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 20);
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class CustomProductContainer extends StatelessWidget {
  const CustomProductContainer({
    super.key,
    required this.onTap,
    required this.image,
    required this.name,
    required this.mrp,
    this.btnHeight,
  });

  final VoidCallback onTap;
  final String image, name, mrp;
  final double? btnHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 150,
        duration: Duration(milliseconds: 300),
        // margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
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
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "MRP ₹$mrp",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: btnHeight ?? 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.individualAddBtnColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "ADD",
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
