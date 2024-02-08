import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:desarrollo/views/main_views/warehouse/edit_categories_screen.dart';
import 'package:flutter/material.dart';
import 'alerts_stock.dart';

class WarehouseSettingsView extends StatefulWidget {

  @override
  State<WarehouseSettingsView> createState() => _WarehouseSettingsViewState();
}

class _WarehouseSettingsViewState extends State<WarehouseSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Configuración de almacén'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildSettingsItem(
                icon: Icons.notifications_active,
                title: "Configurar alertas de Stock",
                description:
                    "Establece alertas para ser notificado cuando el stock de un producto esté bajo.",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockAlertsSettingsPage()));
                },
              ),
              _buildSettingsItem(
                icon: Icons.category,
                title: "Editar categorías",
                description: "Administra las categorías de productos en el almacén.",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategoriesPage()));
                },
              ),
              _buildSettingsItem(
                icon: Icons.download,
                title: "Exportar inventario a Excel/PDF",
                description: "Exporta tu inventario actual a un archivo Excel o PDF.",
                onTap: () {
                  // Action for this item
                },
              ),
              _buildSettingsItem(
                icon: Icons.upload_file,
                title: "Importar Inventario desde Excel",
                description: "Importa productos y su información desde un archivo Excel.",
                onTap: () {
                  // Action for this item
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String description,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
