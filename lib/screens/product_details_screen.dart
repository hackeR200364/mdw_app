import 'package:flutter/material.dart';
import 'package:mdw_app/styles.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int qnt = 0;
  bool recomExpanded = false, sideEffExpanded = false, bookMarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.shopping_cart_outlined),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 30,
              ),
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: AppColors.customBoxShadow,
              ),
              child: Center(
                child: Image.asset("assets/medicine_large.png"),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: AppColors.customBoxShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Liveasy",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              "SwiftMeds Pharmaceuticals Pvt. Ltd.",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: (() {
                          setState(() {
                            bookMarked = !bookMarked;
                          });
                        }),
                        icon: Icon(
                          bookMarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: AppColors.customBoxShadow,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text("250 Tablets"),
                      ),
                      Row(
                        children: [
                          Icon(Icons.description_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Guidelines"),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MRP ₹250",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.addContainerColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: (() {
                                if (qnt >= 1) {
                                  setState(() {
                                    qnt--;
                                  });
                                }
                              }),
                              icon: Icon(
                                Icons.remove,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              qnt == 0 ? "ADD" : qnt.toString(),
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              onPressed: (() {
                                if (qnt <= 9) {
                                  setState(() {
                                    qnt++;
                                  });
                                }
                              }),
                              icon: Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: AppColors.customBoxShadow,
                    ),
                    child: Text(
                      "Composition: This will display all dependencies, including transitive ones, allowing you to identify and resolve any version conflicts. By forcing Kotlin 1.9.0 and ensuring that the flutter_phone_direct_caller plugin (and any other plugin) uses the updated version, this should resolve the issue without needing to downgrade Kotlin.",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  recomExpanded = !recomExpanded;
                });
              }),
              child: AnimatedContainer(
                duration: Duration(
                  milliseconds: 200,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // Shadow color
                      offset: Offset(5, 5), // Horizontal offset (right side)
                      blurRadius: 10, // Blur effect
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recomended Use",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Icon(recomExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                    if (recomExpanded)
                      SizedBox(
                        height: 10,
                      ),
                    if (recomExpanded)
                      Text(
                          "The error you're encountering is due to a Kotlin version mismatch between the project and the Kotlin dependencies being used. To resolve this issue, you need to update the Kotlin Gradle plugin version in your project's configuration files."),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  sideEffExpanded = !sideEffExpanded;
                });
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // Shadow color
                      offset: Offset(5, 5), // Horizontal offset (right side)
                      blurRadius: 10, // Blur effect
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Side Effects",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Icon(sideEffExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                    if (sideEffExpanded)
                      SizedBox(
                        height: 10,
                      ),
                    if (sideEffExpanded)
                      Text(
                        "The error you're encountering is due to a Kotlin version mismatch between the project and the Kotlin dependencies being used. To resolve this issue, you need to update the Kotlin Gradle plugin version in your project's configuration files.",
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
