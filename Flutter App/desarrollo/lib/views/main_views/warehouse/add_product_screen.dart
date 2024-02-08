// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:desarrollo/models/category.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../../logic/warehouse/postNewProduct.dart';
import '../../../models/product.dart';
import '../../../utils/constants.dart';

class AddProductScreen extends StatefulWidget {

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _initialStockController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _distributorController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCategory;

  File? _imageFile;
  final picker = ImagePicker();
  String? nameImage;

  @override
  void dispose() {
    _nameController.dispose();
    _initialStockController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _distributorController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Nuevo producto',), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (_imageFile != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red,size: 40,),
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                      ],
                    ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 40, color: Theme.of(context).colorScheme.outline),
                    onPressed: () {
                      chooseImageProduct(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildTextField("Nombre", controller: _nameController),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Categoría"),
              value: _selectedCategory,
              items: categoryProducts.map((CategoryProduct categoryProduct) {
                return DropdownMenuItem<String>(
                  value: categoryProduct.nameCategory,
                  child: Text(categoryProduct.nameCategory),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  // Lógica al cambiar de categoría, si es necesario
                });
              },
            ),
            const SizedBox(height: 8.0),
            _buildTextField("Stock Inicial", keyboardType: TextInputType.number, controller: _initialStockController),
            const SizedBox(height: 8.0),
            _buildTextField("Precio de compra", keyboardType: TextInputType.number,  controller: _purchasePriceController),
            const SizedBox(height: 8.0),
            _buildTextField("Precio de Venta", keyboardType: TextInputType.number, controller: _salePriceController),
            const SizedBox(height: 8.0),
            _buildTextField("Distribuidor",  controller: _distributorController),
            const SizedBox(height: 8.0),
            _buildTextField("Referencia",  controller: _referenceController),
            const SizedBox(height: 8.0),
            TextField(
              controller: _notesController,
              decoration: _inputDecoration("Notas"),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveProduct();
              },
              style: buttonStyleOne(context),
              child: Text("Guardar Producto", style: TextStyle(color: Theme.of(context).colorScheme.outline),)
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> chooseImageProduct(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona una imagen'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Cámara'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
   try {
     final pickedFile = await picker.pickImage(source: source);
 
     if (pickedFile != null) {
       setState(() {
         _imageFile = File(pickedFile.path);
         nameImage = pickedFile.name;  
       });
     } else {
       print('No image selected.');
     }
   } catch (e) {
     print(e); 
   }
 }


  void _saveProduct() async{

    if (_nameController.text.isNotEmpty && _initialStockController.text.isNotEmpty) {

      ProductData? existingProduct;

    // Búsqueda manual para comprobar si la referencia ya existe
    for (ProductData product in productList) {
      if (product.referenceProduct == _referenceController.text) {
        existingProduct = product;
        break;  // Salir del bucle una vez que encuentres un producto que coincida
      }
    }
    //En caso de que ya exista esa referencia mostrará un mensaje
    if (existingProduct != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("La referencia ya pertenece al producto ${existingProduct.nameProduct}"),
        backgroundColor: Colors.red,
      ));
      return;
    }

      final imageURL = await compressAndUploadImage();

      final productData = {
        "idCompany": globalIdCompany,
        "idProduct": globalMaxIdProduct +1,
        "nameProduct": _nameController.text,
        "categoryProduct": _selectedCategory,
        "stockProduct": _initialStockController.text,
        "priceProduct": _purchasePriceController.text,
        "salePriceProduct": _salePriceController.text,
        "distributorProduct": _distributorController.text,
        "referenceProduct": _referenceController.text,
        "notesProduct": _notesController.text,
        "photoProduct": imageURL,
      };

      try {
        final response = await postNewProduct(productData);
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: buildDialogContent(context, '¡Producto guardado!','El producto se ha registrado correctamente.'),
        ));
        Navigator.pop(context);
      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack Trace: $stackTrace');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, completa los campos obligatorios para registrar el producto.',style: TextStyle(color: Theme.of(context).colorScheme.outline),),
        backgroundColor: Theme.of(context).colorScheme.surface,
        duration: const Duration(seconds: 2),
      ),
    );
    }
  }

  Future<String> compressAndUploadImage() async {
    String imageUrl = '';
    try {
      // Comprobando si la imagen ha sido seleccionada
      if (_imageFile == null) {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/bizbitedesa-ab493.appspot.com/o/default-image.jpg?alt=media&token=f9d756fd-168c-4d41-b9a3-4cefa36d3f8f';
      }else{

        final path = _imageFile!.path;
        String? fileName = nameImage;
        final storageRef = FirebaseStorage.instance.ref().child(globalIdCompany.toString()).child(fileName!);

        // Comprimir la imagen antes de subirla
        Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
          path,
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

      }
    
    return imageUrl;
  }


  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Theme.of(context).colorScheme.outline,
    );
  }

  Widget _buildTextField(String label, {TextInputType? keyboardType, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
    );
  }

}
