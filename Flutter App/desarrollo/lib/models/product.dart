class ProductData {
  final int idProduct;
  final int idCompany;
  final String nameProduct;
  final String? categoryProduct;
  final String? referenceProduct;
  final int stockProduct;
  final int priceProduct;
  final int salePriceProduct;
  final String? photoProduct;
  final String? distributorProduct;
  final String? notesProduct;

  ProductData({
    required this.idProduct,
    required this.idCompany,
    required this.nameProduct,
    this.categoryProduct,
    this.referenceProduct,
    required this.stockProduct,
    required this.priceProduct,
    required this.salePriceProduct,
    this.photoProduct,
    this.distributorProduct,
    this.notesProduct
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      idProduct: json['idProduct'] as int,
      idCompany: json['idCompany'] as int,
      nameProduct: json['nameProduct'] as String,
      categoryProduct: json['categoryProduct'] as String?,
      referenceProduct: json['referenceProduct'] as String?,
      stockProduct: json['stockProduct'] as int,
      priceProduct: json['priceProduct'] as int,
      salePriceProduct: json['salePriceProduct'] as int,
      photoProduct: json['photoProduct'] as String?,
      distributorProduct: json['distributorProduct'] as String?,
      notesProduct: json['notesProduct'] as String?,
    );
  }

  @override
  String toString() {
    return 'ProductData{idProduct: $idProduct, nameProduct: $nameProduct, categoryProduct: $categoryProduct, referenceProduct: $referenceProduct, stockProduct: $stockProduct, priceProduct: $priceProduct, salePriceProduct: $salePriceProduct, photoProduct: $photoProduct, distributorProduct: $distributorProduct, notesProduct: $notesProduct}';
  }
}
