import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-products";
  @override
  EditProductScreenState createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  var _editedProduct = Product(
      id: null, title: null, subtitle: null, price: null, imageURL: null);

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  var isInit = true;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(prodId);

        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.subtitle,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageURL;
      }
    }

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    var value = _imageUrlController.text;
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!value.startsWith('http') && !value.startsWith("https") ||
          (!value.endsWith('jpg') &&
              !value.endsWith("jpeg") &&
              !value.endsWith("png")))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (_isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
    } else
      return;
    try {
      if (_editedProduct.id == null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      }
    } catch (error) {
      print(error);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong. Please try later!'),
          actions: [
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title*'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              subtitle: _editedProduct.subtitle,
                              price: _editedProduct.price,
                              imageURL: _editedProduct.imageURL,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          String text = null;
                          if (value.isEmpty) text = "Please provide a value.";
                          return text;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price*'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              subtitle: _editedProduct.subtitle,
                              price: double.parse(value),
                              imageURL: _editedProduct.imageURL,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value.isEmpty) return "Please provide a value.";
                          if (double.tryParse(value) == null)
                            return "Please enter a valid number";
                          if (double.parse(value) <= 0)
                            return "Please enter a number greater than zero";
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description*'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              subtitle: value,
                              price: _editedProduct.price,
                              imageURL: _editedProduct.imageURL,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          String text = null;
                          if (value.isEmpty) return "Please provide a value.";
                          if (value.length < 10)
                            return "Should be atleast 10 chars long";
                          return text;
                        },
                        // textInputAction: TextInputAction.next,
                        // onFieldSubmitted: (value) {
                        //   FocusScope.of(context).requestFocus(_priceFocusNode);
                        // },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    "Enter a URL",
                                    textAlign: TextAlign.center,
                                  )
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL*'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    subtitle: _editedProduct.subtitle,
                                    price: _editedProduct.price,
                                    imageURL: value,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Please provide a value.";
                                if (!value.startsWith('http') &&
                                    !value.startsWith("https"))
                                  return "Please enter a valid url";
                                if (!value.endsWith('jpg') &&
                                    !value.endsWith("jpeg") &&
                                    !value.endsWith("png"))
                                  return "Please enter a valid url";
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
