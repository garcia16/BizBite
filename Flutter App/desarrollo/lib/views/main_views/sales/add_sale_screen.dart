// ignore_for_file: use_build_context_synchronously

import 'package:desarrollo/logic/sales/putNewManualSale.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/newSale.dart';
import '../../../models/product.dart';
import '../../../utils/constants.dart';
import '../../pro_functions/scanner/camera_view_screen.dart';
import '../company/premium_screen.dart';

class AddSaleScreen extends StatefulWidget {

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<NewSale> productsToAddToTicket = [];
  ProductData? selectedProduct; 
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Añadir venta', style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
        backgroundColor: Theme.of(context).colorScheme.onTertiary,
        elevation: 0,
        actions: [
          globalCompanyPlan == "Pro"
              ? IconButton(
                  icon: Icon(Icons.document_scanner_outlined, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraView()));
                  },
                )
              : Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: Icon(Icons.document_scanner_outlined, color: Theme.of(context).colorScheme.tertiary),
                      onPressed: _showUpgradeDialog, // Deshabilita el botón si no es "Pro"
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 26), // Ajustar según sea necesario
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8), // Borde redondeado
                      ),
                      child: const Text(
                        'Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Ajustar el tamaño del texto
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.tertiary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            searchProduct(),
            const SizedBox(height: 20),
            quantityAndAmountFields(context),
            const SizedBox(height: 20),
            addToTicketButton(context),
            const SizedBox(height: 20),
            const Text('Ticket:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            listViewTicketProducts(),
            const SizedBox(height: 10),
            totalAmountSale(),
            const SizedBox(height: 20),
            saveTicketButton(context),
          ],
        ),
      ),
    );
  }

  ElevatedButton saveTicketButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _saveSale,
      icon: Icon(Icons.save, color: Theme.of(context).colorScheme.onTertiaryContainer),
      label: Text('Guardar Venta', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer)),
      style: buttonStyleOne(context),
    );
  }

  Row totalAmountSale() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Importe Total:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          '${totalAmount.toStringAsFixed(2)}€',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  Expanded listViewTicketProducts() {
    return Expanded(
      child: ListView.builder(
        itemCount: productsToAddToTicket.length,
        itemBuilder: (context, index) {
          final product = productsToAddToTicket[index];
          return ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(product.nameProduct),
            subtitle: Text('Cantidad: ${product.quantityProduct}\nPrecio unidad: ${product.amountProduct}€\nPrecio total: ${product.amountProduct * product.quantityProduct}€'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removeSale(index),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton addToTicketButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _addSale,
      icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer),
      label: Text('Añadir al Ticket', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer)),
      style: buttonStyleOne(context),
    );
  }

  Row quantityAndAmountFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusColor: Theme.of(context).colorScheme.surface,
              labelText: 'Cantidad',
              prefixIcon: const Icon(Icons.onetwothree_outlined),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Precio',
              prefixIcon: Icon(Icons.euro_symbol),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Autocomplete<ProductData> searchProduct() {
    return Autocomplete<ProductData>(
      displayStringForOption: (ProductData option) => option.nameProduct,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<ProductData>.empty();
        }
        return productList.where((ProductData product) {
          return product.nameProduct.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (ProductData product) {
        setState(() {
          selectedProduct = product;
          _quantityController.clear();
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        _searchController = fieldTextEditingController; 
        return TextField(
          controller: _searchController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            labelText: 'Buscar Producto',
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary,),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<ProductData> onSelected, Iterable<ProductData> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductData option = options.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.nameProduct, style: const TextStyle(fontWeight: FontWeight.bold),),
                      Text("Stock actual: ${option.stockProduct.toString()}")
                    ],
                  ),
                  onTap: () {
                    onSelected(option);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _addSale() {
    if (selectedProduct != null && _quantityController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      final newSale = NewSale(
        nameProduct: selectedProduct!.nameProduct,
        idProduct: selectedProduct!.idProduct,
        idCompany: selectedProduct!.idCompany,
        amountProduct: int.parse(_priceController.text),
        quantityProduct: int.parse(_quantityController.text),
      );

      // Verificar si el producto ya existe en la lista
      final isDuplicate = productsToAddToTicket.any((sale) => sale.idProduct == newSale.idProduct);
      if (isDuplicate) {
        // Mostrar un diálogo de confirmación
        _showDuplicateProductDialog(newSale);
      } else {
        _addProductToList(newSale);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, rellena todos los campos para añadir al ticket', style: TextStyle(color: Theme.of(context).colorScheme.outline),),
        backgroundColor: Theme.of(context).colorScheme.surface ,
      ),
    );
    }
  }

  void _addProductToList(NewSale sale) {
    setState(() {
      productsToAddToTicket.add(sale);
      _updateTotalAmount();
      _clearFields();
    });
  }

  void _removeSale(int index) {
    setState(() {
      productsToAddToTicket.removeAt(index);
      _updateTotalAmount();
    });
  }

  void _updateTotalAmount() {
    double sum = 0.0;
    for (var sale in productsToAddToTicket) {
      sum += sale.amountProduct * sale.quantityProduct;
    }
    setState(() {
      totalAmount = sum;
    });
  }

  void _clearFields() {
    _searchController.clear();
    _quantityController.clear();
    _priceController.clear();
    selectedProduct = null;
  }

  Future<void> _saveSale() async {

    if (productsToAddToTicket.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, añade productos al ticket antes de guardar', style: TextStyle(color: Theme.of(context).colorScheme.outline),),
        backgroundColor: Theme.of(context).colorScheme.surface ,
      ),
    );
      return;
    }else{
      DateTime now = DateTime.now().toLocal();
      String formattedDate = DateFormat('dd-MM-yyyy – hh:mm:ss').format(now);

      final saleData = {
        "idCompany": globalIdCompany,
        "idSale": globalMaxIdSales +1,
        "idUser": 1,
        "amountSale": totalAmount,
        "dateSale": formattedDate,
        "photoSale": null,
        "products": productsToAddToTicket,

      };

      try {
        final response = await putNewManualSale(saleData);
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
    
  }

  void _showDuplicateProductDialog(NewSale newSale) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Producto Duplicado"),
          content: const Text("Este producto ya está en el ticket. ¿Quieres añadirlo de todos modos?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
                _addProductToList(newSale); 
              },
            ),
          ],
        );
      },
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Función Premium'),
          content: const Text('Esta función está disponible solo para usuarios con el plan Pro. ¿Deseas actualizar tu plan?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumView()));
              },
            ),
          ],
        );
      },
    );
  }
}


