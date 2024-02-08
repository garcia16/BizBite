import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> updateCompanyData(Map<String, dynamic> companyData) async {
  var response = await ApiService().updateCompanyDataAPI('homeEndpoint',companyData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}