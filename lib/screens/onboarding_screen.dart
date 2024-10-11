import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../styles.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.initialPage;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: PageView(
                  controller: _pageController,
                  children: const [
                    OnboardingContainer(
                      image: "assets/onboarding/onboard-screen-1.png",
                      text: "Delivering Medicines in\n20 mins!",
                    ),
                    OnboardingContainer(
                      image: "assets/onboarding/onboard-screen-2.png",
                      text: "My DawaiWala - Your\ngo-to app for medicines.",
                    ),
                    OnboardingContainer(
                      image: "assets/onboarding/onboard-screen-3.png",
                      text:
                          "Did you know? My DawaiWala\nprovides medicines in 20 minutes",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              SmoothPageIndicator(
                effect: const ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: AppColors.green,
                  dotColor: AppColors.inactiveDotColor,
                ),
                controller: _pageController,
                count: 3,
              ),
              const SizedBox(
                height: 25,
              ),
              CustomBtn(
                onTap: (() {
                  if (_pageController.page == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: ((ctx) => const LoginScreen()),
                      ),
                    );
                  }
                  if (_pageController.page == 0 || _pageController.page == 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  }
                  currentPage = _pageController.page?.toInt() ?? 0;
                  setState(() {});
                }),
                text: 'NEXT',
                fontSize: 17,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: (() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: ((ctx) => const LoginScreen())),
                  );
                }),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 45),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "SKIP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({
    super.key,
    required this.image,
    required this.text,
  });

  final String image, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child: Image.asset(image),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.green,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.fontSize,
    this.horizontalMargin,
    this.verticalPadding,
    this.horizontalPadding,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback onTap;
  final String text;
  final double? fontSize,
      horizontalMargin,
      verticalPadding,
      horizontalPadding,
      width,
      height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 45),
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15,
            horizontal: horizontalPadding ?? 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              AppColors.lightGreen,
              AppColors.green,
              AppColors.lightGreen,
            ],
          ),
        ),
        child: child ??
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  fontSize: fontSize,
                ),
              ),
            ),
      ),
    );
  }
}
