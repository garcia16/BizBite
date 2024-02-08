import 'package:desarrollo/models/report.dart';
import 'package:desarrollo/services/api_services.dart';

dynamic data;

Future<List<DataReport>> getReportList() async {
  var response = await ApiService().getReportsDataAPI('homeEndpoint');

    if (response is List) {
    return response.map((item) => DataReport.fromJson(item)).toList();
  } else {
    throw Exception('Expected a list but received a different type');
  }
}
