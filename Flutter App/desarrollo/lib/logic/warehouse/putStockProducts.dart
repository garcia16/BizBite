import 'package:desarrollo/models/updateProduct.dart';
import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> putStockProducts(List<UpdateProduct> productsData) async {
  var response = await ApiService().updateProductStockAPI('homeEndpoint',productsData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}