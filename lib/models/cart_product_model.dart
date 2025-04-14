enum MedicineCategory { es, nes, ay }

class CartProductModel {
  final String pid, pname, pmrp, img;
  int qnt;
  final MedicineCategory category;

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

  String getCategoryAsString() {
    switch (category) {
      case MedicineCategory.es:
        return 'Essential';
      case MedicineCategory.nes:
        return 'Non-Essential';
      case MedicineCategory.ay:
        return 'Ayurvedic';
    }
  }
}
