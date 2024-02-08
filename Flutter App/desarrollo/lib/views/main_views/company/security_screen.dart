// ignore_for_file: use_build_context_synchronously

import 'package:desarrollo/logic/company/putEditRoleUser.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../utils/constants.dart';

class SecurityView extends StatefulWidget {

  @override
  _SecurityViewState createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Roles de usuario'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: employeeList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  color: Theme.of(context).colorScheme.outline,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(employeeList[index].imagepath ?? "https://placehold.co/600x400/png"), 
                      onBackgroundImageError: (exception, stackTrace) => Container(),
                      radius: 30,
                    ),
                    title: Text(employeeList[index].name),
                    subtitle: Text(employeeList[index].position),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
                          onPressed: () {
                            _showRoleChangeDialog(index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: Icon(Icons.add,color: Theme.of(context).colorScheme.onTertiaryContainer,), 
      ),
    );
  }

  _showRoleChangeDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cambiar rol de ${employeeList[index].name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildRoleOption("Administrador", index),
              _buildRoleOption("Delegado", index),
              _buildRoleOption("Empleado", index),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            )
          ],
        );
      },
    );
  }

  _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar usuario"),
          content: Text("¿Estás seguro que deseas eliminar a ${employeeList[index].name}?"),
          actions: [
            TextButton(
              onPressed: () async{
                await removeUserFromCompany(index, context);

              },
              child: const Text("Si", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeUserFromCompany(int index, BuildContext context) async {
    try {
      final userData= {
        "idCompany": globalIdCompany,
        "idUser": employeeList[index].idUser,
      };
    
      final response = await putUpdateRoleUser(userData);
    
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: buildDialogContent(context, '¡Usuario eliminado!', ' ${employeeList[index].name} ya no forma parte de ${companyList[0].nameCompany}.'),
      ));
    
      await GlobalData.loadData();
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
    
    setState(() {
      employeeList.removeAt(index);
    });
    
    Navigator.pop(context);
  }

  Widget _buildRoleOption(String role, int index) {
    return ListTile(
      title: Text(role),
      trailing: Radio<String>(
        value: role,
        groupValue: employeeList[index].position,
        onChanged: (String? newRole) async {
          // Primero maneja la lógica asíncrona
          await updateRoleUser(newRole, index, role);
        },
      )
    );
  }

  Future<void> updateRoleUser(String? newRole, int index, String role) async {
    try {
      final rolUserData = {
        "idCompany": globalIdCompany,
        "rolUser": newRole,
        "idUser": employeeList[index].idUser,
      };
    
      final response = await putUpdateRoleUser(rolUserData);
    
      await showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: buildDialogContent(context, '¡Rol modificado!', ' ${employeeList[index].name} ahora tiene el rol de $role.'),
      ));
    
      await GlobalData.loadData();
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
    
    setState(() {
      employeeList[index].position = role;
    });
    
    Navigator.pop(context);
  }


}
