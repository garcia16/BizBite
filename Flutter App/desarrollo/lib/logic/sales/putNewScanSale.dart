import 'package:desarrollo/services/api_services.dart';
import '../../models/product.dart';

dynamic data;

Future<bool> putNewScanSale(Map<String, dynamic> saleData) async {
  // Convertir cada NewSale en un mapa
  saleData['products'] = saleData['products'].map((product) => product.toJson()).toList();
  var response = await ApiService().putNewScanSaleAPI('homeEndpoint',saleData); 
    return response;
}

