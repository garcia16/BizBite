import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../utils/constants.dart';
import 'account_secreen.dart';
import 'edit_company_screen.dart';
import 'notifications_screen.dart';
import 'premium_screen.dart';
import 'security_screen.dart';
import 'theme_screen.dart';

class SettingsView extends StatefulWidget {

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Configuración'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingsItem(
              context: context,
              icon: Icons.business_rounded,
              title: "Empresa",
              description: "Actualiza la información de tu empresa.",
              screen: EditCompanyView(),
              isEnabled: globalAdminPermission, // Aquí pasas la variable global
            ),
            _buildSettingsItem(
              context: context,
              icon: Icons.notifications,
              title: "Notificaciones",
              description:
                  "Selecciona los tipos de notificaciones que quieres recibir sobre tus ventas, stock y empleados.",
              screen: NotificationsView(),
            ),
            _buildSettingsItem(
              context: context,
              icon: Icons.star,
              title: "Premium",
              description:
                  "Descubre qué se incluye en Premium y administra tu configuración.",
              screen: PremiumView(),
            ),
            _buildSettingsItem(
              context: context,
              icon: Icons.lock,
              title: "Seguridad y roles de usuarios",
              description:
                  "Administra la seguridad de tu cuenta y lleva un control de su uso.",
              screen: SecurityView(),
            ),
            _buildSettingsItem(
              context: context,
              icon: Icons.palette,
              title: "Tema",
              description:
                  "Selecciona entre tema claro u oscuro según se adapte mas a tu gusto.",
              screen: ThemeView(),
            ),
            _buildSettingsItem(
              context: context,
              icon: Icons.account_circle,
              title: "Tu cuenta",
              description:
                  "Consulta la información de tu cuenta, descarga un archivo con tus datos u obtén más información acerca de las opciones de desactivación de la cuenta.",
              screen: AccountView(employeeList: employeeList),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Widget screen,
    bool isEnabled = true, // Parámetro adicional para controlar si el ítem está habilitado
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      color: Theme.of(context).colorScheme.outline,
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Icon(icon, color: isEnabled ? Theme.of(context).colorScheme.secondary : Colors.grey, size: 28), // Icono gris si no está habilitado
        title: Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: isEnabled ? null : Colors.grey)), // Texto gris si no está habilitado
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description, style: TextStyle(fontSize: 14, color: isEnabled ? null : Colors.grey)), // Descripción gris si no está habilitado
        ),
        onTap: isEnabled ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)).then((_) async {
                await GlobalData.loadData();
                setState(() {
                  
                });
              }) : null, // Desactiva el onTap si no está habilitado
      ),
    );
  }
}
