import 'package:crud_app_ostad/models/product.dart';
import 'package:crud_app_ostad/ui/screens/update_product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(product.image ?? '',width: 20,),
      title:  Text(product.productName ?? ''),
      subtitle:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode ?? ''}'),
          Text('Price: ${product.unitPrice ?? ''}'),
          Text('Quantity: ${product.quantity ?? ''}'),
          Text('Total Price: ${product.totalPrice ?? ''}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, UpdateProductScreen.name,arguments: product);
              },
              icon: const Icon(Icons.edit)),
          const SizedBox(
            width: 8,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
