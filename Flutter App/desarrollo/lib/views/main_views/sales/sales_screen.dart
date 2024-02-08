

import 'package:desarrollo/models/sale.dart';
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../utils/comun_widgets.dart';
import '../../../utils/constants.dart';
import 'add_sale_screen.dart';
import 'package:intl/intl.dart';

class SalesView extends StatefulWidget {


  @override
  _SalesViewState createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {

  DateTime? _startDate;
  DateTime? _endDate;
  bool _sortAscending = true;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ordenar la lista por fecha de manera descendente por defecto.
    saleList.sort((a, b) => b.dateSale.compareTo(a.dateSale));
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarClassic(context,'BizBite'),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildSalesList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => AddSaleScreen())
          ).then((_) async {
            await GlobalData.loadData();
            setState(() {
              saleList = saleList;
            });
          });
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildDateField(_startDateController, true, 'Desde'),
          ),
          const SizedBox(width: 8), // Espacio entre los campos de fecha
          Expanded(
            child: _buildDateField(_endDateController, false, 'Hasta'),
          ),
          _buildSortButton(),
          _buildClearFiltersIcon(),
        ],
      ),
    );
  }

  //Widget para los campos de fecha
  Widget _buildDateField(TextEditingController controller, bool isStartDate, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range, color: Theme.of(context).colorScheme.surface),
          onPressed: () => _selectDate(context, isStartDate),
        ),
        border: const OutlineInputBorder(), // Agrega bordes para definir mejor los campos
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
      ),
      readOnly: true,
      onTap: () => _selectDate(context, isStartDate),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      builder:(context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Theme.of(context).colorScheme.primary, 
            onPrimary: Colors.white,
            onSurface: Colors.white 
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white, 
            ),
          ),
        ),
        child: child!
        );
      },
      helpText: 'Selecciona una fecha',
      context: context,
      initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && (isStartDate ? picked != _startDate : picked != _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }
  
  Widget _buildClearFiltersIcon() {
    return IconButton(
      icon: Icon(Icons.delete_sweep_rounded, color: Theme.of(context).colorScheme.surface),
      onPressed: () {
        setState(() {
          _startDate = null;
          _endDate = null;
          _startDateController.clear();
          _endDateController.clear();
          saleList.sort((a, b) => b.dateSale.compareTo(a.dateSale));
        });
      },
      tooltip: 'Limpiar filtros',
    );
  }

  Widget _buildSalesList() {

    List<SaleData> filteredSalesList = saleList
        .where((sale) => (_startDate == null || sale.dateSale.isAfter(_startDate!)) && (_endDate == null || sale.dateSale.isBefore(_endDate!)))
        .toList();

    if (!_sortAscending) {
      filteredSalesList.sort((a, b) => b.amountSale.compareTo(a.amountSale));
    } else {
      filteredSalesList.sort((a, b) => a.amountSale.compareTo(b.amountSale));
    }

    return ListView.builder(
      itemCount: filteredSalesList.length,
      itemBuilder: (context, index) {
        final sale = filteredSalesList[index];

        return Card(
          color: Theme.of(context).colorScheme.outline,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 3,
          child: ExpansionTile(
            expandedAlignment: Alignment.centerLeft,
            leading: Icon(Icons.receipt, color: Theme.of(context).colorScheme.surface),
            title: Text("Ticket: ${sale.idSale}", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Importe: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                    Text("${sale.amountSale} €", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),

                  ],
                ),
                Row(
                  children: [
                    Text("Fecha: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                    Text("${DateFormat('dd/MM/yyyy').format(sale.dateSale)}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),

                  ],
                )
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sale.products.map((product) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Producto: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text(product.nameProduct, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),

                          ],
                        ),
                        Row(
                          children: [
                            Text(" Cantidad: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text(" ${product.quantityProduct}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(" Precio: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text(" ${product.priceProduct} €", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ],
            // Se activa cuando el usuario presiona el ítem
            onExpansionChanged: (bool expanded) {
            },
          ),
        );
      },
    );
  }

  Widget _buildSortButton() {
    return IconButton(
      icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward, color: Theme.of(context).colorScheme.surface),
      onPressed: () {
        setState(() {
          _sortAscending = !_sortAscending;
        });
      },
      tooltip: 'Ordenar por importe',
    );
  }

}
