import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../logic/data/global_data.dart';
import '../../../models/report.dart';
import '../../../utils/comun_widgets.dart';
import '../../../utils/constants.dart';
import 'addReportSale_screen.dart';


class SalesReportView extends StatefulWidget {

  @override
  _SalesReportViewState createState() => _SalesReportViewState();
}

class _SalesReportViewState extends State<SalesReportView> {
  List<DataReport> filteredReports = []; 

  // Filtros
  String selectedMonth = 'Todos';
  String selectedYear = 'Todos';
  final List<String> months = ['Todos', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
  final List<String> years = ['Todos', '2023', '2024', '2025', '2026', '2027', '2028'];

  @override
  void initState() {
    super.initState();
    _filterReports(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context, 'Informes de Ventas'),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (context, index) {
                return _buildReportCard(filteredReports[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AddSalesReportView())
          ).then((_) async {
            await GlobalData.loadData();
            setState(() {
              reportsList = reportsList;
              _filterReports(); 
            });
          });
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer,),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton(
          value: selectedMonth,
          items: months.map((String month) {
            return DropdownMenuItem(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedMonth = newValue!;
              _filterReports(); 
            });
          },
        ),
        DropdownButton(
          value: selectedYear,
          items: years.map((String year) {
            return DropdownMenuItem(
              value: year,
              child: Text(year),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedYear = newValue!;
              _filterReports(); 
            });
          },
        ),
      ],
    );
  }

  Widget _buildReportCard(DataReport report) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Theme.of(context).colorScheme.outline,
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text("Informe: ${DateFormat('dd/MM/yyyy').format(report.dateReport)}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.isAnnualReport) const Row(
              children: [
                Icon(Icons.arrow_right),
                Text('Todo el año'),
              ],
            ),
            if (report.includesDetail) const Row(
              children: [
                Icon(Icons.arrow_right),
                Text('Incluye desglose de ventas'),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          _openPdfFromUrl(context, report.urlReport);
        },
      ),
    );
  }


  void _filterReports() {
    setState(() {
      filteredReports = reportsList.where((report) {
        // Comprobamos si el año coincide
        bool yearMatches = (selectedYear == 'Todos' || report.dateReport.year.toString() == selectedYear);

        // Comprobamos si el mes coincide
        int monthIndex = months.indexOf(selectedMonth); // Esto dará 0 para 'Todos', 1 para 'Enero', etc.
        bool monthMatches = (selectedMonth == 'Todos' || (monthIndex == report.dateReport.month));

        // Comprobamos si el tipo de informe es 'Sales'
        bool typeMatches = report.typeReport == 'Sales';

        // El informe debe cumplir con los tres criterios para ser incluido
        return yearMatches && monthMatches && typeMatches;
      }).toList();
    });
  }

  Future<void> _openPdfFromUrl(BuildContext context, String url) async {
    try {
      // Usando Dio para descargar el archivo
      var dio = Dio();
      var response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // Mostrar el PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => response.data,
      );
    } catch (e) {
      print('Error al descargar o abrir el PDF: $e');
    }
  }



}
