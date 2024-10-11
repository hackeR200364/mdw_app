import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdw_app/screens/camera_screen.dart';
import 'package:mdw_app/screens/onboarding_screen.dart';
import 'package:mdw_app/styles.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.white,
            pinned: true,
            leading: IconButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
              ),
            ),
            centerTitle: false,
            title: const Text(
              "Upload Prescription",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: (() {}),
                child: const Text(
                  "SEND",
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: CustomBtn(
                    horizontalMargin: 20,
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((ctx) => const CameraScreen()),
                        ),
                      );
                    }),
                    text: "Camera",
                  ),
                ),
                Expanded(
                  child: CustomBtn(
                    horizontalMargin: 20,
                    onTap: (() async {
                      final List<XFile> images =
                          await imagePicker.pickMultiImage();
                      if (images.isNotEmpty) {
                        selectedImages.addAll(images);
                      }
                    }),
                    text: "Gallery",
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, idx) {
                return Stack(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(
                            File(selectedImages[idx].path),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.lightGreen,
                              AppColors.green,
                              AppColors.green,
                              AppColors.lightGreen,
                            ],
                          ),
                        ),
                        child: IconButton(
                          onPressed: (() {
                            selectedImages.removeAt(idx);
                          }),
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              childCount: selectedImages.length,
            ),
          ),
        ],
      ),
    );
  }
}
