import 'package:desarrollo/services/api_services.dart';
import '../../models/product.dart';

dynamic data;

Future<bool> putNewManualSale(Map<String, dynamic> saleData) async {
  // Convertir cada NewSale en un mapa
  saleData['products'] = saleData['products'].map((product) => product.toJson()).toList();
  var response = await ApiService().putNewManualSaleAPI('homeEndpoint',saleData); 
    return response;
}

