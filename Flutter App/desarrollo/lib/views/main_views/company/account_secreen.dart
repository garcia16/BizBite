import 'package:desarrollo/models/company.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/employee.dart';
import '../../auth/login_screen.dart';

class AccountView extends StatefulWidget {

  final List<Employee>? employeeList;
    AccountView({Key? key, required this.employeeList}) : super(key: key);
  @override
  State<AccountView> createState() => _AccountViewState();

}

class _AccountViewState extends State<AccountView> {
  String employeeName = "Cargando..."; 
  String employeeMail = "Cargando..."; 
  String? employeeImage='https://via.placeholder.com/150';


  @override
  void initState() {
    super.initState();
    _findEmployeeName();
  }

  void _findEmployeeName() {
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
    String? mailUser = FirebaseAuth.instance.currentUser?.email;

    final employee = widget.employeeList?.firstWhere(
      (emp) => emp.uidUser == userUID,
    );

    if (employee != null) {
      setState(() {
        employeeName = employee.name;
        employeeMail = mailUser!;
        employeeImage = employee.imagepath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Tu cuenta'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      employeeImage!), 
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName, 
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(employeeMail), 
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Empresas a las que perteneces", 
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text("Descargar mi archivo de datos"),
              onTap: () {
                // Lógica para descargar datos
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Cambiar idioma"),
              onTap: () {
                // Lógica para descargar datos
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Cambiar contraseña"),
              onTap: () {
                // Lógica para cambiar contraseña
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Cerrar sesión"),
              onTap: () {
                showLogoutDialog();         
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLogoutDialog() async {
    // mostrar el diálogo
    bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cerrar sesión'),
              content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // No proceder con el cierre de sesión
                  },
                ),
                TextButton(
                  child: const Text('Cerrar sesión'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Proceder con el cierre de sesión
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Si se toca fuera del diálogo, devuelve false

    // Si se confirmó el cierre de sesión
    if (confirm) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()), 
        (Route<dynamic> route) => false,
      );
    }
  }


Widget _buildCompanyCard(Company company) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Card(
        color: Theme.of(context).colorScheme.outline,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 160,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF3498DB),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}



