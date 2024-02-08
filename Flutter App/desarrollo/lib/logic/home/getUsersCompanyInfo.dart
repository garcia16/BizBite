import 'package:desarrollo/models/employee.dart';
import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<List<Employee>> getUsersCompanyInfo() async {
  var response = await ApiService().getUsersCompanyDataAPI('homeEndpoint');

    if (response is List) {
    return response.map((item) => Employee.fromJson(item)).toList();
  } else {
    throw Exception('Expected a list but received a different type');
  }
}
