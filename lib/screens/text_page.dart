import 'package:flutter/material.dart';
import 'package:mdw_app/styles.dart';

class TextPage extends StatelessWidget {
  const TextPage({
    super.key,
    required this.title,
    required this.des,
  });

  final String title, des;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Text(des),
      ),
    );
  }
}
