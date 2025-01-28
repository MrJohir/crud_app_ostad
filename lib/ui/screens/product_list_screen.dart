import 'dart:convert';

import 'package:crud_app_ostad/models/product.dart';
import 'package:crud_app_ostad/ui/screens/add_new_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductListInProgress = false;
  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
          actions: [
            IconButton(onPressed: () {
              _getProductList();
            }, icon: const Icon(Icons.refresh)),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _getProductList();
          },
          child: Visibility(
            visible: _getProductListInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return ProductItem(
                    product: productList[index],
                    onDeleteTab: (){
                      _deleteShowDialog(productList[index], index);
                    },
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddNewProductScreen.name);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'],
          image: p['Img'],
          unitPrice: p['UnitPrice'],
          quantity: p['Qty'],
          totalPrice: p['TotalPrice'],
          createdDate: p['CreatedDate'],
        );
        productList.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
    setState(() {});
  }

  void _deleteShowDialog(Product product,int index){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Delete!'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          ElevatedButton(onPressed: (){
            _deleteProductItem('${product.id}', index);
            Navigator.pop(context);
          }, child: const Text('Yes')),
          const SizedBox(width: 16,),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('No')),
        ],
      );
    },
    );
  }

  Future<void> _deleteProductItem(String id, int index) async {
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$id');
    Response response = await get(uri);
    _getProductListInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete Successful'),),);
      productList.removeAt(index);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete Failed'),),);
    }
    setState(() {});
  }
}
