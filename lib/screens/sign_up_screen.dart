import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw_app/screens/main_screen.dart';
import 'package:mdw_app/services/app_keys.dart';

import '../services/app_function_services.dart';
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
      _firstNameController,
      _lastNameController,
      _confirmPasswordController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
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
                    textEditingController: _firstNameController,
                    head: "First Name",
                    hint: "Enter first name",
                    keyboard: TextInputType.name,
                    validator: ((value) => AppFunctions.nameValidator(value)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _lastNameController,
                    head: "Last Name",
                    hint: "Enter last name",
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

                    if (AppFunctions.nameValidator(
                                _firstNameController.text.trim()) !=
                            null &&
                        AppFunctions.nameValidator(
                                _lastNameController.text.trim()) !=
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
                      //SIGN-UP
                      await http.post(
                          Uri.parse(AppKeys.baseUrlKey +
                              AppKeys.apiUrlKey +
                              AppKeys.userKey +
                              AppKeys.registerKey),
                          body: {
                            "userfName": _firstNameController.text.trim(),
                            "userlName": _lastNameController.text.trim(),
                            "userEmail": _emailTextController.text.trim(),
                            "userPhone": _phoneNumberController.text.trim(),
                            "userPassword": _passwordTextController.text.trim(),
                          }).then((res) async {
                        if (res.statusCode == 201) {
                          Map<String, dynamic> resJson = jsonDecode(res.body);
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const LoginScreen(),
                            ),
                          );
                        } else if (res.statusCode == 400) {
                          Map<String, dynamic> resJson = jsonDecode(res.body);
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"],
                              context: context,
                            ),
                          );
                        } else {
                          log(res.statusCode.toString());
                          log(res.body.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            AppSnackBar().customizedAppSnackBar(
                              message: "Something went wrong",
                              context: context,
                            ),
                          );
                        }
                      });
                    }

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
