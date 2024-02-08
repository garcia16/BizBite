import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants.dart';
import '../home/getCompanyInfo.dart';
import '../home/getUsersCompanyInfo.dart';
import '../reports/getReportList.dart';
import '../sales/getSalesList.dart';
import '../warehouse/getCategoryList.dart';
import '../warehouse/getProductsList.dart';

class GlobalData {

   static loadData() async {
    // Carga datos empresa
      companyList = await getDataInfoCompany();
      globalIdCompany = companyList[0].idCompany;
      globalCompanyPlan = companyList[0].statusCompany;
      if(companyList[0].uidAdminCompany == FirebaseAuth.instance.currentUser!.uid.toString()){
        globalAdminPermission = true;
      }
      // Carga informes de ventas y almacen
      reportsList = await getReportList();
      globalMaxIdReport = reportsList.last.idReport;
      // Carga datos usuarios de la empresa
      employeeList = await getUsersCompanyInfo();
      // Carga productos
      productList = await getDataProductsList();
      globalMaxIdProduct = productList.last.idProduct;
      // Carga categorias
      categoryProducts = await getCategoryList();
      globalMaxIdCategory = categoryProducts.last.categoryProduct;
      // Carga ventas
      saleList = await getDataSalesList();
      globalMaxIdSales = saleList.last.idSale;
  }
}
