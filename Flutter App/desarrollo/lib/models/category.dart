class CategoryProduct {
  final int idCompany;
  final int categoryProduct;
  final String nameCategory;



  CategoryProduct({
    required this.idCompany,
    required this.categoryProduct,
    required this.nameCategory,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      idCompany: json['idCompany'] as int,
      categoryProduct: json['categoryProduct'] as int,
      nameCategory: json['nameCategory'] as String,
    );
  }

  @override
  String toString() {
    return 'ProductData{idProduct: $idCompany, categoryProduct: $categoryProduct, nameCategory: $nameCategory}';
  }
}
