// ignore_for_file: use_build_context_synchronously

import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';

import '../../../logic/warehouse/putStockProducts.dart';
import '../../../models/product.dart';
import '../../../models/updateProduct.dart';
import '../../../utils/constants.dart';

class UpdateStockScreen extends StatefulWidget {

  @override
  _UpdateStockScreenState createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<UpdateProduct> productsToUpdate = [];
  ProductData? selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context, 'Actualizar Stock'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Autocomplete<ProductData>(
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
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cantidad',
                prefixIcon: Icon(Icons.onetwothree_outlined, color: Theme.of(context).colorScheme.primary,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addProduct,
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer,),
              label: Text('Añadir al Stock', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,)),
              style: buttonStyleOne(context),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Resumen:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.onSecondary,),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: productsToUpdate.length,
                itemBuilder: (context, index) {
                  final product = productsToUpdate[index];
                  return Card(
                    color: Theme.of(context).colorScheme.outline,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(product.nameProduct, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,fontWeight: FontWeight.bold)),
                      subtitle: Text('Nuevo stock: ${product.nuevoStock}, Stock total: ${product.nuevoStock + product.stockActual}', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error,),
                        onPressed: () => _removeProduct(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveStock,
              style: buttonStyleOne(context),
              child: Text('Guardar Stock', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _addProduct() {
  if (selectedProduct != null && _quantityController.text.isNotEmpty) {
    final newStock = int.tryParse(_quantityController.text) ?? 0;
    final newProduct = UpdateProduct(
      nameProduct: selectedProduct!.nameProduct,
      idProduct: selectedProduct!.idProduct,
      idCompany: selectedProduct!.idCompany,
      stockActual: selectedProduct!.stockProduct,
      nuevoStock: newStock,
      totalStock: newStock + selectedProduct!.stockProduct
    );

    // Verifica si el producto ya existe en la lista
    final existingProductIndex = productsToUpdate.indexWhere((p) => p.idProduct == newProduct.idProduct);
    if (existingProductIndex != -1) {
      // Muestra un diálogo de confirmación
      _showReplaceProductDialog(existingProductIndex, newProduct);
    } else {
      _addNewProduct(newProduct);
    }
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, completa los campos para añadir el producto a la lista para actualizar.',style: TextStyle(color: Theme.of(context).colorScheme.outline),),
        backgroundColor: Theme.of(context).colorScheme.surface,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

void _addNewProduct(UpdateProduct product) {
  setState(() {
    productsToUpdate.add(product);
    _searchController.clear();
    _quantityController.clear();
    selectedProduct = null;
  });
}

void _showReplaceProductDialog(int index, UpdateProduct newProduct) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Producto Duplicado"),
          content: const Text("Este producto ya está en la lista. ¿Quieres reemplazarlo con la nueva cantidad?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text("Reemplazar"),
              onPressed: () {
                setState(() {
                  productsToUpdate[index] = newProduct; // Reemplaza el producto
                  _searchController.clear();
                  _quantityController.clear();
                  selectedProduct = null;
                });
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void _removeProduct(int index) {
    setState(() {
      productsToUpdate.removeAt(index);
    });
  }

  Future<void> _saveStock() async {
     if (productsToUpdate.isNotEmpty) {

      final response = await putStockProducts(productsToUpdate);
      print(response);

       await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: buildDialogContent(context, '¡Stock actualizado!','El stock de los productos se ha actualizado correctamente.'),
          ),
        );
        Navigator.pop(context);
     }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay productos en la lista para actualizar.',style: TextStyle(color: Theme.of(context).colorScheme.outline),),
          backgroundColor: Theme.of(context).colorScheme.surface,
          duration: const Duration(seconds: 2),
        ),
      );
     }
    
  }
}



