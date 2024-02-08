
// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:country_picker/country_picker.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../../logic/company/updateDataCompany.dart';
import '../../../utils/constants.dart';

class EditCompanyView extends StatefulWidget {
  @override
  _EditCompanyViewState createState() => _EditCompanyViewState();
}

class _EditCompanyViewState extends State<EditCompanyView> {
  bool emailNotifications = false;
  bool salesNotifications = false;
  double stockThreshold = 50;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cifController = TextEditingController();
  String? _selectedCategory;
  final TextEditingController _selectedUbication = TextEditingController();

  File? _imageFile;
  final picker = ImagePicker();
  String? nameImage;
  String? _imageURL;

    @override
  void initState() {
    super.initState();
    _nameController.text = companyList[0].nameCompany;
    _selectedCategory = companyList[0].categoryCompany; 
    _selectedUbication.text = companyList[0].countryCompany;
    _cifController.text = companyList[0].nifCompany;
    _imageURL = companyList[0].photoCompany; 
  }


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: appBarToBack(context, companyList[0].nameCompany),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildImageCircle(),
          const SizedBox(height: 16.0),
          _buildTextField("Nombre", controller: _nameController),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration("Categoría"),
            items: categoriesCompany.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            value: _selectedCategory, 
          ),

          const SizedBox(height: 8.0),
          _buildTextField("CIF", keyboardType: TextInputType.number, controller: _cifController),
          const SizedBox(height: 8.0),
          _buildTextFieldCountry("País", keyboardType: TextInputType.number, controller: _selectedUbication),
          
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              _saveProduct();
            },
            style: buttonStyleOne(context),
            child: Text("Guardar", style: TextStyle(color: Theme.of(context).colorScheme.outline),)
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
        const Icon(Icons.camera_alt, color: Colors.white, size: 30), // Icono de la cámara
      ],
    ),
  );
}


Widget _buildTextField(String label, {TextInputType? keyboardType, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
    );
  }

Widget _buildTextFieldCountry(String label, {TextInputType? keyboardType, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      onTap: (){
        showCountryPicker(
          context: context,
          exclude: <String>['KN', 'MF'],
          favorite: <String>['ES'],
          onSelect: (Country country) {
            print('Pais seleccionado: ${country.name}');
            _selectedUbication.text = country.name;
          },
          countryListTheme: CountryListThemeData(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            inputDecoration: InputDecoration(
              labelText: 'Buscar',
              hintText: 'Introduce el pais a buscar',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFF8C98A8).withOpacity(0.2),
                ),
              ),
            ),
            searchTextStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  Widget settingSection({required String title, required Widget child, Widget? trailing}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: Theme.of(context).colorScheme.outline,
      elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row( 
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          if (child != const SizedBox()) ...[ // Para evitar un espacio adicional cuando no hay 'child'
            const SizedBox(height: 15),
            child,
          ],
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
         _imageURL = null;
       });
     } else {
       print('No image selected.');
     }
   } catch (e) {
     print(e); 
   }
 }

 InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      fillColor: Theme.of(context).colorScheme.outline,
    );
  }

  void _saveProduct() async{

   // Comprobando si el nombre o el stock están vacíos
    if (_nameController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("El nombre de la empresa no puede quedar vacío"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    String? imageURL = companyList[0].photoCompany; // URL de imagen predeterminada (la actual)

    // Solo actualiza la imagen si se ha seleccionado una nueva
    if (_imageFile != null) {
       imageURL = await compressAndUploadImage();
    }

    //Objeto a mandar al API para actualizar
      final productData = {
        "idCompany": globalIdCompany,
        "nameCompany": _nameController.text,
        "categoryCompany": _selectedCategory,
        "nifCompany": _cifController.text,
        "countryCompany": _selectedUbication.text,
        "photoCompany": imageURL,
      };
  
    //Llamada al API para actualizar el producto
    try {
        final response = await updateCompanyData(productData);
        // Mostrar diálogo de éxito o manejar la respuesta como sea necesario
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: buildDialogContent(context, '¡Datos actualizados!','La información de la empresa se ha guardado correctamente'),
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
}
