import 'package:flutter/material.dart';
import 'package:mdw_app/providers/main_screen_index_provider.dart';
import 'package:mdw_app/screens/cart_screen.dart';
import 'package:mdw_app/styles.dart';
import 'package:provider/provider.dart';

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
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              Provider.of<MainScreenIndexProvider>(context, listen: false)
                  .changeIndex(newIndex: 1);
              Navigator.pop(context);
            }),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const CartScreen(searchEnabled: false),
                ),
              );
            }),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
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
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          const Text(
                            "Liveasy",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: const Text(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: AppColors.customBoxShadow,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text("250 Tablets"),
                      ),
                      const Row(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "MRP ₹250",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      CustomAddQntBtn(
                        qnt: qnt,
                        onTapMinu: (() {
                          if (qnt >= 1) {
                            setState(() {
                              qnt--;
                            });
                          }
                        }),
                        onTapPlus: (() {
                          if (qnt <= 9) {
                            setState(() {
                              qnt++;
                            });
                          }
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: AppColors.customBoxShadow,
                    ),
                    child: const Text(
                      "Composition: This will display all dependencies, including transitive ones, allowing you to identify and resolve any version conflicts. By forcing Kotlin 1.9.0 and ensuring that the flutter_phone_direct_caller plugin (and any other plugin) uses the updated version, this should resolve the issue without needing to downgrade Kotlin.",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  recomExpanded = !recomExpanded;
                });
              }),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      // Shadow color
                      offset: const Offset(5, 5),
                      // Horizontal offset (right side)
                      blurRadius: 10, // Blur effect
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                      const SizedBox(
                        height: 10,
                      ),
                    if (recomExpanded)
                      const Text(
                        "Medicines are prescribed to treat, prevent, or manage various health conditions. They should be taken as directed by a healthcare professional, with careful adherence to the prescribed dosage, timing, and method of administration to ensure effectiveness and minimize risks.",
                      ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      // Shadow color
                      offset: const Offset(5, 5),
                      // Horizontal offset (right side)
                      blurRadius: 10, // Blur effect
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                      const SizedBox(
                        height: 10,
                      ),
                    if (sideEffExpanded)
                      const Text(
                        "While medicines can be beneficial, they may cause side effects ranging from mild issues like nausea, dizziness, or drowsiness to more serious reactions such as allergic responses, liver problems, or cardiovascular complications. It's important to consult a doctor if any side effects are experienced.",
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

class CustomAddQntBtn extends StatelessWidget {
  const CustomAddQntBtn({
    super.key,
    required this.qnt,
    required this.onTapMinu,
    required this.onTapPlus,
    this.width,
  });

  final int qnt;
  final VoidCallback onTapMinu, onTapPlus;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 105,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.addContainerColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onTapMinu,
            child: const Icon(
              Icons.remove,
              color: AppColors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            qnt == 0 ? "ADD" : qnt.toString(),
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: onTapPlus,
            child: const Icon(
              Icons.add,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
