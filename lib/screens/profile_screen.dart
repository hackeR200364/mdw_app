import 'package:flutter/material.dart';
import 'package:mdw_app/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.profileColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.grey.shade100,
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Prasenjit",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "{phone number}",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "{age} {gender}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (() {}),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_outlined,
                                color: AppColors.black,
                                size: 30,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Refer and Earn",
                                style: TextStyle(
                                  color: AppColors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "Saved ₹90.23",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.width / 2.35,
              child: Row(
                children: [
                  Expanded(
                    child: CustomProfileContainer(
                      icon: Icons.shopping_bag_outlined,
                      head: "Orders",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomProfileContainer(
                      icon: Icons.settings,
                      head: "Settings",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ProfileSmallContainer(
              head: "Health Records",
              des:
                  "About Us\nContact Us\nFAQs\nTerms & Conditions\nReturn Policy\nPrivacy Policy",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Help",
              des:
                  "About Us\nContact Us\nFAQs\nTerms & Conditions\nReturn Policy\nPrivacy Policy",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Patient Records",
              des:
                  "About Us\nContact Us\nFAQs\nTerms & Conditions\nReturn Policy\nPrivacy Policy",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Address Bool",
              des:
                  "About Us\nContact Us\nFAQs\nTerms & Conditions\nReturn Policy\nPrivacy Policy",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "About",
              des:
                  "About Us\nContact Us\nFAQs\nTerms & Conditions\nReturn Policy\nPrivacy Policy",
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSmallContainer extends StatefulWidget {
  const ProfileSmallContainer({
    super.key,
    required this.head,
    required this.des,
  });

  final String head, des;

  @override
  State<ProfileSmallContainer> createState() => _ProfileSmallContainerState();
}

class _ProfileSmallContainerState extends State<ProfileSmallContainer> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (expanded)
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 70, bottom: 5),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: AppColors.customBoxShadow,
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white,
            ),
            child: Text(
              widget.des,
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
        GestureDetector(
          onTap: (() {
            setState(() {
              expanded = !expanded;
            });
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
              boxShadow: AppColors.customBoxShadow,
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.head,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomProfileContainer extends StatelessWidget {
  const CustomProfileContainer({
    super.key,
    required this.icon,
    required this.head,
  });

  final IconData icon;
  final String head;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
        boxShadow: AppColors.customBoxShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.black,
            size: 55,
          ),
          SizedBox(height: 10),
          Text(
            head,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
