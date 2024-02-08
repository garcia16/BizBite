import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/company.dart';
import '../../models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../../utils/constants.dart';
import 'postNewReport.dart';



Future<void> generatePdfStorage(bool includeAllYear, bool includeStockBreakdown, bool uploadToCloud, String dropdownValue, String dropdownValueYear) async {

    final pdf = pw.Document();
    final image = (await http.get(Uri.parse(companyList.first.photoCompany!))).bodyBytes;

     // Cargar imágenes de productos
    final productImages = await _loadProductImages(productList);


    //Creación portada Informe
    generateFrontPage(pdf, image, companyList);

    //Hoja con Tabla de Productos
    generateProductList(pdf, productList, productImages,image);

    //Hoja con Detalle de los productos
    generateDetailStorage(pdf, productList, image);

    // Guardar el PDF
    final String pdfPath = await savePDF(pdf, companyList, includeAllYear, includeStockBreakdown);

    // Opcional: abrir el PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());

    if (uploadToCloud) {
      final File pdfFile = File(pdfPath);
      await uploadPdfToFirebaseStorage(pdfFile, includeAllYear, includeStockBreakdown);
    }
  }

  Future<List<Uint8List>> _loadProductImages(List<ProductData>? productList) async {
    List<Uint8List> images = [];
    for (var product in productList!) {
      final image = (await http.get(Uri.parse(product.photoProduct!))).bodyBytes;
      images.add(image);
    }
    return images;
  }

  void generateDetailStorage(pw.Document pdf, List<ProductData>? productList, Uint8List image) {
    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children:[
            pw.Text('Detalle Productos', style: const pw.TextStyle(fontSize: 20, color: PdfColors.black)),
            pw.Image(pw.MemoryImage(image), width: 50, height: 50),
          ]
        ),
        build: (context) => [
          pw.ListView.builder(
            itemCount: productList!.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(children:[
                    pw.Text('Nombre: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.nameProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Referencia: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.referenceProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Precio: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${product.priceProduct.toString()} €",style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Precio de venta: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${product.salePriceProduct.toString()} €",style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Stock: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.stockProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Categoría: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.categoryProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Distribuidor: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.distributorProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Row(children:[
                    pw.Text('Notas: ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(product.notesProduct.toString(),style: pw.TextStyle(color: PdfColors.blue,fontWeight: pw.FontWeight.bold)),
                    ] 
                  ),
                  pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                  
                  pw.Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<String> savePDF(pw.Document pdf, List<Company> companyList, bool includeAllYear, bool includeStockBreakdown) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '';
    if (includeAllYear == true && includeStockBreakdown){
      path = '$dir/Almacen_Anual_Detail_${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (includeAllYear && !includeStockBreakdown) {
      path = '$dir/Almacen_Anual${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (includeStockBreakdown && !includeAllYear) {
      path = '$dir/Almacen_Detail${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }else if (!includeAllYear && !includeStockBreakdown) {
      path = '$dir/Almacen_${companyList.first.nameCompany}_${DateFormat('dd-MM-yyyy').format(DateTime.now())}_${globalMaxIdReport +1}.pdf';
    }
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    return path; // Devolver la ruta del archivo PDF
  }


  void generateProductList(pw.Document pdf, List<ProductData>? productList, List<Uint8List> productImages, Uint8List image) {
    final headerStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 10,
      color: PdfColors.white,
    );
    final cellStyle = pw.TextStyle(
      fontSize: 10,
      color: PdfColors.black,
    );
    const cellAlignment = pw.Alignment.centerLeft;
    final cellPadding = pw.EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0);
    const headerDecoration = pw.BoxDecoration(color: PdfColors.blue);
    const rowDecoration = pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: .5)));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children:[
            pw.Text('Listado de Productos', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
            pw.Image(pw.MemoryImage(image), width: 50, height: 50),
          ]
        ),
        build: (pw.Context context) => [
          pw.Table(
            children: [
              pw.TableRow(
                decoration: headerDecoration,
                children: [
                  pw.Container(child: pw.Text('Imagen', style: headerStyle), alignment: cellAlignment, padding: cellPadding),
                  pw.Container(child: pw.Text('Nombre', style: headerStyle), alignment: cellAlignment, padding: cellPadding),
                  pw.Container(child: pw.Text('Referencia', style: headerStyle), alignment: cellAlignment, padding: cellPadding),
                  pw.Container(child: pw.Text('Distribuidor', style: headerStyle), alignment: cellAlignment, padding: cellPadding),
                  pw.Container(child: pw.Text('Stock', style: headerStyle), alignment: cellAlignment, padding: cellPadding),
                ]
              ),
              ...List.generate(productList!.length, (index) {
                final product = productList[index];
                return pw.TableRow(
                  decoration: index % 1 == 0 ? rowDecoration : null,
                  children: [
                    pw.Container(child: pw.Image(pw.MemoryImage(productImages[index]), width: 50, height: 50), padding: cellPadding),
                    pw.Container(child: pw.Text(product.nameProduct.toString(), style: cellStyle), alignment: cellAlignment, padding: cellPadding),
                    pw.Container(child: pw.Text(product.referenceProduct.toString(), style: cellStyle), alignment: cellAlignment, padding: cellPadding),
                    pw.Container(child: pw.Text(product.distributorProduct.toString(), style: cellStyle), alignment: cellAlignment, padding: cellPadding),
                    pw.Container(child: pw.Text(product.stockProduct.toString(), style: cellStyle), alignment: cellAlignment, padding: cellPadding),
                  ]
                );
              }),
            ],
          ),
        ],
      ),
    );
  }



Future<pw.Widget> _loadImage(String imageUrl) async {
  final image = (await http.get(Uri.parse(imageUrl))).bodyBytes;
  return pw.Image(pw.MemoryImage(image), width: 50, height: 50);
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
              pw.Text("Informe de Almacén", style: const pw.TextStyle(fontSize: 24)),
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

Future<void> uploadPdfToFirebaseStorage(File pdfFile, bool includeAllYear, bool includeStockBreakdown) async {
  try {
    final Reference storageReference = FirebaseStorage.instance
    .ref()
    .child('StorageReports/${path.basename(pdfFile.path)}');

    final UploadTask uploadTask = storageReference.putFile(pdfFile);

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();

    await uploadReportToDataBase(includeAllYear, includeStockBreakdown, url);

    //Cargar la URL mediante API en la BBDD
    print('URL del PDF en Firebase Storage: $url');
  } catch (e) {
    print('Error al cargar el PDF en Firebase Storage: $e');
  
  }
}

Future<void> uploadReportToDataBase(bool includeAllYear, bool includeStockBreakdown, String url) async {
  String formattedDate = DateFormat('dd-MM-yyyy – hh:mm:ss').format(DateTime.now().toLocal());
  
  final reportData = {
      "idCompany": globalIdCompany,
      "idReport": globalMaxIdReport +1,
      "dateReport": formattedDate,
      "isAnnualReport": includeAllYear,
      "includesDetail": includeStockBreakdown,
      "typeReport": 'Storage',
      "urlReport": url,
    };
  
    try {
      final response = await postNewReport(reportData);
  
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
}