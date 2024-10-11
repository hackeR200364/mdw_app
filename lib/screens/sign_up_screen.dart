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
                  builder: ((ctx) => const MainScreen()),
                ),
              );
            }),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 30),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Welcome to My DawaiWala. Create an account and start ordering medicines!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
              ),
              const SizedBox(
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
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _emailTextController,
                    head: "Email Address",
                    hint: "Enter email",
                    keyboard: TextInputType.emailAddress,
                    validator: ((value) => AppFunctions.emailValidator(value)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _phoneNumberController,
                    head: "Phone Number",
                    hint: "Enter number",
                    keyboard: TextInputType.phone,
                    prefix: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 15,
                      height: 15,
                      child: Image.asset("assets/indian-flag.png"),
                    ),
                    validator: ((value) =>
                        AppFunctions.phoneNumberValidator(value)),
                  ),
                  const SizedBox(
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: obscure,
                        activeColor: AppColors.green,
                        side: const BorderSide(color: AppColors.grey),
                        onChanged: ((val) {
                          setState(() {
                            obscure = val!;
                          });
                        }),
                      ),
                      const SizedBox(
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
              const SizedBox(
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
                            builder: (ctx) => const MainScreen(),
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
              if (loading) const CustomLoadingIndicator(),
              if (!loading)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 45),
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
                    child: const Text(
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
