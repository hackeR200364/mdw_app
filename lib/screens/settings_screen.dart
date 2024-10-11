import 'package:flutter/material.dart';
import 'package:mdw_app/screens/login_screen.dart';
import 'package:mdw_app/screens/onboarding_screen.dart';
import 'package:mdw_app/styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController,
      _emailController,
      _phoneController,
      _passController,
      _confirmPassController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passController = TextEditingController();
    _confirmPassController = TextEditingController();
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
          ),
        ),
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SafeArea(
          child: Column(
            children: [
              CustomTextField(
                head: "Name",
                hint: "Enter name",
                keyboard: TextInputType.name,
                textEditingController: _nameController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                head: "Email Address",
                hint: "Enter email",
                keyboard: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                head: "Phone Number",
                hint: "Enter number",
                keyboard: TextInputType.phone,
                textEditingController: _phoneController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                head: "Password",
                hint: "Enter password",
                keyboard: TextInputType.visiblePassword,
                textEditingController: _passController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                head: "Confirm Password",
                hint: "Confirm Password",
                keyboard: TextInputType.visiblePassword,
                textEditingController: _confirmPassController,
              ),
              const SizedBox(height: 30),
              CustomBtn(
                onTap: (() {}),
                text: "UPDATE",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
