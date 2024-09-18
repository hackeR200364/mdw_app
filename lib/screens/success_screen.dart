import 'package:flutter/material.dart';
import 'package:mdw_app/screens/onboarding_screen.dart';
import 'package:mdw_app/styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/order-success.png"),
            SizedBox(height: 25),
            Text(
              "Your order has been successfully placed",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 25),
            Text(
              "Sit and relax while your orders is being worked on . It’ll take 5min before you get it",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 25),
            CustomBtn(
              onTap: (() {
                Navigator.pop(context, 1);
              }),
              text: "Go back to home",
            ),
          ],
        ),
      ),
    );
  }
}
