// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../utils/constants.dart';
import '../company/company_screen.dart';
import '../home/home_screen.dart';
import '../sales/sales_screen.dart';
import '../warehouse/warehouse_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async{
    try{
      await GlobalData.loadData();
        globalIdCompany = companyList[0].idCompany;
        globalCompanyPlan = companyList[0].statusCompany;
        globalMaxIdReport = reportsList.last.idReport;
        globalMaxIdProduct = productList.last.idProduct;
        globalMaxIdCategory = categoryProducts.last.categoryProduct;
        globalMaxIdSales = saleList.last.idSale;
        setState(() {
          isLoading = false;
        });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Almacén'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Ventas'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Empresa'),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0: 
        return HomeView(); 
      case 1: 
        return WarehouseView(); 
      case 2: 
        return SalesView(); 
      case 3: 
        return CompanyProfileView(); 
      default: 
        return Container();
    }
  }

}
