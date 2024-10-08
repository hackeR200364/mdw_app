import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mdw_app/screens/orders_screen.dart';
import 'package:mdw_app/screens/settings_screen.dart';
import 'package:mdw_app/screens/success_screen.dart';
import 'package:mdw_app/screens/text_page.dart';
import 'package:mdw_app/services/app_constants.dart';
import 'package:mdw_app/styles.dart';
import 'package:share_plus/share_plus.dart';

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
                              "+91 9230976362",
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "21 Male",
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
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((ctx) => SuccessScreen(
                                      showAppBar: true,
                                      appBarTitle: "Refer and Earn",
                                      image: "assets/refer-earn-image.png",
                                      head: "Share with your Friends",
                                      headTextColor: AppColors.green,
                                      des:
                                          "Get FitAahar with your friends, tell them how much you love living a healthier life.",
                                      btnOnPressed: (() async {
                                        final res = await Share.share(
                                            "Referring to others www.google.co.in",
                                            subject: "MDW");

                                        if (res.status ==
                                            ShareResultStatus.success) {
                                          log("shared");
                                        }
                                      }),
                                      btnText: "Share with your Friends",
                                    )),
                              ),
                            );
                          }),
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
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((ctx) => OrdersScreen()),
                          ),
                        );
                      }),
                      icon: Icons.shopping_bag_outlined,
                      head: "Orders",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomProfileContainer(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((ctx) => SettingsScreen()),
                          ),
                        );
                      }),
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
                  "Health Records are organized collections of a person's medical and health-related information, including details like medical history, diagnoses, treatments, test results, medications, and immunizations. These records help healthcare providers monitor patient progress, ensure accurate diagnoses, and deliver personalized care. Health records can be in paper form or digital, such as Electronic Health Records (EHR), providing quick access for both patients and doctors to manage health effectively.",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Help",
              des: "Sure! What do you need help with?",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Patient Records",
              des:
                  "Patient Records are comprehensive documents that contain detailed information about a patient's medical history, diagnoses, treatments, and ongoing health conditions. These records typically include personal details, physician notes, lab results, medications, and treatment plans. Maintaining accurate patient records is essential for effective healthcare management, allowing doctors to track patient progress, make informed decisions, and provide continuity of care. In modern healthcare systems, digital formats like Electronic Health Records (EHR) are widely used for better accessibility, security, and organization of patient data.",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "Address Book",
              des:
                  "An Address Book is a digital or physical tool used to store and manage contact information for individuals or organizations. It typically includes details such as names, phone numbers, email addresses, and physical addresses. Address books help users keep track of important contacts, making it easy to access and organize personal or professional connections. Digital versions often offer advanced features like search, grouping, and integration with other apps for seamless communication and contact management.",
            ),
            SizedBox(height: 15),
            ProfileSmallContainer(
              head: "About",
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "About Us",
                      style: TextStyle(
                        color: AppColors.black,
                      ),
                    ),
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => TextPage(
                            title: "About",
                            des: AppConstants.myDawaiWalaDescription,
                          ),
                        ),
                      );
                    }),
                  ),
                  ListTile(
                    title: Text(
                      "Return Policy",
                      style: TextStyle(
                        color: AppColors.black,
                      ),
                    ),
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => TextPage(
                            title: "Return Policy",
                            des: AppConstants.returnPolicyDescription,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
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
    this.des,
    this.child,
  });

  final String head;
  final String? des;
  final Widget? child;

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
            padding: EdgeInsets.only(left: 15, right: 15, top: 70, bottom: 10),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: AppColors.customBoxShadow,
              borderRadius: BorderRadius.circular(15),
              color: AppColors.white,
            ),
            child: (widget.child == null && widget.des != null)
                ? Text(
                    widget.des!,
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  )
                : widget.child,
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
    required this.onTap,
  });

  final IconData icon;
  final String head;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              size: 40,
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
      ),
    );
  }
}
