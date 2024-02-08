import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../logic/data/global_data.dart';
import '../../../models/employee.dart';
import '../../../utils/constants.dart';
import 'config_screen.dart';

class CompanyProfileView extends StatefulWidget {

  @override
  State<CompanyProfileView> createState() => _CompanyProfileViewState();
}

class _CompanyProfileViewState extends State<CompanyProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
              'BizBite',
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
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.tertiary,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView())).then((_) async {
                await GlobalData.loadData();
                setState(() {
                  
                });
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(companyList[0].photoCompany ?? "https://placehold.co/600x400/png"), // Usa la imagen del producto
            ),
            const SizedBox(height: 20),
            Text(
              companyList[0].nameCompany,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Text('CIF: ${companyList[0].nifCompany}', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
            const SizedBox(height: 10),
            Text('Ubicación: ${companyList[0].countryCompany}', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
            const SizedBox(height: 10),
            Text('Categoría: ${companyList[0].categoryCompany}', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
            const SizedBox(height: 20),
            Text(
              'Empleados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: employeeList.length,
                itemBuilder: (context, index) {
                  return _buildEmployeeCard(employeeList[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Card(
        color: Theme.of(context).colorScheme.outline,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(employee.imagepath ?? "https://placehold.co/600x400/png"), // Usa la imagen del producto
                backgroundColor: const Color(0xFF3498DB),
              ),
              const SizedBox(height: 10),
              Text(employee.name, style: TextStyle(color: Theme.of(context).colorScheme.surface)),
              Text(employee.position, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface)),
            ],
          ),
        ),
      ),
    );
  }
}


