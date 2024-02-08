// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:desarrollo/models/product.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../../logic/warehouse/putEditProduct.dart';
import '../../../utils/constants.dart';

class EditProductScreen extends StatefulWidget {
  final ProductData product;

  EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  String? _imageURL;


  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.nameProduct;
    _initialStockController.text = widget.product.stockProduct.toString(); 
    _purchasePriceController.text = widget.product.priceProduct.toString(); 
    _salePriceController.text = widget.product.salePriceProduct.toString(); 
    _distributorController.text = widget.product.distributorProduct ?? ""; 
    _referenceController.text = widget.product.referenceProduct ?? ""; 
    _notesController.text = widget.product.notesProduct ?? ""; 
    _selectedCategory = widget.product.categoryProduct.toString(); 
    _imageURL = widget.product.photoProduct.toString(); 
  }


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
    appBar: appBarToBack(context, widget.product.nameProduct),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildImageCircle(),
          SizedBox(height: 16.0),
          _buildTextField("Nombre", controller: _nameController),
          SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration("Categoría"),
            items: ["Categoría 1", "Categoría 2"].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              _selectedCategory = value;
            },
          ),
          SizedBox(height: 8.0),
          _buildTextField("Stock", keyboardType: TextInputType.number, controller: _initialStockController),
          SizedBox(height: 8.0),
          _buildTextField("Precio de compra", keyboardType: TextInputType.number, controller: _purchasePriceController),
          SizedBox(height: 8.0),
          _buildTextField("Precio de Venta", keyboardType: TextInputType.number, controller: _salePriceController),
          SizedBox(height: 8.0),
          _buildTextField("Distribuidor", controller: _distributorController),
          SizedBox(height: 8.0),
          _buildTextField("Referencia", controller: _referenceController),
          SizedBox(height: 8.0),
          TextField(
            controller: _notesController,
            decoration: _inputDecoration("Notas"),
            maxLines: 3,
          ),
          SizedBox(height: 16.0),
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

Widget _buildImageCircle() {
  return InkWell(
    onTap: () {
      chooseImageProduct(context); // Esto abrirá el diálogo para elegir una nueva imagen
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
          child: _imageFile != null
          ? Image.file(_imageFile!, width: 120, height: 120, fit: BoxFit.cover)
          : (_imageURL != null
              ? Image.network(_imageURL!, width: 120, height: 120, fit: BoxFit.cover)
              : Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[500]),
                )),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5), // Opacidad para oscurecer la imagen
          ),
        ),
        Icon(Icons.camera_alt, color: Colors.white, size: 30), 
      ],
    ),
  );
}

  Future<dynamic> chooseImageProduct(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecciona una imagen'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Cámara'),
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
         _imageURL = null;
       });
     } else {
       print('No image selected.');
     }
   } catch (e) {
     print(e); 
   }
 }


  void _saveProduct() async{

   // Comprobando si el nombre o el stock están vacíos
    if (_nameController.text.isEmpty || _initialStockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("El nombre y/o el stock no pueden estar vacíos"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String newReference = _referenceController.text;
    ProductData? existingProduct;

    // Búsqueda manual para comprobar si la referencia ya existe
    for (ProductData product in productList) {
      if (product.referenceProduct == newReference && product.idProduct != widget.product.idProduct) {
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

    String? imageURL = widget.product.photoProduct; // URL de imagen predeterminada (la actual)

    // Solo actualiza la imagen si se ha seleccionado una nueva
    if (_imageFile != null) {
       imageURL = await compressAndUploadImage();
    }

    //Objeto a mandar al API para actualizar
      final productData = {
        "idCompany": globalIdCompany,
        "idProduct": widget.product.idProduct,
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
  
    //Llamada al API para actualizar el producto
    try {
        final response = await putUpdateProductData(productData);
        // Mostrar diálogo de éxito o manejar la respuesta como sea necesario
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: buildDialogContent(context, '¡Producto guardado!','El producto se ha guardado correctamente.'),
          ));
          Navigator.pop(context);
      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack Trace: $stackTrace');
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
