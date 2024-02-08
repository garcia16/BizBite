class NewSale {
  final String nameProduct;
  final int idProduct;
  final int idCompany;
  final int amountProduct;
  final int quantityProduct;

  NewSale({
    required this.nameProduct,
    required this.idProduct,
    required this.idCompany,
    required this.amountProduct,
    required this.quantityProduct,
  });


Map<String, dynamic> toJson() {
    return {
      'nameProduct': nameProduct,
      'idProduct': idProduct,
      'idCompany': idCompany,
      'amountProduct': amountProduct,
      'quantityProduct': quantityProduct,
    };
  }

}

