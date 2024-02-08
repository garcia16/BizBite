// ignore_for_file: use_build_context_synchronously

import 'package:desarrollo/models/product.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:desarrollo/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../logic/warehouse/deleteCategoryProduct.dart';
import '../../../logic/warehouse/postNewCategoryProduct.dart';
import '../../../logic/warehouse/putEditCategoryProduct.dart';


class EditCategoriesPage extends StatefulWidget {

  @override
  _EditCategoriesPageState createState() => _EditCategoriesPageState();
}

class _EditCategoriesPageState extends State<EditCategoriesPage> {
  @override
  Widget build(BuildContext context) {
      categoryProducts.sort((a, b) => a.nameCategory.compareTo(b.nameCategory));
    return Scaffold(
      appBar: appBarToBack(context,'Editar categorías'),
      body: ListView.builder(
        itemCount: categoryProducts.length,
        itemBuilder: (BuildContext context, int index) {
        // Contar productos de la misma categoría
        int count = productList.where((ProductData product) =>
          product.categoryProduct == categoryProducts[index].nameCategory).length;

        return ListTile(
          title: Text(
            categoryProducts[index].nameCategory,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Nº productos: $count'), 
          trailing: Wrap(
            spacing: 12, 
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary,),
                onPressed: () {
                  _editCategory(index, categoryProducts[index].categoryProduct, categoryProducts[index].nameCategory,count);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red,),
                onPressed: () {
                  _deleteCategory(index, categoryProducts[index].categoryProduct, categoryProducts[index].nameCategory,count);
                },
              ),
            ],
          ),
        );
      },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewCategory();
        },
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer,), 
      ),
    );
  }

  Future<void> _addNewCategory() async {
    // Crear un TextEditingController para capturar la entrada del usuario
    TextEditingController categoryController = TextEditingController();
    // Mostrar un diálogo para ingresar el nombre de la nueva categoría
    return showDialog(
        context: context,
        barrierDismissible: false, // El usuario necesitará presionar los botones para cerrar el diálogo
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Añadir nueva categoría'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('Por favor ingrese el nombre de la categoría:'),
                  // Campo de texto para ingresar el nombre de la categoría
                  TextField(
                    controller: categoryController,
                    autofocus: true,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () async{
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _processNewCategory(categoryController.text); // Llama a la función que maneja la nueva categoría
                  await GlobalData.loadData();
                  setState(() {
                    categoryProducts = categoryProducts;
                    productList = productList;
                  });
                },
              ),
            ],
          );
        });
  }

  void _processNewCategory(String categoryName) async {
    final categoryData = {
      'idCompany': globalIdCompany,
      'categoryProduct': globalMaxIdCategory +1,
      'nameCategory': categoryName};
    try {
        final response = await postNewCategoryProduct(categoryData);
        setState(() {
        });
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: buildDialogContent(context, '¡Categoría Añadida!','La categoría se ha registrado correctamente.'),
          ));
      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack Trace: $stackTrace');
      }
  }


  void _editCategory(int index, int categoryProduct, String originalNameCategory, int count) {
  //TextEditingController para capturar la nueva entrada del usuario
  TextEditingController editCategoryController = TextEditingController();
  // Establece el nombre actual de la categoría como valor inicial
  editCategoryController.text = categoryProducts[index].nameCategory;

  // Mostrar un diálogo para editar el nombre de la categoría
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar categoría'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Ingrese el nuevo nombre para la categoría:'),
                TextField(
                  controller: editCategoryController,
                  autofocus: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                // Cerrar el diálogo actual
                Navigator.of(context).pop();
                // Mostrar el siguiente diálogo para confirmación adicional
                if(count > 0){
                  _confirmCategoryUpdate(categoryProduct, editCategoryController.text, originalNameCategory);
                }else{
                  _updateCategoryName(categoryProduct, editCategoryController.text, false,originalNameCategory);
                }
              },
            ),
          ],
        );
      });
}

  void _confirmCategoryUpdate(int categoryProduct, String newCategoryName, String originalNameCategory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Actualización'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Deseas actualizar los productos asociados a esta categoría con el nuevo nombre?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Mantener'),
              onPressed: () {
                // Lógica para mantener los productos en la categoría anterior
                Navigator.of(context).pop();
                _updateCategoryName(categoryProduct, newCategoryName, false,originalNameCategory);
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () {
                // Lógica para actualizar los productos a la nueva categoría
                Navigator.of(context).pop();
                _updateCategoryName(categoryProduct, newCategoryName, true,originalNameCategory);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCategoryName(int categoryProduct, String newCategoryName, bool updateProducts, String originalNameCategory) async {
    final categoryData = {
      'idCompany': globalIdCompany,
      'categoryProduct': categoryProduct,
      'nameCategory': newCategoryName,
      'updateProducts': updateProducts,
      'originalNameCategory': originalNameCategory};

      final response = await putUpdateCategoryData(categoryData);

      buildDialogContent(context,"Categoría actualizada","Se ha actualizado el nombre de la categoría $originalNameCategory por $newCategoryName");
  }


  void _deleteCategory(int index, int categoryProduct, String nameCategory, int count) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar categoría'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Se eliminará la categoría de $nameCategory'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                // Mostrar el siguiente diálogo para confirmación adicional
                if(count > 0){
                  _confirmDeleteUpdate(categoryProduct, nameCategory);
                }else{
                  _deleteCategoryProduct(categoryProduct, nameCategory,false);
                }
              },
            ),
          ],
        );
      });
  }

    void _confirmDeleteUpdate(int categoryProduct, String nameCategory) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cuidado, tienes productos asociados a esta categoría'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Desea mantener o eliminar la relación con los productos asociados a esta categoría?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Mantener'),
              onPressed: () {
                // Lógica para mantener los productos en la categoría anterior
                Navigator.of(context).pop();
                _deleteCategoryProduct(categoryProduct, nameCategory, false);
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                // Lógica para actualizar los productos a la nueva categoría
                Navigator.of(context).pop();
                _deleteCategoryProduct(categoryProduct, nameCategory, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategoryProduct(int categoryProduct, String nameCategory, bool updateProducts) async {
    final categoryData = {
      'idCompany': globalIdCompany,
      'categoryProduct': categoryProduct,
      'updateProducts': updateProducts,};

      final response = await deleteCategoryData(categoryData);

      buildDialogContent(context,"Categoría Eliminada","Se ha eliminado la categoría $nameCategory del listado");

      await GlobalData.loadData();
      setState(() {
        categoryProducts = categoryProducts;
        productList = productList;
      });
  }


}
