import 'package:desarrollo/services/api_services.dart';
dynamic data;

Future<bool> postNewReport(Map<String, dynamic> reportData) async {
  var response = await ApiService().postNewReportAPI('homeEndpoint',reportData); 
  return response;
}
