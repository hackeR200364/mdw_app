class CartProductModel {
  final String pid, pname, pmrp, img, category;
  int qnt;

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
