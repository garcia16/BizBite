class UpdateProduct {
  final String nameProduct;
  final int idProduct;
  final int idCompany;
  final int stockActual;
  int nuevoStock;
  int totalStock;

  UpdateProduct({
    required this.nameProduct,
    required this.idProduct,
    required this.idCompany,
    required this.stockActual,
    this.nuevoStock = 0,
    this.totalStock = 0
  });
}