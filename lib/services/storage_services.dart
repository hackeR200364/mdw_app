import 'package:mdw_app/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_keys.dart';

class StorageServices {
  static Future<void> setSignInStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.signInStatusKey, status);
  }

  static Future<void> setAttendanceStatus(bool status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppKeys.attendanceStatusKey, status);
  }

  static Future<void> setAddress(AddressModel address) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(
        AppKeys.addressKey, AddressModel.addressModelToJson(address));
  }

  static Future<void> updatePhoneNumber(String phone, String country) async {
    AddressModel? address = await getAddress();
    if (address != null) {
      address = address.copyWith(phone: phone, country: country);
      await setAddress(address);
    }
  }

  static Future<AddressModel?> getAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final String? address = pref.getString(AppKeys.addressKey);
    if (address != null) {
      return AddressModel.jsonToAddressModel(address);
    }
    return null;
  }

  static Future<bool> getSignInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.signInStatusKey) ?? false;
  }

  static Future<bool> getAttendanceStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppKeys.attendanceStatusKey) ?? false;
  }
}
