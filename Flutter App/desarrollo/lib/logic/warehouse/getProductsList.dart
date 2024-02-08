import 'package:desarrollo/services/api_services.dart';
import '../../models/product.dart';

dynamic data;

Future<List<ProductData>> getDataProductsList() async {
  var response = await ApiService().getProductsListAPI('homeEndpoint'); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
  if (response is List) {
    return response.map((item) => ProductData.fromJson(item)).toList();
  } else {
    throw Exception('Expected a list but received a different type');
  }
}

