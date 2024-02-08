
import 'package:desarrollo/utils/comun_widgets.dart';
import 'package:desarrollo/views/main_views/warehouse/edit_product_screen.dart';
import 'package:flutter/material.dart';
import '../../../logic/data/global_data.dart';
import '../../../models/product.dart';
import '../../../utils/constants.dart';
import 'add_product_screen.dart';
import 'config_warehouse_screen.dart';
import 'update_stock_screen.dart';

class WarehouseView extends StatefulWidget {

  @override
  _WarehouseViewState createState() => _WarehouseViewState();
}
class _WarehouseViewState extends State<WarehouseView> {

  TextEditingController _searchController = TextEditingController();
  List<ProductData> _filteredProducts = [];
  bool _isAscending = true;
  String _selectedCategory = ''; 


  @override
  void initState() {
    super.initState();
    _filteredProducts = productList;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = productList.where((product) {
        return product.nameProduct.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  void _sortProducts() {
    setState(() {
      if (_isAscending) {
        _filteredProducts.sort((a, b) => b.nameProduct.compareTo(a.nameProduct));
      } else {
        _filteredProducts.sort((a, b) => a.nameProduct.compareTo(b.nameProduct));
      }
      _isAscending = !_isAscending;
    });
  }

  // Método para obtener las categorías únicas
  Set<String> _getUniqueCategories() {
  // Filtrar valores nulos y luego convertir a un conjunto para obtener categorías únicas
  return productList
      .map((product) => product.categoryProduct)
      .where((category) => category != null)
      .cast<String>() // Esto es seguro ya que los nulos han sido filtrados
      .toSet();
}


  // Método para mostrar el menú desplegable
  void _showCategoryMenu(BuildContext context) async {
    final Set<String> categories = _getUniqueCategories();
    await showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: categories.map((String category) {
            return ListTile(
              title: Text(category, style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
              onTap: () {
                Navigator.pop(context); // Cierra el menú desplegable
                _filterByCategory(category);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // Método para filtrar productos por categoría
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredProducts = productList.where((product) {
        return product.categoryProduct == category;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarIcon(context,'BizBite',Icons.settings,WarehouseSettingsView()),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildProductList(productList)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => UpdateStockScreen())
              ).then((_) async {
                await GlobalData.loadData();
                setState(() {
                  _filteredProducts = productList;
                });
              });
            },
            style: buttonStyleOne(context),
            child: Text("Actualizar Stock", style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer))
          ),
          const SizedBox(height: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => AddProductScreen())
              ).then((_) async {
                await GlobalData.loadData();
                setState(() {
                  _filteredProducts = productList;
                });
              });
            },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onTertiaryContainer,),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Buscar",
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary,),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary,),
                border: const UnderlineInputBorder(), 
                //filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.sort_by_alpha, color: Theme.of(context).colorScheme.surface),
            onPressed: () {
              _sortProducts();
            },
          ),
          IconButton(
            icon: Icon(Icons.category_outlined, color: Theme.of(context).colorScheme.surface),
            onPressed: () => _showCategoryMenu(context),
            tooltip: 'Filtrar por categoría',
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<ProductData> productList) {
    return ListView.builder(
      itemCount: _filteredProducts.length, 
      itemBuilder: (context, index) {
      var product = _filteredProducts[index]; // Obtiene el producto actual
      return Card(
        color: Theme.of(context).colorScheme.outline,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF3498DB),
            backgroundImage: NetworkImage(product.photoProduct ?? "https://placehold.co/600x400/png"), // Usa la imagen del producto
          ),
          title: Text(product.nameProduct, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSecondary)), // Usa el nombre del producto
          subtitle: Text("Stock: ${product.stockProduct}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)), // Usa el stock del producto
          children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Categoría: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text("${product.categoryProduct}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),

                          ],
                        ),
                        Row(
                          children: [
                            Text("Referencia: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text("${product.referenceProduct}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Distribuidor: ", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            Text("${product.distributorProduct}", style: TextStyle(color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => EditProductScreen(product: product))
                            ).then((_) async {
                              await GlobalData.loadData();
                              setState(() {
                                _filteredProducts = productList;
                              });
                            });
                          },
                          style: buttonStyleOne(context),
                          child: Text('Editar', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer))
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
        ),
      );
    },
  );
}

}
