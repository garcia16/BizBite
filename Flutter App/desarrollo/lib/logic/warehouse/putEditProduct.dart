import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> putUpdateProductData(Map<String, dynamic> productsData) async {
  var response = await ApiService().updateProductDataAPI('homeEndpoint',productsData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}