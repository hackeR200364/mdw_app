import 'package:flutter/material.dart';
import 'package:mdw_app/models/total_cost_model.dart';
import 'package:mdw_app/screens/payment_screen.dart';
import 'package:mdw_app/styles.dart';

import '../models/cart_product_model.dart';
import '../services/app_function_services.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.searchEnabled,
  });

  final bool searchEnabled;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int qnt = 1;

  List<CartProductModel> cartItems = [];
  TotalCostModel? totalCostModel;

  @override
  void initState() {
    cartItems = [
      CartProductModel(
        'P001',
        'Product 1',
        '₹500',
        'https://images.pexels.com/photos/2565761/pexels-photo-2565761.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        2,
        MedicineCategory.es,
      ),
      CartProductModel(
        'P002',
        'Product 2',
        '₹1000',
        'https://images.pexels.com/photos/3786154/pexels-photo-3786154.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        1,
        MedicineCategory.nes,
      ),
      CartProductModel(
        'P003',
        'Product 3',
        '₹1500',
        'https://images.pexels.com/photos/208518/pexels-photo-208518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        3,
        MedicineCategory.ay,
      ),
    ];
    updateTotalCostModel(cartItems);
    super.initState();
  }

  void updateTotalCostModel(List<CartProductModel> items) {
    totalCostModel = TotalCostModel(
        5,
        AppFunctions.calculateTotalTax(cartItems).toInt(),
        AppFunctions.calculateTotalCost(cartItems).toInt(),
        20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
            size: 20,
          ),
        ),
        title: const Text(
          "CART",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 15,
          ),
        ),
        actions: [
          if (widget.searchEnabled)
            IconButton(
              onPressed: (() {
                Navigator.pop(context, 1);
              }),
              icon: const Icon(
                Icons.search_rounded,
                color: AppColors.black,
              ),
            ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      body: cartItems.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: AppColors.customBoxShadow,
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: cartItems.map((e) {
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 65,
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image.network(e.img),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.pname,
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "MRP ${e.pmrp}",
                                            style: const TextStyle(
                                              color: AppColors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 80,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.addContainerColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: (() {
                                        if (e.qnt >= 2) {
                                          setState(() {
                                            e.qnt--;
                                            updateTotalCostModel(cartItems);
                                          });
                                        } else {
                                          setState(() {
                                            cartItems.remove(e);
                                            updateTotalCostModel(cartItems);
                                          });
                                        }
                                      }),
                                      child: const Icon(
                                        Icons.remove,
                                        color: AppColors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      e.qnt == 0 ? "ADD" : e.qnt.toString(),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: (() {
                                        if (e.qnt <= 9) {
                                          setState(() {
                                            e.qnt++;
                                            updateTotalCostModel(cartItems);
                                          });
                                        }
                                      }),
                                      child: const Icon(
                                        Icons.add,
                                        color: AppColors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ); // Or any widget you want to return
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (totalCostModel != null || cartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: AppColors.customBoxShadow,
                      ),
                      child: Column(
                        children: [
                          IndividualCosts(
                            head: "Total Cost",
                            cost: totalCostModel!.tCost.toString(),
                          ),
                          IndividualCosts(
                            head: "Taxes",
                            cost: totalCostModel!.taxes.toString(),
                          ),
                          IndividualCosts(
                            head: "Handling Charges",
                            cost: totalCostModel!.hCharges.toString(),
                          ),
                          IndividualCosts(
                            head: "Rain Charges",
                            cost: totalCostModel!.rCharges.toString(),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            decoration: BoxDecoration(
                              color: AppColors.black
                                  .withAlpha((0.5 * 255).toInt()),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          IndividualCosts(
                            head: "Total Payment",
                            cost: AppFunctions.totalPayment(totalCostModel!)
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: (() async {
                      if (totalCostModel != null) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => PaymentScreen(
                              totalCostModel: totalCostModel!,
                            ),
                          ),
                        ).then((res) {
                          if (res != null && res == 1) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 51,
                      decoration: BoxDecoration(
                        color: AppColors.cartPayBtnColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Proceed to Checkout",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/empty-cart.png",
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Cart is Empty",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class IndividualCosts extends StatelessWidget {
  const IndividualCosts({
    super.key,
    required this.head,
    required this.cost,
  });

  final String head, cost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            head,
            style: const TextStyle(
              color: AppColors.black,
            ),
          ),
          Text(
            "₹ $cost",
            style: const TextStyle(
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
