import 'package:desarrollo/share_preferences/preferences.dart';
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';

class StockAlertsSettingsPage extends StatefulWidget {
  @override
  _StockAlertsSettingsPageState createState() => _StockAlertsSettingsPageState();
}

class _StockAlertsSettingsPageState extends State<StockAlertsSettingsPage> {
  bool _notificationsEnabled = Preferences.notificationsEnabled;
  double _stockThreshold = Preferences.stockThreshold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Configurar alertas de Stock'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: const Text('Activar alertas de stock bajo'),
              value: _notificationsEnabled,
              onChanged: (bool newValue) {
                setState(() {
                  _notificationsEnabled = newValue;
                });
              },
              secondary: const Icon(Icons.notifications_active),
              activeColor: Theme.of(context).colorScheme.secondary, 
              inactiveThumbColor: Colors.red, 
              inactiveTrackColor: Colors.red.withOpacity(0.5), 
            ),
            const SizedBox(height: 20),
            const Text('Umbral de stock bajo en productos:'),
            Slider(
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: Theme.of(context).colorScheme.secondary,
              label: _stockThreshold.round().toString(),
              value: _stockThreshold,
              onChanged: (double newValue) {
                setState(() {
                  _stockThreshold = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
              },
              style: buttonStyleOne(context),
              child: Text("Guardar configuraciones", style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer))
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    Preferences.notificationsEnabled = _notificationsEnabled;
    Preferences.stockThreshold = _stockThreshold;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: buildDialogContent(context, '¡Configuración actualizada!','Las alertas de stock se han configurado correctamente'),
      ),
    );
  }
}
