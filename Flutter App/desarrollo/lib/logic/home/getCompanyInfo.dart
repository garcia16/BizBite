import 'package:desarrollo/models/company.dart';
import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<List<Company>> getDataInfoCompany() async {
  var response = await ApiService().getCompanyDataAPI('homeEndpoint');

  if (response == null) {
    throw Exception('No data received from the API');
  }

  if (response is Map<String, dynamic>) {
    return [Company.fromJson(response)]; // Devuelve una lista con un solo Company
  }

  // Si la respuesta es una lista, convierte cada elemento en un objeto Company
  else if (response is List) {
    return response.map((item) {
      if (item is Map<String, dynamic>) {
        return Company.fromJson(item);
      } else {
        throw Exception('Invalid item type');
      }
    }).toList();
  } else {
    throw Exception('Expected a Map or a List but received: ${response.runtimeType}');
  }
}



