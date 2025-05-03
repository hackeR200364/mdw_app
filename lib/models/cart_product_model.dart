import 'package:mdw_app/models/all_products_model.dart';

enum MedicineCategory { es, nes, ay }

class CartProductModel {
  final String pid, pname, pmrp, img;
  int qnt;
  final Category category;

  CartProductModel(
    this.pid,
    this.pname,
    this.pmrp,
    this.img,
    this.qnt,
    this.category,
  );

  double extractMRP() {
    return double.parse(pmrp.replaceAll(RegExp(r'[^\d.]'), ''));
  }

  void updateQuantity(int newQuantity) {
    qnt = newQuantity;
  }
}
