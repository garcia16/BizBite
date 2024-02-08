class SaleData {
  final int idCompany;
  final int idSale;
  final String idUser;
  final int amountSale;
  final DateTime dateSale;
  final String? photoSale;
  final List<ProductInSale> products;

  SaleData({
    required this.idCompany,
    required this.idSale,
    required this.idUser,
    required this.amountSale,
    required this.dateSale,
    this.photoSale,
    required this.products,
  });

  factory SaleData.fromJson(Map<String, dynamic> json) {
    var productList = (json['products'] as List)
        .map((productJson) => ProductInSale.fromJson(productJson))
        .toList();

    return SaleData(
      idCompany: json['idCompany'],
      idSale: json['idSale'],
      idUser: json['idUser'],
      amountSale: json['amountSale'],
      dateSale: DateTime.parse(json['dateSale']),
      photoSale: json['photoSale'],
      products: productList,
    );
  }

  @override
  String toString() {
    return 'SaleData{idCompany: $idCompany, idSale: $idSale, idUser: $idUser, amountSale: $amountSale, dateSale: $dateSale, products: $products}';
  }
}

class ProductInSale {
  final int idProduct;
  final int quantityProduct;
  final int priceProduct;
  final String nameProduct;

  ProductInSale({
    required this.idProduct,
    required this.quantityProduct,
    required this.priceProduct,
    required this.nameProduct,
  });

  factory ProductInSale.fromJson(Map<String, dynamic> json) {
    return ProductInSale(
      idProduct: json['idProduct'],
      quantityProduct: json['quantityProduct'],
      priceProduct: json['priceProduct'],
      nameProduct: json['nameProduct'],
    );
  }

  @override
  String toString() {
    return 'ProductInSale{idProduct: $idProduct, quantityProduct: $quantityProduct, priceProduct: $priceProduct, nameProduct: $nameProduct}';
  }
}
