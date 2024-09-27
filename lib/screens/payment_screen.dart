import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdw_app/models/address_model.dart';
import 'package:mdw_app/models/total_cost_model.dart';
import 'package:mdw_app/screens/success_screen.dart';
import 'package:mdw_app/services/app_function_services.dart';
import 'package:mdw_app/services/storage_services.dart';
import 'package:mdw_app/styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';

import '../providers/main_screen_index_provider.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.totalCostModel});

  final TotalCostModel totalCostModel;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String address = "", phone = "";
  bool addressLoading = false, isChecked = false, phoneLoading = false;
  Position? position;
  List<Placemark>? placemarks;
  AddressModel? addressModel;

  final _simCardInfoPlugin = SimCardInfo();
  List<SimInfo>? _simCardInfo;

  @override
  void initState() {
    getData();
    super.initState();
  }

  String formatPhone(String country, String phoneNum) {
    // if (country == "India") {
    //   return "+91 $phone";
    // }

    switch (country) {
      case "India":
        return "+91 $phoneNum";
      default:
        return phoneNum;
    }
  }

  getData() async {
    setState(() {
      addressLoading = true;
      phoneLoading = true;
    });
    addressModel = await getStoredAddress();
    if (addressModel != null) {
      phone = formatPhone(addressModel!.country, addressModel!.phone);
    }
    if (addressModel == null) {
      position = await _determinePosition();
      if (position != null) {
        placemarks = await _determineAddress(position!);
      }
    }
    setState(() {
      addressLoading = false;
      phoneLoading = false;
    });

    // try {
    //   _simCardInfo = await getSimInfo();
    //   phoneLoading = false;
    // } catch (e) {
    //   phoneLoading = false;
    //   log(e.toString());
    // }
  }

  Future<AddressModel?> getStoredAddress() async =>
      await StorageServices.getAddress();

  Future<List<SimInfo>?> getSimInfo() async {
    final status = await Permission.phone.status;
    if (status.isDenied) {
      Permission.phone.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      try {
        final simInfo = await _simCardInfoPlugin.getSimInfo();
        log(simInfo?.first.number.toString() ?? "NULL");
        return simInfo;
      } catch (e) {
        log(e.toString());
      }
    }
    return null;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Placemark>> _determineAddress(Position pos) async =>
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (() {
              Provider.of<MainScreenIndexProvider>(context, listen: false)
                  .changeIndex(newIndex: 1);
              Navigator.pop(context, 1);
            }),
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Details",
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 15),
                if ((placemarks == null || addressModel == null) &&
                    addressLoading == true)
                  Text(
                    "Loading your address",
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                if (placemarks == null &&
                    addressModel == null &&
                    addressLoading == false)
                  UserDetailsRow(
                    data: "Please give the location permission",
                    onPressed: (() async {
                      final permission = await openAppSettings();
                      if (permission) {
                        position = await _determinePosition();
                        if (position != null) {
                          placemarks = await _determineAddress(position!);
                          setState(() {});
                        }
                      }
                    }),
                  ),
                if (placemarks != null && addressModel == null)
                  UserDetailsRow(
                    data:
                        "Please enter your name\n\n${placemarks!.first.name}, ${placemarks!.first.street}, ${placemarks!.first.subAdministrativeArea},\n${placemarks!.first.administrativeArea}, ${placemarks!.first.locality}-${placemarks!.first.postalCode}\n${placemarks!.first.country}",
                    onPressed: (() async {
                      bool check = true;
                      String country = "India";
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController phoneController =
                          TextEditingController(
                              text: phone.isNotEmpty
                                  ? phone.replaceAll(RegExp(r'^\+\d+\s'), '')
                                  : "");
                      TextEditingController addressController =
                          TextEditingController(
                              text:
                                  "${placemarks!.first.street}, ${placemarks!.first.subAdministrativeArea},\n${placemarks!.first.administrativeArea}, ${placemarks!.first.locality}-${placemarks!.first.postalCode}\n${placemarks!.first.country}");
                      TextEditingController aaddressController =
                          TextEditingController();
                      TextEditingController pinController =
                          TextEditingController(
                              text: placemarks!.first.postalCode);
                      TextEditingController cityController =
                          TextEditingController(
                              text: placemarks!.first.locality);
                      final AddressModel newAddress =
                          await showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: ((ctx) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 15,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverAppBar(
                                        centerTitle: true,
                                        backgroundColor: AppColors.transparent,
                                        toolbarHeight: 40,
                                        leading: IconButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          icon: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        title: Text(
                                          "Update Address",
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: (() {
                                              if (country.trim().isNotEmpty &&
                                                  nameController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  phoneController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  addressController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  pinController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  cityController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                Navigator.pop(
                                                  context,
                                                  AddressModel(
                                                    country: country,
                                                    name: nameController.text
                                                        .trim(),
                                                    phone: phoneController.text
                                                        .trim(),
                                                    address: addressController
                                                        .text
                                                        .trim(),
                                                    aaddress: aaddressController
                                                        .text
                                                        .trim(),
                                                    pin: pinController.text
                                                        .trim(),
                                                    city: cityController.text
                                                        .trim(),
                                                    isDefault: check,
                                                  ),
                                                );
                                              }
                                            }),
                                            icon: Icon(
                                              Icons.check,
                                              color: AppColors.green,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                      SliverToBoxAdapter(
                                        child: SizedBox(height: 20),
                                      ),
                                      SliverToBoxAdapter(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // boxShadow: AppColors.customBoxShadow,
                                          ),
                                          child: DropdownButtonFormField(
                                            value: country,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                child: Text("India"),
                                                value: "India",
                                              ),
                                            ],
                                            onChanged: ((val) {
                                              if (val != null) {
                                                setState(() {
                                                  country = val;
                                                });
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head:
                                              "Full Name (first name and surname)",
                                          hint: "John Doe",
                                          keyboard: TextInputType.name,
                                          textEditingController: nameController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Phone Number",
                                          hint: "e.g 0123456789",
                                          keyboard: TextInputType.phone,
                                          textEditingController:
                                              phoneController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomMultilineTextField(
                                          head: "Address",
                                          hint: "Enter your address",
                                          maxLines: 5,
                                          keyboard: TextInputType.multiline,
                                          textEditingController:
                                              addressController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomMultilineTextField(
                                          head: "Address (additional)",
                                          hint: "Enter your address",
                                          maxLines: 5,
                                          keyboard: TextInputType.multiline,
                                          textEditingController:
                                              aaddressController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Pin Code",
                                          hint: "Enter your Pin Code",
                                          keyboard: TextInputType.text,
                                          textEditingController: pinController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Town/City",
                                          hint: "Enter your town/city",
                                          keyboard: TextInputType.text,
                                          textEditingController: cityController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 10)),
                                      SliverToBoxAdapter(
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: check,
                                              onChanged: ((val) {
                                                if (val != null) {
                                                  setState(() {
                                                    check = val;
                                                  });
                                                }
                                              }),
                                              activeColor: AppColors.green,
                                            ),
                                            Text(
                                                "Make this my default address"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));

                      StorageServices.setAddress(newAddress);
                      await getData();
                    }),
                  ),
                if (addressModel != null)
                  UserDetailsRow(
                    data:
                        "${addressModel!.name}\n${addressModel!.address}\n${addressModel!.aaddress}\n${addressModel!.pin}\n${addressModel!.city}, ${addressModel!.country}",
                    onPressed: (() async {
                      bool check = addressModel!.isDefault;
                      String country = addressModel!.country;
                      TextEditingController nameController =
                          TextEditingController(text: addressModel!.name);
                      TextEditingController phoneController =
                          TextEditingController(text: addressModel!.phone);
                      TextEditingController addressController =
                          TextEditingController(text: addressModel!.address);
                      TextEditingController aaddressController =
                          TextEditingController(text: addressModel!.aaddress);
                      TextEditingController pinController =
                          TextEditingController(text: addressModel!.pin);
                      TextEditingController cityController =
                          TextEditingController(text: addressModel!.city);
                      final AddressModel? newAddress =
                          await showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: ((ctx) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 15,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverAppBar(
                                        centerTitle: true,
                                        backgroundColor: AppColors.transparent,
                                        toolbarHeight: 40,
                                        leading: IconButton(
                                          onPressed: (() {
                                            Navigator.pop(context);
                                          }),
                                          icon: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        title: Text(
                                          "Update Address",
                                          style: TextStyle(
                                            color: AppColors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: (() {
                                              if (country.trim().isNotEmpty &&
                                                  nameController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  phoneController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  addressController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  pinController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  cityController.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                Navigator.pop(
                                                  context,
                                                  AddressModel(
                                                    country: country,
                                                    name: nameController.text
                                                        .trim(),
                                                    phone: phoneController.text
                                                        .trim(),
                                                    address: addressController
                                                        .text
                                                        .trim(),
                                                    aaddress: aaddressController
                                                        .text
                                                        .trim(),
                                                    pin: pinController.text
                                                        .trim(),
                                                    city: cityController.text
                                                        .trim(),
                                                    isDefault: check,
                                                  ),
                                                );
                                              }
                                            }),
                                            icon: Icon(
                                              Icons.check,
                                              color: AppColors.green,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            // boxShadow: AppColors.customBoxShadow,
                                          ),
                                          child: DropdownButtonFormField(
                                            value: country,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                child: Text("India"),
                                                value: "India",
                                              ),
                                            ],
                                            onChanged: ((val) {
                                              if (val != null) {
                                                setState(() {
                                                  country = val;
                                                });
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head:
                                              "Full Name (first name and surname)",
                                          hint: "John Doe",
                                          keyboard: TextInputType.name,
                                          textEditingController: nameController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Phone Number",
                                          hint: "e.g 0123456789",
                                          keyboard: TextInputType.phone,
                                          textEditingController:
                                              phoneController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomMultilineTextField(
                                          head: "Address",
                                          hint: "Enter your address",
                                          maxLines: 5,
                                          keyboard: TextInputType.multiline,
                                          textEditingController:
                                              addressController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomMultilineTextField(
                                          head: "Address (additional)",
                                          hint: "Enter your address",
                                          maxLines: 5,
                                          keyboard: TextInputType.multiline,
                                          textEditingController:
                                              aaddressController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Pin Code",
                                          hint: "Enter your Pin Code",
                                          keyboard: TextInputType.text,
                                          textEditingController: pinController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 20)),
                                      SliverToBoxAdapter(
                                        child: CustomTextField(
                                          head: "Town/City",
                                          hint: "Enter your town/city",
                                          keyboard: TextInputType.text,
                                          textEditingController: cityController,
                                        ),
                                      ),
                                      SliverToBoxAdapter(
                                          child: SizedBox(height: 10)),
                                      SliverToBoxAdapter(
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: check,
                                              onChanged: ((val) {
                                                if (val != null) {
                                                  setState(() {
                                                    check = val;
                                                  });
                                                }
                                              }),
                                              activeColor: AppColors.green,
                                            ),
                                            Text(
                                                "Make this my default address"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));

                      if (newAddress != null) {
                        StorageServices.setAddress(newAddress);
                        await getData();
                      }
                    }),
                  ),
                if (phoneLoading == true && phone.isEmpty)
                  Text(
                    "Loading your phone number...",
                    style: TextStyle(
                      color: AppColors.black,
                    ),
                  ),
                if (phoneLoading == false && phone.isEmpty)
                  UserDetailsRow(
                    data: "Please give a phone number",
                    onPressed: (() async {
                      String country = "India";
                      TextEditingController phoneController =
                          TextEditingController();
                      final String newPhone = await showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: ((ctx) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 15,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: CustomScrollView(
                                slivers: [
                                  SliverAppBar(
                                    centerTitle: true,
                                    backgroundColor: AppColors.transparent,
                                    toolbarHeight: 40,
                                    leading: IconButton(
                                      onPressed: (() {
                                        Navigator.pop(context);
                                      }),
                                      icon: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    title: Text(
                                      "Update Phone Number",
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    actions: [
                                      IconButton(
                                        onPressed: (() {
                                          if (phoneController.text
                                              .trim()
                                              .isNotEmpty) {
                                            Navigator.pop(
                                              context,
                                              phoneController.text.trim(),
                                            );
                                          }
                                        }),
                                        icon: Icon(
                                          Icons.check,
                                          color: AppColors.green,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        // boxShadow: AppColors.customBoxShadow,
                                      ),
                                      child: DropdownButtonFormField(
                                        value: country,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("India"),
                                            value: "India",
                                          ),
                                        ],
                                        onChanged: ((val) {
                                          if (val != null) {
                                            setState(() {
                                              country = val;
                                            });
                                          }
                                        }),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                  SliverToBoxAdapter(
                                    child: CustomTextField(
                                      head: "Phone Number",
                                      hint: "e.g 0123456789",
                                      keyboard: TextInputType.phone,
                                      textEditingController: phoneController,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                ],
                              ),
                            );
                          }));

                      StorageServices.updatePhoneNumber(newPhone, country);

                      phone = formatPhone(country, newPhone);
                      setState(() {});
                    }),
                  ),
                if (phone.isNotEmpty)
                  UserDetailsRow(
                    data: phone,
                    onPressed: (() async {
                      String country = "India";
                      TextEditingController phoneController =
                          TextEditingController();
                      final String newPhone = await showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: ((ctx) {
                            return Container(
                              margin: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 15,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: CustomScrollView(
                                slivers: [
                                  SliverAppBar(
                                    centerTitle: true,
                                    backgroundColor: AppColors.transparent,
                                    toolbarHeight: 40,
                                    leading: IconButton(
                                      onPressed: (() {
                                        Navigator.pop(context);
                                      }),
                                      icon: Icon(
                                        Icons.close,
                                        size: 20,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    title: Text(
                                      "Update Phone Number",
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    actions: [
                                      IconButton(
                                        onPressed: (() {
                                          if (phoneController.text
                                              .trim()
                                              .isNotEmpty) {
                                            Navigator.pop(
                                              context,
                                              phoneController.text.trim(),
                                            );
                                          }
                                        }),
                                        icon: Icon(
                                          Icons.check,
                                          color: AppColors.green,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                  SliverToBoxAdapter(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        // boxShadow: AppColors.customBoxShadow,
                                      ),
                                      child: DropdownButtonFormField(
                                        value: country,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            child: Text("India"),
                                            value: "India",
                                          ),
                                        ],
                                        onChanged: ((val) {
                                          if (val != null) {
                                            setState(() {
                                              country = val;
                                            });
                                          }
                                        }),
                                      ),
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                  SliverToBoxAdapter(
                                    child: CustomTextField(
                                      head: "Phone Number",
                                      hint: "e.g 0123456789",
                                      keyboard: TextInputType.phone,
                                      textEditingController: phoneController,
                                    ),
                                  ),
                                  SliverToBoxAdapter(
                                      child: SizedBox(height: 20)),
                                ],
                              ),
                            );
                          }));

                      StorageServices.updatePhoneNumber(newPhone, country);
                      await getData();
                      setState(() {});
                    }),
                  ),
                SizedBox(height: 15),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckBoxContainer(
                  isChecked: isChecked,
                  onTap: (() {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  }),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Pay with Cash/Card/UPI",
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: AppColors.customBoxShadow,
              ),
              child: Column(
                children: [
                  IndividualCosts(
                    head: "Total Cost",
                    cost: widget.totalCostModel.tCost.toString(),
                  ),
                  IndividualCosts(
                    head: "Taxes",
                    cost: widget.totalCostModel.taxes.toString(),
                  ),
                  IndividualCosts(
                    head: "Handling Charges",
                    cost: widget.totalCostModel.hCharges.toString(),
                  ),
                  IndividualCosts(
                    head: "Rain Charges",
                    cost: widget.totalCostModel.rCharges.toString(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IndividualCosts(
                    head: "Total Payment",
                    cost: AppFunctions.totalPayment(widget.totalCostModel)
                        .toString(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (() async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SuccessScreen(
                      showAppBar: false,
                      image: "assets/order-success.png",
                      head: "Your order has been successfully placed",
                      des:
                          "Sit and relax while your orders is being worked on . It’ll take 5min before you get it",
                      btnOnPressed: (() {
                        Navigator.pop(context, 1);
                      }),
                      btnText: "Go back to home",
                    ),
                  ),
                ).then((res) {
                  if (res != null && res == 1) {
                    Navigator.pop(context, 1);
                  }
                });
              }),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 51,
                decoration: BoxDecoration(
                  color: AppColors.cartPayBtnColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Proceed to Pay",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckBoxContainer extends StatelessWidget {
  const CustomCheckBoxContainer({
    super.key,
    required this.isChecked,
    required this.onTap,
  });

  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: AppColors.customBoxShadow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CustomCheckBox(isChecked: isChecked),
            SizedBox(width: 15),
            Text(
              "Pay on arrival",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isChecked,
  });

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: isChecked ? EdgeInsets.all(1.5) : null,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? AppColors.green : AppColors.white,
        border: isChecked
            ? null
            : Border.all(
                width: 1.2,
                color: AppColors.black,
              ),
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }
}

class UserDetailsRow extends StatelessWidget {
  const UserDetailsRow({
    super.key,
    required this.data,
    required this.onPressed,
  });

  final String data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(width: 15),
          TextButton(
            onPressed: onPressed,
            child: Text(
              "Change",
              style: TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
