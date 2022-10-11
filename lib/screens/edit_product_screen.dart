import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/components/AppBar.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgSrcFocusNode = FocusNode();
  final _imgScrController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _initValue = {'name': '', 'desc': '', 'price': '', 'imgScr': ''};
  var _isInit = true;
  var _isLoading = false;
  var _editedProduct =
      Product(id: '', name: '', price: 0, imgSrc: '', desc: '');
  void _updateImgScr() {
    if (!_imgSrcFocusNode.hasFocus) {
      if (_imgScrController.text.isEmpty ||
          (!_imgScrController.text.startsWith('http') &&
              !_imgScrController.text.startsWith('https')) ||
          (!_imgScrController.text.endsWith('.png') &&
              !_imgScrController.text.endsWith('.jpg') &&
              !_imgScrController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('An error occurred!'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'))
              ],
            );
          },
        );
      }
      //  finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imgSrcFocusNode.addListener(_updateImgScr);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        final productData =
            Provider.of<Products>(context, listen: false).findById(productId);
        _editedProduct = productData;
        _initValue = {
          'name': _editedProduct.name,
          'desc': _editedProduct.desc,
          'price': _editedProduct.price.toString(),
          'imgScr': ''
        };
        _imgScrController.text = _editedProduct.imgSrc;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgSrcFocusNode.removeListener(_updateImgScr);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgSrcFocusNode.dispose();
    _imgScrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
          appBar: AppBar(),
          title: Text('Edit product'),
          widgets: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValue['name'],
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a value!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              name: value as dynamic,
                              price: _editedProduct.price,
                              imgSrc: _editedProduct.imgSrc,
                              desc: _editedProduct.desc,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_descFocusNode),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              name: _editedProduct.name,
                              price: double.parse(value.toString()),
                              imgSrc: _editedProduct.imgSrc,
                              desc: _editedProduct.desc,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                          initialValue: _initValue['desc'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descFocusNode,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_imgSrcFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a value!';
                            }
                            if (value.length < 10) {
                              return 'Should be at least 10 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                name: _editedProduct.name,
                                price: _editedProduct.price,
                                imgSrc: _editedProduct.imgSrc,
                                desc: value as dynamic,
                                isFavorite: _editedProduct.isFavorite);
                          }),
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
                            child: _imgScrController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imgScrController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                initialValue: _initValue['imgSrc'],
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imgScrController,
                                focusNode: _imgSrcFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a value!';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Please enter a valid URL.';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid URL';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      name: _editedProduct.name,
                                      price: _editedProduct.price,
                                      imgSrc: value as dynamic,
                                      desc: _editedProduct.desc,
                                      isFavorite: _editedProduct.isFavorite);
                                }),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
