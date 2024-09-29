import 'package:flutter/material.dart';
import 'package:mdw_app/models/orders_type_model.dart';
import 'package:mdw_app/screens/payment_screen.dart';
import 'package:mdw_app/styles.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<OrdersTypeModel> ordersTypes = [
    OrdersTypeModel(type: "All Orders", index: 0),
    OrdersTypeModel(type: "Active", index: 1),
    OrdersTypeModel(type: "Cancelled", index: 2),
  ];
  int selectedType = 0;
  String title = "";
  bool typesOpened = false;

  @override
  void initState() {
    title = ordersTypes[0].type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        centerTitle: false,
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              setState(() {
                typesOpened = !typesOpened;
              });
            }),
            icon: Icon(
              typesOpened
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 35,
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: typesOpened ? 120 : 0,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 2,
                      color: AppColors.grey.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ordersTypes.map((e) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              selectedType = e.index;
                              title = e.type;
                            });
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.type,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 17,
                                ),
                              ),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    selectedType = e.index;
                                    title = e.type;
                                  });
                                }),
                                child: CustomCheckBox(
                                  isChecked: selectedType == e.index,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 15)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, idx) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: idx != 0 ? 5 : 0, bottom: 7, left: 7, right: 7),
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: AppColors.customBoxShadow,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [1, 2, 3].map((e) {
                                    return Container(
                                      height: 70,
                                      width: 70,
                                      margin:
                                          EdgeInsets.only(left: 3, right: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              AppColors.grey.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Text("+13\nmore"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 2,
                            margin: EdgeInsets.only(top: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: AppColors.profileSpacerColor,
                            ),
                          ),
                          SizedBox(
                            height: 55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OrdersContainerBtn(
                                  head: "RATE",
                                  onTap: (() {}),
                                ),
                                Container(
                                  width: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.profileSpacerColor,
                                  ),
                                ),
                                OrdersContainerBtn(
                                  head: "ORDER AGAIN",
                                  onTap: (() {}),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersContainerBtn extends StatelessWidget {
  const OrdersContainerBtn({
    super.key,
    required this.onTap,
    required this.head,
  });

  final VoidCallback onTap;
  final String head;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            head,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
