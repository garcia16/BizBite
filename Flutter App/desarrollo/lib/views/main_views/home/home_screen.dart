import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'reportSales_screen.dart';
import 'reportStorage_screen.dart';

class HomeView extends StatefulWidget {

  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarClassic(context,'BizBite'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompanyHeader(),
            _buildSalesSummary(),
            _buildLowStockAlerts(),
            _buildReportsLine()
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(companyList[0].photoCompany ?? "https://placehold.co/600x400/png"), // Usa la imagen del producto
            radius: 30.0,
          ),
          const SizedBox(width: 16),
          Text(
            companyList[0].nameCompany,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.surface,),
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.arrow_drop_down_circle_outlined), color: Theme.of(context).colorScheme.onBackground,
          )
        ],
      ),
    );
  }

  Widget _buildSalesSummary() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumen de Ventas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surface,),
          ),
          const SizedBox(height: 10),
          Table(
            columnWidths: const {
              0: FractionColumnWidth(0.4),
            },
            children: [
              _buildTableRow("Hoy:", "1000€"), 
              _buildTableRow("Semana:", "5000€"),
              _buildTableRow("Mes:", "20000€"),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLowStockAlerts() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alertas de Stock Bajo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          _buildStockAlertItem("Producto A", "5 unidades restantes"),
          _buildStockAlertItem("Producto B", "2 unidades restantes"),
        ],
      ),
    );
  }

  Widget _buildStockAlertItem(String productName, String stock) {
    return ListTile(
      leading: const Icon(Icons.warning, color: Colors.red),
      title: Text(productName),
      subtitle: Text(stock),
      trailing: ElevatedButton(
        onPressed: () {
          // Acción para reabastecer el producto.
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text("Reabastecer", style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,),)
        
      ),
    );
  }

  Widget _buildReportsLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informes y gráficos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          _buildReportItem("Informes", "Obtener informes en PDF/Excel de tu almacén y/o Ventas.",Icon(Icons.insert_drive_file_rounded, color: Theme.of(context).colorScheme.onTertiaryContainer,),"ReportPDF"),
          _buildReportItem("Gráficos", "Visualiza los datos de tu empresa en diferentes gráficos.",Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.onTertiaryContainer,),"Chart"),
        ],
      ),
    );
  }

  Widget _buildReportItem(String report, String detail, Icon iconData, String routeNav) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: iconData,
        title: Text(report, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onTertiaryContainer,)),
        subtitle: Text(detail, style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,),),
        onTap: () {
          if(report == 'Informes'){
            // Método para mostrar el diálogo de selección
            _showReportSelectionDialog(context);
          }
          
        },
      ),
    );
  }

  // Método para mostrar el diálogo de selección
void _showReportSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccionar Tipo de Informe', style: TextStyle(fontSize: 22),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                    Text('Informe de Ventas',style: TextStyle(fontSize: 16)),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _navigateToSalesReportView(context);
                },
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              GestureDetector(
                child: const Row(
                  children: [
                    Icon(Icons.arrow_forward_ios),
                    Text('Informe de Almacén',style: TextStyle(fontSize: 16)),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _navigateToStorageReportView(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Navegar a la pantalla de Informe de Ventas
void _navigateToSalesReportView(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SalesReportView()),
  );
}

// Navegar a la pantalla de Informe de Almacén
void _navigateToStorageReportView(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => StorageReportView()),
  );
}



}
