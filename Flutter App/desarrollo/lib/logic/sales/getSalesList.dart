import 'package:desarrollo/models/sale.dart';
import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<List<SaleData>> getDataSalesList() async {
  var response = await ApiService().getSalesListAPI('homeEndpoint'); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
  if (response is List) {
    return response.map((item) => SaleData.fromJson(item)).toList();
  } else {
    throw Exception('Expected a list but received a different type');
  }
}

