import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../services/storage_services.dart';
import '../styles.dart';
import '../utils/snack_bar_utils.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({
    super.key,
    required this.head,
    required this.upperText,
    required this.type,
    required this.btnText,
  });

  final String head, upperText, btnText;
  final int type;

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  bool isPinVerified = false, loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: CustomAppBarTitle(
          title: widget.head,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            children: [
              CustomUpperPortion(
                head: widget.upperText,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              CustomPinputField(
                pin: 2003,
                onCompleted: (bool isVerified) {
                  setState(() {
                    isPinVerified = isVerified;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    if (!isPinVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                          message: "Please enter the valid pin.",
                          context: context,
                        ),
                      );
                    } else {
                      if (widget.type == 0) {
                        await StorageServices.setAttendanceStatus(true)
                            .whenComplete(() {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: ((ctx) => const MainScreen()),
                            ),
                          );
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: widget.btnText,
                ),
              if (loading) const CustomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({
    super.key,
    required this.title,
    this.textColor,
    this.fontSize,
  });

  final String title;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: textColor ?? AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 18,
      ),
    );
  }
}

class CustomPinputField extends StatelessWidget {
  const CustomPinputField({
    super.key,
    required this.pin,
    required this.onCompleted,
  });

  final int pin;
  final void Function(bool) onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green),
      ),
    );
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.red),
      ),
    );

    return Pinput(
      length: 4,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      validator: (enteredPin) {
        final isValid = enteredPin == pin.toString();
        onCompleted(isValid);
        return isValid ? null : 'Pin is incorrect';
      },
    );
  }
}

class CustomUpperPortion extends StatelessWidget {
  const CustomUpperPortion({
    super.key,
    required this.head,
  });

  final String head;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        head,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.black,
        ),
      ),
    );
  }
}
