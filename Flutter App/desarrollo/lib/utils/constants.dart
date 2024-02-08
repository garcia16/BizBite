// ignore_for_file: prefer_const_constructors
///////////// COLORS //////////
//LightTheme
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/company.dart';
import '../models/employee.dart';
import '../models/product.dart';
import '../models/report.dart';
import '../models/sale.dart';

var primaryLight = Color(0xFF2C3E50);
var blackTextLight = Colors.black;
var whiteTextLight  = Colors.white;
var blackIconLight  = Colors.black;
var buttonsLight = Color(0xFF2C3E50);
var whiteIconLight  = Colors.white;
var secondaryLight = Color(0xFF2C3E50);
var onTertiaryLight  = Colors.black;

//DarkTheme

var primaryDark = Color.fromARGB(255, 18, 18, 18);
var blackTextDark = Colors.black;
var whiteTextDark = Color.fromARGB(255, 224, 224, 224);
var iconDark = Color.fromARGB(255, 0, 123, 255);
var buttonsDark = Color.fromARGB(255, 0, 123, 255);
var whiteIconDark = Color.fromARGB(255, 224, 224, 224);
var secondaryDark = Color.fromARGB(255, 24, 24, 24);
var onTertiaryLigth = Color.fromARGB(255, 176, 176, 176);



//VARIABLES GLOBALES

var globalMaxIdProduct;
var globalIdCompany;
var globalMaxIdSales;
var globalMaxIdReport;
var globalMaxIdCategory;
var globalCompanyPlan;

bool globalAdminPermission = false;

final List<String> categoriesCompany = [
    "Tecnología", "Sanidad", "Restauración", "Educación", "Finanzas",
    "Retail", "Turismo", "Construcción", "Agricultura", "Transporte",
    "Energía", "Entretenimiento", "Deporte", "Moda", "Belleza y Cuidado Personal",
    "Inmobiliaria", "Servicios Legales", "Marketing y Publicidad", "Industria Alimentaria",
    "Arte y Cultura",
  ];


  List<Company> companyList = [];
  List<Employee> employeeList = [];
  List<ProductData> productList = [];
  List<SaleData> saleList = [];
  List<CategoryProduct> categoryProducts = [];
  List<DataReport> reportsList = [];