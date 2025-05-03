import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mdw_app/screens/sign_up_screen.dart';
import 'package:mdw_app/services/app_keys.dart';

import '../models/user_login_model.dart';
import '../services/app_function_services.dart';
import '../services/storage_services.dart';
import '../styles.dart';
import '../utils/snack_bar_utils.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailTextController, _passwordTextController;
  bool obscure = true, loading = false;

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
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
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "Login to your account",
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
                  "Good to see you again, enter your details\nbelow to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Column(
                children: [
                  CustomTextField(
                    textEditingController: _emailTextController,
                    head: "Email or Phone",
                    hint: "Enter email or phone",
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    textEditingController: _passwordTextController,
                    head: "Password",
                    hint: "Enter password",
                    keyboard: TextInputType.visiblePassword,
                    obscure: obscure,
                    maxLines: null,
                    suffix: GestureDetector(
                      onTap: (() {
                        setState(() {
                          obscure = !obscure;
                        });
                      }),
                      child: Icon(
                        obscure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.black.withOpacity(0.4),
                      ),
                    ),
                    validator: ((value) =>
                        AppFunctions.passwordValidator(value)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              if (!loading)
                CustomBtn(
                  onTap: (() async {
                    setState(() {
                      loading = true;
                    });
                    if ((AppFunctions.emailValidator(
                                    _emailTextController.text.trim()) !=
                                null ||
                            AppFunctions.phoneNumberValidator(
                                    _emailTextController.text.trim()) !=
                                null) &&
                        AppFunctions.passwordValidator(
                                _passwordTextController.text.trim()) !=
                            null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar().customizedAppSnackBar(
                            message: AppFunctions.passwordValidator(
                                    _passwordTextController.text.trim()) ??
                                "",
                            context: context),
                      );
                    } else {
                      await http.post(
                          Uri.parse(AppKeys.baseUrlKey +
                              AppKeys.apiUrlKey +
                              AppKeys.userKey +
                              AppKeys.loginKey),
                          body: {
                            "userEmailOrPhone":
                                _emailTextController.text.trim(),
                            "userPassword": _passwordTextController.text.trim(),
                          }).then((res) async {
                        log(res.body);
                        log(res.statusCode.toString());

                        Map<String, dynamic> resJson = jsonDecode(res.body);
                        if (res.statusCode == 200) {
                          try {
                            await StorageServices.setSignInStatus(true)
                                .whenComplete(() async {
                              await StorageServices.setUser(
                                      UserLoginModel.fromJson(resJson))
                                  .whenComplete(() async {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MainScreen()),
                                );
                              });
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                AppSnackBar().customizedAppSnackBar(
                              message: resJson["message"] +
                                  "\n" +
                                  "Something went wrong",
                              context: context,
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(AppSnackBar().customizedAppSnackBar(
                            message: resJson["message"],
                            context: context,
                          ));
                        }
                      });
                    }
                    setState(() {
                      loading = false;
                    });
                  }),
                  text: "Login to my account",
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
                          builder: ((ctx) => const SignUpScreen()),
                        ),
                      );
                    }),
                    child: const Text(
                      "Create an account",
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

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.green,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.head,
    required this.hint,
    required this.keyboard,
    this.validator,
    required this.textEditingController,
    this.obscure,
    this.suffix,
    this.prefix,
    this.maxLines,
  });

  final String head, hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool? obscure;
  final Widget? suffix, prefix;
  final int? maxLines;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            widget.head,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: widget.obscure ?? false,
          key: formFieldKey,
          onChanged: ((value) {
            formFieldKey.currentState!.validate();
          }),
          controller: widget.textEditingController,
          style: const TextStyle(color: AppColors.black, fontSize: 15),
          validator: widget.validator,
          keyboardType: widget.keyboard,
          cursorColor: AppColors.green,
          // maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.green.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomMultilineTextField extends StatefulWidget {
  const CustomMultilineTextField({
    super.key,
    required this.head,
    required this.hint,
    required this.keyboard,
    this.validator,
    required this.textEditingController,
    this.suffix,
    this.prefix,
    this.maxLines,
  });

  final String head, hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final Widget? suffix, prefix;
  final int? maxLines;

  @override
  State<CustomMultilineTextField> createState() =>
      _CustomMultilineTextFieldState();
}

class _CustomMultilineTextFieldState extends State<CustomMultilineTextField> {
  final GlobalKey<FormFieldState> formFieldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            widget.head,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          key: formFieldKey,
          onChanged: ((value) {
            formFieldKey.currentState!.validate();
          }),
          controller: widget.textEditingController,
          style: const TextStyle(color: AppColors.black, fontSize: 15),
          validator: widget.validator,
          keyboardType: widget.keyboard,
          cursorColor: AppColors.green,
          maxLines: widget.maxLines ?? 1,
          // Default is 1 if not specified
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            suffixIcon: widget.suffix,
            prefixIcon: widget.prefix,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.1),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.green.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.red,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
