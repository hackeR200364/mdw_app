import 'package:flutter/material.dart';
import 'package:mdw_app/screens/main_screen.dart';

import '../services/app_function_services.dart';
import '../services/storage_services.dart';
import '../styles.dart';
import '../utils/snack_bar_utils.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscure = false, loading = false;

  late TextEditingController _emailTextController,
      _passwordTextController,
      _phoneNumberController,
      _nameController,
      _confirmPasswordController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailTextController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((ctx) => MainScreen()),
                ),
              );
            }),
            child: Text(
              "Skip",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 30),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Welcome to My DawaiWala. Create an account and start ordering medicines!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  CustomTextField(
                    textEditingController: _nameController,
                    head: "Name",
                    hint: "Enter name",
                    keyboard: TextInputType.name,
                    validator: ((value) => AppFunctions.nameValidator(value)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _emailTextController,
                    head: "Email Address",
                    hint: "Enter email",
                    keyboard: TextInputType.emailAddress,
                    validator: ((value) => AppFunctions.emailValidator(value)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _phoneNumberController,
                    head: "Phone Number",
                    hint: "Enter number",
                    keyboard: TextInputType.phone,
                    prefix: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 15,
                      height: 15,
                      child: Image.asset("assets/indian-flag.png"),
                    ),
                    validator: ((value) =>
                        AppFunctions.phoneNumberValidator(value)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    obscure: !obscure,
                    textEditingController: _passwordTextController,
                    head: "Password",
                    hint: "Enter password",
                    keyboard: TextInputType.visiblePassword,
                    validator: ((value) =>
                        AppFunctions.passwordValidator(value)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    obscure: !obscure,
                    textEditingController: _confirmPasswordController,
                    head: "Confirm Password",
                    hint: "Enter password",
                    keyboard: TextInputType.visiblePassword,
                    validator: ((value) =>
                        AppFunctions.confirmPasswordValidator(
                            _passwordTextController.text.trim(),
                            _confirmPasswordController.text.trim())),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: obscure,
                        activeColor: AppColors.green,
                        side: BorderSide(color: AppColors.grey),
                        onChanged: ((val) {
                          setState(() {
                            obscure = val!;
                          });
                        }),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Show password",
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    // log((AppFunctions.confirmPasswordValidator(
                    //         _confirmPasswordController.text.trim(),
                    //         _passwordTextController.text.trim()))
                    //     .toString());
                    if (AppFunctions.nameValidator(
                                _nameController.text.trim()) !=
                            null &&
                        AppFunctions.emailValidator(
                                _emailTextController.text.trim()) !=
                            null &&
                        AppFunctions.phoneNumberValidator(
                                _phoneNumberController.text.trim()) !=
                            null &&
                        AppFunctions.passwordValidator(
                                _passwordTextController.text.trim()) !=
                            null &&
                        AppFunctions.confirmPasswordValidator(
                                _confirmPasswordController.text.trim(),
                                _passwordTextController.text.trim()) !=
                            null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                            message: "Please fill all the fields correctly",
                            context: context),
                      );
                    } else {
                      await StorageServices.setSignInStatus(true)
                          .whenComplete(() async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => MainScreen(),
                          ),
                        );
                      });
                    }
                    // if (!EmailValidator.validate(
                    //     _emailTextController.text.trim())) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: "Please enter a valid email.",
                    //         context: context),
                    //   );
                    // } else if (AppFunctions.passwordValidator(
                    //         _passwordTextController.text.trim()) !=
                    //     null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     AppSnackBar().customizedAppSnackBar(
                    //         message: AppFunctions.passwordValidator(
                    //                 _passwordTextController.text.trim()) ??
                    //             "",
                    //         context: context),
                    //   );
                    // } else {
                    //   await StorageServices.setSignInStatus(true)
                    //       .whenComplete(() async {
                    //     bool attendanceStatus =
                    //         await AppFunctions.getAttendanceStatus();
                    //     if (attendanceStatus) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => MainScreen()),
                    //         ),
                    //       );
                    //     } else {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: ((ctx) => const CodeVerificationScreen(
                    //                 head: "Attendance",
                    //                 upperText:
                    //                     "Ask your admin to enter his code to confirm your attendance.",
                    //                 type: 0,
                    //                 btnText: "Confirm Attendance",
                    //               )),
                    //         ),
                    //       );
                    //     }
                    //   });
                    // }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: "Create my account",
                ),
              if (loading) CustomLoadingIndicator(),
              if (!loading)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 45),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: (() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((ctx) => const LoginScreen()),
                        ),
                      );
                    }),
                    child: Text(
                      "Login to my account",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
