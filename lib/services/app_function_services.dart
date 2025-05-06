import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mdw_app/models/all_products_model.dart';
import 'package:mdw_app/services/storage_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cart_items_model.dart';
import '../models/cart_product_model.dart';
import '../models/feedback_model.dart';
import '../models/total_cost_model.dart';
import '../models/user_login_model.dart';
import '../utils/snack_bar_utils.dart';
import 'app_keys.dart';

class AppFunctions {
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacter =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    } else if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    } else if (!hasDigit) {
      return 'Password must contain at least one digit';
    } else if (!hasSpecialCharacter) {
      return 'Password must contain at least one special character';
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!EmailValidator.validate(value)) {
      return 'Please enter the email correctly';
    } else {
      return null;
    }
  }

  static String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    } else if (name.length < 3) {
      return 'Name must be at least 3 characters long';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
      return 'Name can only contain letters';
    } else {
      return null;
    }
  }

  static String? phoneNumberValidator(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (RegExp(r'[a-zA-Z]').hasMatch(phoneNumber)) {
      return 'Phone number cannot contain alphabets';
    } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber)) {
      return 'Enter a valid 10-digit Indian phone number';
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(String? value1, String? value2) {
    if (value1 == null || value1.isEmpty) {
      return "Please enter your password first";
    } else if (value2 == null || value2.isEmpty) {
      return "Please confirm your password";
    } else if (value1 != value2) {
      return "Password does not match";
    } else {
      return null;
    }
  }

  static String formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      final NumberFormat currencyFormatter =
          NumberFormat.currency(symbol: '\$');
      return currencyFormatter.format(amount);
    }
  }

  static // Function to convert FeedbackType enum to string
      String feedbackTypeToString(FeedbackType type) {
    switch (type) {
      case FeedbackType.excellent:
        return 'Excellent';
      case FeedbackType.good:
        return 'Good';
      case FeedbackType.fair:
        return 'Fair';
      case FeedbackType.bad:
        return 'Bad';
      case FeedbackType.worst:
        return 'Worst';
    }
  }

// Function to convert string to FeedbackType enum
  static FeedbackType stringToFeedbackType(String type) {
    switch (type) {
      case 'Excellent':
        return FeedbackType.excellent;
      case 'Good':
        return FeedbackType.good;
      case 'Fair':
        return FeedbackType.fair;
      case 'Bad':
        return FeedbackType.bad;
      case 'Worst':
        return FeedbackType.worst;
      default:
        throw ArgumentError('Invalid feedback type');
    }
  }

  // static Future<bool?> callNumber(String number) async {
  //   return await FlutterPhoneDirectCaller.callNumber(number);
  // }

  static bool shouldShowAttendanceScreen() {
    DateTime now = DateTime.now();
    DateTime nineAM = DateTime(now.year, now.month, now.day, 9);
    DateTime twoPM = DateTime(now.year, now.month, now.day, 14);
    DateTime threePM = DateTime(now.year, now.month, now.day, 15);
    DateTime eightPM = DateTime(now.year, now.month, now.day, 20);

    if (now.isAfter(nineAM) && now.isBefore(twoPM)) {
      return false;
    } else if (now.isAfter(threePM) && now.isBefore(eightPM)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getSignInStatus() async {
    return await StorageServices.getSignInStatus();
  }

  static Future<bool> getAttendanceStatus() async {
    bool attendanceStatus = await StorageServices.getSignInStatus();
    if (!attendanceStatus) {
      attendanceStatus = AppFunctions.shouldShowAttendanceScreen();
    }
    return attendanceStatus;
  }

  static Future<void> launchMap(BuildContext context, String place) async {
    var url = '';
    var urlAppleMaps = '';
    // List<Placemark> placemarks1 = await placemarkFromCoordinates(lat, lng);
    // log(placemarks1.toString());
    String origin = place;
    // "${placemarks1[0].name},+${placemarks1[0].street},+${placemarks1[0].subAdministrativeArea},+${placemarks1[0].locality},+${placemarks1[0].thoroughfare}+${placemarks1[0].postalCode},+${placemarks1[0].country}";
    origin = origin.replaceAll(" ", "+");
    Uri uri;
    if (Platform.isAndroid) {
      // url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
      url = "https://www.google.com/maps/search/?api=1&query=$origin";
      uri = Uri.parse(url);
    } else {
      // urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      urlAppleMaps = 'https://maps.apple.com/?q=$origin';
      url = "comgooglemaps://?saddr=&daddr=$origin&directionsmode=driving";
      uri = Uri.parse(urlAppleMaps);
      // if (await canLaunchUrl(uri)) {
      //   await launchUrl(uri);
      // } else {
      //   throw 'Could not launch $url';
      // }
    }

    //https://www.google.com/maps/dir/Kutul+Sahi+Rd,+Ramkrishna+Pally,+Barasat,+Kolkata,+West+Bengal+700127,+India/TECHNO+INTERNATIONAL+NEW+TOWN,+TECHNO+INDIA+COLLEGE+OF+TECHNOLOGY,+DG+Block(Newtown),+Action+Area+1D,+Newtown,+New+Town,+West+Bengal/@22.6411377,88.4219832,13z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x39f8a1ff00ac4627:0x8f29211ae5f443b2!2m2!1d88.4920747!2d22.7042965!1m5!1m1!1s0x3a0275325006855b:0x6f82539ddd62a603!2m2!1d88.4757711!2d22.5783614!3e0?entry=ttu

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
      await launchUrl(Uri.parse(urlAppleMaps));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<List<XFile>> captureImages() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickMultiImage(imageQuality: 60);
  }

  static String getMonthAbbreviation(int month) {
    const List<String> monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (month < 1 || month > 12) {
      throw ArgumentError('Invalid month: $month. Must be between 1 and 12.');
    }

    return monthNames[month - 1];
  }

  static String getTwoDigitYear(int year) {
    if (year < 1000 || year > 9999) {
      throw ArgumentError('Invalid year: $year. Must be a 4-digit number.');
    }

    // Convert the year to a string and take the last two characters
    String yearStr = year.toString();
    return yearStr.substring(yearStr.length - 2);
  }

  static String formatCurrencyByComma(double amount) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(amount);
  }

  static double calculateTotalCost(List<CartProductModel> cartItems) {
    double totalCost = 0;
    for (var item in cartItems) {
      totalCost += item.qnt * item.extractMRP();
    }
    return totalCost;
  }

  static const Map<Category, double> categoryTaxRates = {
    Category.AYURVEDIC: 5.0,
    Category.COSMETIC: 18.0,
    Category.DRUG: 12.0,
    Category.GENERIC: 5.0,
    Category.NONE: 0.0,
    Category.OTC: 12.0,
  };

  static double calculateTax(double price, Category categoryCode) {
    return price * (categoryTaxRates[categoryCode] ?? 0);
  }

  static double calculateTotalTax(List<CartProductModel> cartItems) {
    double totalTax = 0;

    for (var item in cartItems) {
      double price = item.qnt * item.extractMRP();
      double itemTax = calculateTax(price, item.category);
      totalTax += itemTax;
    }

    return totalTax;
  }

  static int totalPayment(TotalCostModel costs) =>
      costs.tCost + costs.taxes + costs.hCharges + costs.rCharges;

  static List<XFile> filterDuplicates({
    required List<XFile> selected,
    required List<XFile> newSelected,
  }) {
    // Create a set of paths from newSelected for quick lookup
    final Set<String> newSelectedPaths =
        newSelected.map((file) => file.path).toSet();

    // Remove files from selected if their paths exist in newSelectedPaths
    selected.removeWhere((file) => newSelectedPaths.contains(file.path));

    return selected;
  }

  static Future<List<Placemark>> determineAddress(Position pos) async =>
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

  static Map<String, dynamic> findProductInCart(
      String productId, List<CartProductModel> cartProducts) {
    int index = cartProducts.indexWhere((product) => product.pid == productId);
    return {'exists': index != -1, 'index': index};
  }

  static CartItemWithProduct? findCartContainingProduct({
    required CartListResponse? cartList,
    required String productName,
  }) {
    // Early return for invalid cases
    if (cartList == null || cartList.carts.isEmpty || productName.isEmpty) {
      return null;
    }

    try {
      // Search through all carts and items
      for (final cart in cartList.carts) {
        try {
          final matchingItem = cart.items.firstWhere(
            (item) => item.productName == productName,
          );
          return CartItemWithProduct(cart: cart, item: matchingItem);
        } catch (e) {
          // Continue searching other carts if not found in this one
          continue;
        }
      }
    } catch (e) {
      debugPrint('Error finding product in cart: $e');
    }

    return null;
  }

  static void dismissAllSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static Future<void> addToCart(AllProductsModel product, UserLoginModel? user,
      BuildContext context) async {
    if (user != null) {
      int taxRate = int.parse(product.taxRate);
      http.Response response = await http.post(
          Uri.parse(AppKeys.baseUrlKey +
              AppKeys.apiUrlKey +
              AppKeys.cartKey +
              AppKeys.addToCartKey),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
          body: jsonEncode({
            "items": [
              {
                "productName": product.name,
                "quantity": 1,
                "amount": product.amount,
                "taxRate": product.taxRate,
              }
            ]
          }));

      // log(response.statusCode.toString());
      // log(response.body.toString());
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar().customizedAppSnackBar(
            message: "Product added to cart",
            context: context,
          ));
      } else {
        Map<String, dynamic> resJson = jsonDecode(response.body);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar().customizedAppSnackBar(
            message: resJson["message"] ?? "Something went wrong",
            context: context,
          ));
      }
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(AppSnackBar().customizedAppSnackBar(
          message: "User not logged in",
          context: context,
        ));
    }
  }

  static Future<void> removeFromCart(String cartId, String productId,
      UserLoginModel? user, BuildContext context) async {
    if (user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message: "User not logged in",
            context: context,
          ),
        );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(
          "${AppKeys.baseUrlKey}${AppKeys.apiUrlKey}${AppKeys.cartKey}${AppKeys.deleteCartKey}/$cartId",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user!.token}',
        },
      );

      // log('Remove from cart status: ${response.statusCode}');
      // log('Response: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Cart deleted successfully",
              context: context,
            ),
          );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Failed to remove item",
              context: context,
            ),
          );
      }
    } catch (e) {
      // log('Error removing from cart: $e');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message: "Error removing item",
            context: context,
          ),
        );
    }
  }

  static Future<void> updateCart(AllProductsModel product, int quantity,
      String cartId, UserLoginModel? user, BuildContext context) async {
    if (user == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message: "User not logged in",
            context: context,
          ),
        );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(
          "${AppKeys.baseUrlKey}${AppKeys.apiUrlKey}${AppKeys.cartKey}${AppKeys.updateCartKey}/$cartId",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user!.token}',
        },
        body: jsonEncode({
          "items": [
            {
              "productId": product.productId,
              "productName": product.name,
              "quantity": quantity,
              "amount": product.amount,
              "taxRate": product.taxRate,
            }
          ]
        }),
      );

      // log('Update cart status: ${response.statusCode}');
      // log('Response: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Cart updated",
              context: context,
            ),
          );
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            AppSnackBar().customizedAppSnackBar(
              message: "Failed to update cart",
              context: context,
            ),
          );
      }
    } catch (e) {
      // log('Error updating cart: $e');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          AppSnackBar().customizedAppSnackBar(
            message: "Error updating cart",
            context: context,
          ),
        );
    }
  }
}

// Helper class to return both the cart and the specific item
class CartItemWithProduct {
  final CartItemsModel cart;
  final Item item;

  CartItemWithProduct({required this.cart, required this.item});
}
