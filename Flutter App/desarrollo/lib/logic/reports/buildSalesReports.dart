import 'dart:ffi';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/company.dart';
import '../../models/sale.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../../utils/constants.dart';
import 'postNewReport.dart';



Future<void> generatePdfSales(bool includeAllYear, bool includeSalesBreakdown, bool uploadToCloud, String dropdownValue, String dropdownValueYear) async {

    final pdf = pw.Document();
    final image = (await http.get(Uri.parse(companyList.first.photoCompany!))).bodyBytes;

    //Creación portada Informe
    generateFrontPage(pdf, image, companyList);

    //Hoja con Tabla de ventas
    generateHistorySales(pdf, saleList, image);

    //Hoja con Detalle de las ventas
    generateDetailSales(pdf, saleList, image);

    // Guardar el PDF
    final String pdfPath = await savePDF(pdf, companyList, includeAllYear, includeSalesBreakdown);

    // Opcional: abrir el PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());

    if (uploadToCloud) {
      final File pdfFile = File(pdfPath);
      await uploadPdfToFirebaseStorage(pdfFile, includeAllYear, includeSalesBreakdown);
    }
  }

  void generateDetailSales(pw.Document pdf, List<SaleData>? salesList, Uint8List image) {
    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children:[
            pw.Text('Detalle Ventas', style: const pw.TextStyle(fontSize: 20, color: PdfColors.black)),
            pw.Image(pw.MemoryImage(image), width: 50, height: 50),
          ]
        ),
        build: (context) => [
          pw.ListView.builder(
            itemCount: salesList!.length,
            itemBuilder: (context, index) {
              final sale = salesList[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children:[
                    pw.Text('Código Venta: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(sale.idSale.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Importe: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${sale.amountSale.toString()} €",style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Fecha: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(DateFormat('dd/MM/yyyy').format(sale.dateSale).toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                  pw.Text('Productos:',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.ListView.builder(
                    itemCount: sale.products.length,
                    itemBuilder: (context, productIndex) {
                      final product = sale.products[productIndex];
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(children:[
                              pw.Text('Nombre: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text(product.nameProduct,style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                              ] 
                            ),
                            pw.Row(children:[
                              pw.Text('   Cantidad: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text(product.quantityProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                              ] 
                            ),
                            pw.Row(children:[
                              pw.Text('   Precio producto: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text(product.priceProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                              ] 
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  pw.Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> savePDF(pw.Document pdf, List<Company> companyList, bool includeAllYear, bool includeSalesBreakdown) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '';
    if (includeAllYear == true && includeSalesBreakdown){
      path = '$dir/Ventas_Anual_Detail_${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (includeAllYear && !includeSalesBreakdown) {
      path = '$dir/Ventas_Anual${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (includeSalesBreakdown && !includeAllYear) {
      path = '$dir/Ventas_Detail${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (!includeAllYear && !includeSalesBreakdown) {
      path = '$dir/Ventas_${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    return path; // Devolver la ruta del archivo PDF
  }


  void generateHistorySales(pw.Document pdf, List<SaleData>? salesList, Uint8List image) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children:[
            pw.Text('Historial Ventas', style: const pw.TextStyle(fontSize: 20, color: PdfColors.black)),
            pw.Image(pw.MemoryImage(image), width: 50, height: 50),
          ]
        ),
        build: (pw.Context context) => [
          pw.Table.fromTextArray(
            context: context,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30.0,
            cellAlignments: {
              0: pw.Alignment.centerRight,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerLeft
            },
            data: <List<String>>[
              <String>['ID Venta', 'Fecha', 'Total', 'Productos'],
              ...salesList!.map((sale) => [
                sale.idSale.toString(),
                DateFormat('dd-MM-yyyy').format(sale.dateSale),
                '${sale.amountSale} €',
                sale.products.map((p) => '${p.nameProduct} x${p.quantityProduct}').join(', '),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  void generateFrontPage(pw.Document pdf, Uint8List image, List<Company> companyList) {
    pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text("Informe de Ventas", style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Image(pw.MemoryImage(image), height: 120, width: 120),
              pw.SizedBox(height: 20),
              pw.Text(companyList.first.nameCompany, style: const pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text(DateFormat('dd-MM-yyyy').format(DateTime.now())),
            ],
          ),
        );
      }
    ),
  );

}

Future<void> uploadPdfToFirebaseStorage(File pdfFile, bool includeAllYear, bool includeSalesBreakdown) async {
  try {
    final Reference storageReference = FirebaseStorage.instance
    .ref()
    .child('SalesReports/${path.basename(pdfFile.path)}');

    final UploadTask uploadTask = storageReference.putFile(pdfFile);

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();

    await uploadReportToDataBase(includeAllYear, includeSalesBreakdown, url);

    //Cargar la URL mediante API en la BBDD
    print('URL del PDF en Firebase Storage: $url');
  } catch (e) {
    print('Error al cargar el PDF en Firebase Storage: $e');
  
  }
}

Future<void> uploadReportToDataBase(bool includeAllYear, bool includeSalesBreakdown, String url) async {
  String formattedDate = DateFormat('dd-MM-yyyy – hh:mm:ss').format(DateTime.now().toLocal());
  
  final reportData = {
      "idCompany": globalIdCompany,
      "idReport": globalMaxIdReport +1,
      "dateReport": formattedDate,
      "isAnnualReport": includeAllYear,
      "includesDetail": includeSalesBreakdown,
      "typeReport": 'Sales',
      "urlReport": url,
    };
  
    try {
      final response = await postNewReport(reportData);
  
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
}