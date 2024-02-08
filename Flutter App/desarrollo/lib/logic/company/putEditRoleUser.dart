import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> putUpdateRoleUser(Map<String, dynamic> roleUserData) async {
  var response = await ApiService().updateRoleUserAPI('homeEndpoint',roleUserData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}