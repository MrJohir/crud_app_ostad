import 'dart:convert';

import 'package:crud_app_ostad/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  static const String name = '/update-product';
  final Product product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();

    _nameTEController.text = widget.product.productName ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
    _imageTEController.text = widget.product.image ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
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
            visible: _updateProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProduct();
                }
              },
              child: const Text('Update Product'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');

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
    _updateProductInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product has been Update!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Update failed! try again'),
        ),
      );
    }
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
