import 'package:desarrollo/services/api_services.dart';
import '../../models/category.dart';

Future<List<CategoryProduct>> getCategoryList() async {
  var response = await ApiService().getCategoryProductsListAPI('homeEndpoint'); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
  if (response is List) {
    return response.map((item) => CategoryProduct.fromJson(item)).toList();
  } else {
    throw Exception('Expected a list but received a different type');
  }
}

