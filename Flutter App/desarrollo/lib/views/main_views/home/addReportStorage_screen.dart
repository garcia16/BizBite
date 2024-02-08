import 'package:flutter/material.dart';
import '../../../logic/reports/buildStorageReports.dart';
import '../../../utils/comun_widgets.dart';

  List<String> list = <String>['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo','Junio', 'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
  List<String> listYear = <String>['2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030'];

class AddStorageReportView extends StatefulWidget {

  @override
  _AddStorageReportViewState createState() => _AddStorageReportViewState();
}

class _AddStorageReportViewState extends State<AddStorageReportView> {
  bool includeAllYear = false;
  bool includeStockBreakdown = false;
  bool uploadToCloud = false;
  String dropdownValue = list.first;
  String dropdownValueYear = listYear.first;
  double ventasTotalAnual = 0;
  double ventasTotalMes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context, 'Nuevo informe de almacén'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Mes:', style: TextStyle(fontSize: 18),),
                seleecionarMes(),
                const Text('Año:', style: TextStyle(fontSize: 18)),
                seleecionarYear(),
              ],
            ),
            selectAllYear(),
            selectFullSales(),
            selectUploadToCloud(),
            buttonGenerateReport(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton buttonGenerateReport(BuildContext context) {
    return ElevatedButton(
      onPressed: () async{
        await generatePdfStorage(includeAllYear, includeStockBreakdown, uploadToCloud, dropdownValue, dropdownValueYear);
        Navigator.pop(context);
      },
      style: buttonStyleOne(context),
      child: Text("Generar Informe", style: TextStyle(color: Theme.of(context).colorScheme.outline),)
    );
  }

  CheckboxListTile selectUploadToCloud() {
    return CheckboxListTile(
      title: const Text('Subir Informe a la nube'),
      value: uploadToCloud,
      onChanged: (bool? value) {
        setState(() {
          uploadToCloud = value!;
        });
      },
    );
  }

  CheckboxListTile selectFullSales() {
    return CheckboxListTile(
      title: const Text('Incluir histórico de reposición de stock'),
      value: includeStockBreakdown,
      onChanged: (bool? value) {
        setState(() {
          includeStockBreakdown = value!;
        });
      },
    );
  }

  CheckboxListTile selectAllYear() {
    return CheckboxListTile(
      title: const Text('Seleccionar todo el año'),
      value: includeAllYear,
      onChanged: (bool? value) {
        setState(() {
          includeAllYear = value!;
        });
      },
    );
  }

DropdownButton<String> seleecionarMes() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 1,
      ),
      onChanged: includeAllYear
      ? null
      : (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021),),
        );
      }).toList(),
    );
  }

  DropdownButton<String> seleecionarYear() {
    return DropdownButton<String>(
      value: dropdownValueYear,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 1,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValueYear = value!;
        });
      },
      items: listYear.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.021),),
        );
      }).toList(),
    );
  }

}
