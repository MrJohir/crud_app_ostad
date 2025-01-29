import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  static const String name = '/add-new-product';

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'name',
              labelText: 'Product Name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: _codeTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'code',
              labelText: 'Product Code',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Code';
              }
              return null;
            },
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: _imageTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'url',
              labelText: 'Image',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Image Url';
              }
              return null;
            },
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: _quantityTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'quantity',
              labelText: 'Quantity',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Quantity';
              }
              return null;
            },
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: _priceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'price',
              labelText: 'Price',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Price';
              }
              return null;
            },
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: _totalPriceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'total price',
              labelText: 'Total Price',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Total Price';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: _addNewProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addNewProduct();
                }
              },
              child: const Text('Add Product'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewProduct() async {
    _addNewProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');

    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim(),
    };
    Response response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    _addNewProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _clearTextFields();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New product Added!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New product Add failed! try again'),
        ),
      );
    }
  }

  void _clearTextFields() {
    _nameTEController.clear();
    _codeTEController.clear();
    _imageTEController.clear();
    _quantityTEController.clear();
    _priceTEController.clear();
    _totalPriceTEController.clear();
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _imageTEController.dispose();
    _quantityTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    super.dispose();
  }
}
