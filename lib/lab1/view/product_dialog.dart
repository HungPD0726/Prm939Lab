import 'package:flutter/material.dart';

import '../entity/product.dart';
import '../utils/validator.dart';

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      Product(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        image: _imageController.text.trim(),
        price: Validator.parsePrice(_priceController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Them san pham'),
      content: SizedBox(
        width: 320,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
                validator: Validator.requiredField,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ten san pham'),
                validator: Validator.requiredField,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Ten anh'),
                validator: Validator.requiredField,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Gia'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: Validator.positivePrice,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huy'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Them')),
      ],
    );
  }
}
