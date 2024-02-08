import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> postNewProduct(Map<String, dynamic> productData) async {
  var response = await ApiService().postNewProductAPI('homeEndpoint',productData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}