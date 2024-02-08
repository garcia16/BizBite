import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<bool> putUpdateCategoryData(Map<String, dynamic> categoryData) async {
  var response = await ApiService().updateCategoryDataAPI('homeEndpoint',categoryData); // Asumiendo que esto devuelve una cadena JSON
  // Verifica si la respuesta es una lista antes de proceder
    return response;
}