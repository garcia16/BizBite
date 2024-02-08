import 'package:flutter/material.dart';

// MENSAJES POR PANTALLA
Widget buildDialogContent(BuildContext context, String header, String text) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: Theme.of(context).colorScheme.outline,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          header,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.surface),
        ),
        const SizedBox(height: 24),
        Text(
          text,
          style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.surface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: Text('Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

//APPBAR
PreferredSizeWidget appBarToBack(BuildContext context, String title){
  return AppBar(
    title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.tertiary),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

PreferredSizeWidget appBarIcon(BuildContext context, String title, IconData iconAppBar, Widget routePage){
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title: Text(
          title,
          style: TextStyle(
            fontSize: 29,
            color: Theme.of(context).colorScheme.tertiary,
            fontFamily: 'ChesNagroBlack', 
          ),
        ),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(iconAppBar, color: Theme.of(context).colorScheme.tertiary,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => routePage));
        },
      )
    ],
  );
}

PreferredSizeWidget appBarIconBack(BuildContext context, String title, IconData iconAppBar, Widget routePage){
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(iconAppBar, color: Theme.of(context).colorScheme.tertiary,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => routePage));
        },
      )
    ],
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.tertiary),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

PreferredSizeWidget appBarClassic(BuildContext context, String title){
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    title:  Text(
      'BizBite',
      style: TextStyle(
        fontSize: 29,
        color: Theme.of(context).colorScheme.tertiary,
        fontFamily: 'ChesNagroBlack', 
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.onTertiary,
    elevation: 0,
  );
}

//BOTONES

ButtonStyle buttonStyleOne(BuildContext context) {
  return ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.onBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  );
}