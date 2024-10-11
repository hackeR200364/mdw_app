import 'package:flutter/material.dart';
import 'package:mdw_app/screens/onboarding_screen.dart';
import 'package:mdw_app/styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.head,
    required this.des,
    required this.btnText,
    this.appBarTitle,
    required this.showAppBar,
    required this.btnOnPressed,
    this.headTextColor,
  });

  final String image, head, des, btnText;
  final String? appBarTitle;
  final bool showAppBar;
  final VoidCallback btnOnPressed;
  final Color? headTextColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: AppColors.white,
              leading: IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  size: 30,
                ),
              ),
              title: Text(
                appBarTitle ?? "",
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 22,
                ),
              ),
              centerTitle: false,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(image),
            const SizedBox(height: 25),
            Text(
              head,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: headTextColor ?? AppColors.black,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              des,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 25),
            CustomBtn(
              onTap: btnOnPressed,
              text: btnText,
            ),
          ],
        ),
      ),
    );
  }
}
