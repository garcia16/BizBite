import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/updateProduct.dart';

class ApiService {

  Future<dynamic> getCompanyDataAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/empresas/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getUsersCompanyDataAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/empresas/users-company/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getReportsDataAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/empresas/reports/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future<dynamic> getProductsListAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/products/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getCategoryProductsListAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/products/category-products/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getSalesListAPI(String endpoint) async {
    var url = Uri.parse('http://localhost:8080/sales/1');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> postNewProductAPI(String endpoint, Map<String, dynamic> productData) async {
    var url = Uri.parse('http://localhost:8080/products');
    var response = await http.post(url, body: json.encode(productData), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> postNewCategoryProductAPI(String endpoint, Map<String, dynamic> categoryData) async {
    var url = Uri.parse('http://localhost:8080/products/addCategory');
    var response = await http.post(url, body: json.encode(categoryData), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> putNewManualSaleAPI(String endpoint, Map<String, dynamic> saleData) async {
    var url = Uri.parse('http://localhost:8080/sales/addManualSale');
    var response = await http.post(
      url,
      body: json.encode(saleData),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> putNewScanSaleAPI(String endpoint, Map<String, dynamic> saleData) async {
    var url = Uri.parse('http://localhost:8080/sales/addScanSale');
    var response = await http.post(
      url,
      body: json.encode(saleData),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProductStockAPI(String endpoint, List<UpdateProduct> products) async {
    var url = Uri.parse('http://localhost:8080/products/update-stock');
    var productListMap = products.map((product) => {
        'nameProduct': product.nameProduct,
        'idProduct': product.idProduct,
        'idCompany': product.idCompany,
        'stockActual': product.stockActual,
        'nuevoStock': product.nuevoStock,
        'stockProduct': product.totalStock
    }).toList();

    var response = await http.put(
        url, 
        body: json.encode(productListMap), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
}

Future<bool> updateCompanyDataAPI(String endpoint, Map<String, dynamic> dataCompany) async {
    var url = Uri.parse('http://localhost:8080/empresas/1');

    var response = await http.patch(
        url, 
        body: json.encode(dataCompany), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProductDataAPI(String endpoint, Map<String, dynamic> product) async {
    var url = Uri.parse('http://localhost:8080/products/update-product');

    var response = await http.put(
        url, 
        body: json.encode(product), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCategoryDataAPI(String endpoint, Map<String, dynamic> category) async {
    var url = Uri.parse('http://localhost:8080/products/update-category');

    var response = await http.put(
        url, 
        body: json.encode(category), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteCategoryDataAPI(String endpoint, Map<String, dynamic> category) async {
    var url = Uri.parse('http://localhost:8080/products/delete-category');

    var response = await http.delete(
        url, 
        body: json.encode(category), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> postNewReportAPI(String endpoint, Map<String, dynamic> reportData) async {
    var url = Uri.parse('http://localhost:8080/empresas/addNewReport');
    var response = await http.post(
      url,
      body: json.encode(reportData),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateRoleUserAPI(String endpoint, Map<String, dynamic> userRole) async {
    var url = Uri.parse('http://localhost:8080/empresas/update-role');

    var response = await http.put(
        url, 
        body: json.encode(userRole), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUserFromCompany(String endpoint, Map<String, dynamic> category) async {
    var url = Uri.parse('http://localhost:8080/empresas/delete-user-company');

    var response = await http.delete(
        url, 
        body: json.encode(category), 
        headers: {"Content-Type": "application/json"}
    );
    if (response.statusCode == 200) {
        return true;
    } else {
      return false;
    }
  }


}
