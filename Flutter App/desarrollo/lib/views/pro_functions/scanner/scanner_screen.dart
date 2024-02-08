// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../../../logic/sales/putNewScanSale.dart';
import '../../../utils/constants.dart';

class ScannerView extends StatelessWidget {
  final String? pathImage;
  ScannerView(this.pathImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardar ticket', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF2C3E50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CameraApp(pathImage),
    );
  }
}


class CameraApp extends StatefulWidget {
  final String? pathImage;
  CameraApp( this.pathImage);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  String? imagePath;
  String? extractedText;
  String? dateTicket;
  String? totalTicket;

  @override
  void initState() {
    super.initState();
    if (widget.pathImage != null) {
      imagePath = widget.pathImage;
      extractTextFromImage(widget.pathImage!);
    }
  }

  Future<void> extractTextFromImage(String pathImage) async {
    //Obtengo el texto de la imagen
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final inputImage = InputImage.fromFilePath(pathImage);
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);

    //Agrupo en lineas el texto obtenido
    List<TextLine> allLines = [];
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        allLines.add(line);
      }
    }

    //Ordeno las lineas de todos los bloques y  las ordena de arriba a abajo
    //según su posición en la imagen y luego concatena el texto de cada línea
    //en un solo string. Obtenemos un texto que fluye de arriba a abajo, sin importar
    //si había grandes espacios en blanco entre las líneas en la imagen original.
    allLines.sort((a, b) {
      int compareTop = a.boundingBox.top.compareTo(b.boundingBox.top);
      if (compareTop == 0) {
        // Si las líneas están al mismo nivel, clasificarlas por su posición horizontal.
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      } else {
        return compareTop;
      }
    });

    String resultText = '';
    String? dateFound;
    String? totalFound;

    //Para buscar una fecha entre el texto de la línea
    RegExp dateRegEx = RegExp(r"\b(\d{2}|\d{4})-\d{2}-\d{2}( \d{2}:\d{2}(:\d{2})?)?\b|\b\d{1,2}[./]\d{1,2}[./]\d{2,4}( \d{2}:\d{2}(:\d{2})?)?\b");

    //Para buscar un numero con 2 decimales, lo uso después
    RegExp totalRegEx = RegExp(r"\b\d{1,3}(?:[.,]\d{3})*(?:[.,]\d{2})\b");
    int totalLineOffset = -1;

    for (int i = 0; i < allLines.length; i++) {
      TextLine line = allLines[i];
      resultText += '${line.text}\n';

      //Buscamos en la línea que estamos recorriendo si hay algun valor que coincida
      //con el formato de una fecha
      if (dateFound == null && dateRegEx.hasMatch(line.text)) {
        dateFound = dateRegEx.firstMatch(line.text)?.group(0);
      }

      //Buscamos en la línea que estamos recorriendo si hay algun valor que coincida
      //con el formato de un importe, siempre que en las 2 líneas anteriores estuviese la palabra
      //"Total" o "Importe"
      if (totalFound == null) {
        if (line.text.contains(
                RegExp(r'\b(Total|Importe)\b', caseSensitive: false)) &&
            !line.text
                .contains(RegExp(r'\b(Subtotal)\b', caseSensitive: false))) {
          if (totalRegEx.hasMatch(line.text)) {
            totalFound = totalRegEx.firstMatch(line.text)?.group(0);
            continue;
          }

          // Si no se encuentra un importe en la misma línea, busquemos en las próximas 2 líneas
          else if (i + 1 < allLines.length &&
              totalRegEx.hasMatch(allLines[i + 1].text)) {
            totalFound = totalRegEx.firstMatch(allLines[i + 1].text)?.group(0);
            continue;
          } else if (i + 2 < allLines.length &&
              totalRegEx.hasMatch(allLines[i + 2].text)) {
            totalFound = totalRegEx.firstMatch(allLines[i + 2].text)?.group(0);
            continue;
          }
        }

        if (line.text.contains("EUR")) {
          String beforeEUR = line.text.split("EUR")[0].trim();
          if (totalRegEx.hasMatch(beforeEUR)) {
            totalFound = totalRegEx.firstMatch(beforeEUR)?.group(0);
          }
        }

        // Incrementar el totalLineOffset si la línea no contenía "Total" o "Importe"
        if (!line.text.contains(
            RegExp(r'\b(Total|Importe|EUR)\b', caseSensitive: false))) {
          totalLineOffset++;
        }
      }
    }
    dateFound ??= "Sin fecha";
    totalFound ??= "Sin importe";

    textDetector.close();

    setState(() {
      extractedText = resultText;
      dateTicket = dateFound;
      totalTicket = totalFound;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20), // Top spacing
            if (imagePath != null)
              Column(
                children: [
                  Image.file(
                    File(imagePath!),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width * 0.8, // Added width
                    fit: BoxFit.cover, // To maintain aspect ratio
                  ),
                  const SizedBox(height: 20),
                  if (extractedText != null)
                    Card(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.outline,
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Datos Extraídos",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Fecha: $dateTicket",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Total: $totalTicket €",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                _saveSale();
                              },
                              icon: const Icon(Icons.save, color: Colors.white),
                              label: const Text('Guardar Venta', style: TextStyle(color: Colors.white),),
                              style: buttonStyleOne(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSale() async {

    final imageURL = await compressAndUploadImage();

      final saleData = {
        "idCompany": globalIdCompany,
        "idSale": globalMaxIdSales +1,
        "idUser": 1,
        "amountSale": totalTicket,
        "dateSale": dateTicket,
        "photoSale": imageURL,

      };

      try {
        final response = await putNewScanSale(saleData);
        if(response == true){
          await showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: buildDialogContent(context, '¡Venta guardada!','La venta se ha registrado correctamente.'),
            ),
          );
          Navigator.pop(context);
        }

      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack Trace: $stackTrace');
      }
   
  }

  Future<String> compressAndUploadImage() async {
    String imageUrl = '';
    try {
      // Comprobando si la imagen ha sido seleccionada
      if (imagePath == null) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/bizbitedesa-ab493.appspot.com/o/default-image.jpg?alt=media&token=f9d756fd-168c-4d41-b9a3-4cefa36d3f8f';
      }else{

        final path = imagePath;
        String? fileName = "Ticket: ${globalMaxIdSales +1}" ;
        final storageRef = FirebaseStorage.instance.ref().child(globalIdCompany.toString()).child(fileName!);

        // Comprimir la imagen antes de subirla
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
          path!,
          minWidth: 400,
          minHeight: 400,
          quality: 70,
        );

        if (compressedImage == null) {
          throw Exception("Failed to compress image");
        }

        // Subir la imagen comprimida al Storage de Firebase
        final uploadTask = storageRef.putData(
          compressedImage,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        // Esperando a que la tarea de subida termine
        await uploadTask.whenComplete(() {});

        imageUrl = await storageRef.getDownloadURL();
        }
      } catch (e) {
        print("Error uploading image: $e");
        // Puedes manejar el error de manera más adecuada según tu aplicación
      }
    
    return imageUrl;
  }

}