
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool emailNotifications = false;
  bool salesNotifications = false;
  double stockThreshold = 50;
  TextEditingController salesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarToBack(context,'Notificaciones'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            settingSection(
              title: "Notificaciones vía e-mail",
              child: const SizedBox(), 
              trailing: Switch(
                value: emailNotifications,
                onChanged: (value) {
                  setState(() {
                    emailNotifications = value;
                  });
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            settingSection(
              title: "Notificaciones de ventas",
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: salesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Cantidad de dinero diaria",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: salesNotifications,
                    onChanged: (value) {
                      setState(() {
                        salesNotifications = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
            settingSection(
              title: "Notificaciones de Stock",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: stockThreshold,
                    onChanged: (value) {
                      setState(() {
                        stockThreshold = value;
                      });
                    },
                    min: 1,
                    max: 100,
                    divisions: 99,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    label: stockThreshold.round().toString(),
                  ),
                  Text(
                    "Notificar cuando el stock de un producto sea menor a ${stockThreshold.round()} unidades",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
