import 'dart:convert';

class AddressModel {
  final String country;
  final String name;
  final String phone;
  final String address;
  final String aaddress;
  final String pin;
  final String city;
  bool isDefault;

  AddressModel({
    required this.country,
    required this.name,
    required this.phone,
    required this.address,
    required this.aaddress,
    required this.pin,
    required this.city,
    required this.isDefault,
  });

  static String addressModelToJson(AddressModel address) {
    final Map<String, dynamic> data = {
      'country': address.country,
      'name': address.name,
      'phone': address.phone,
      'address': address.address,
      'aadress': address.aaddress,
      'pin': address.pin,
      'city': address.city,
      'isDefault': address.isDefault,
    };
    return jsonEncode(data); // Convert to JSON string
  }

  static AddressModel jsonToAddressModel(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return AddressModel(
      country: data['country'],
      name: data['name'],
      phone: data['phone'],
      address: data['address'],
      aaddress: data['aadress'],
      pin: data['pin'],
      city: data['city'],
      isDefault: data['isDefault'],
    );
  }

  AddressModel copyWith({
    String? country,
    String? name,
    String? phone,
    String? address,
    String? aaddress,
    String? pin,
    String? city,
    bool? isDefault,
  }) {
    return AddressModel(
      country: country ?? this.country,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      aaddress: aaddress ?? this.aaddress,
      pin: pin ?? this.pin,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
