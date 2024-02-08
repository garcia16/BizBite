import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> deleteUserFromCompany(Map<String, dynamic> userData) async {
  var response = await ApiService().updateRoleUserAPI('homeEndpoint',userData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}