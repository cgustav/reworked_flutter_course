import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/product.dart';
import 'package:reworked_flutter_course/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/product-edit';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();

  final TextEditingController _imageUrlController = TextEditingController();

  //Used as a container of a Product object
  //to negotiate product data with providers
  Product _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      isFavorite: false);

  bool _isLoading = false;

  @override
  void initState() {
    //We add a listener to get an specific behavior
    //every time the user change the focus state of
    //the imageUrl text field.
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  //Prevent the persistent execution of the logic
  //that search coincidences from a given
  //productId argument (inside didChangeDependencies).
  bool _isInit = true;

  //only used to set formTextFields initial
  //value
  Map _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  //The advantage of using didChangeDependencies
  //is this method is executed before initState
  //and is invoked every time the widget change
  //it state.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      print('RECEIVED PRODUCT ID: $productId');

      if (productId != null) {
        print('Editing product...');
        final Product result =
            Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': result.title,
          'description': result.description,
          'price': result.price.toString(),
          'imageUrl': ''
        };
        //importing existing product id and if its
        //tagged as favorite or not
        _editedProduct.id = productId;
        _editedProduct.isFavorite = result.isFavorite;

        print('PRINTEEED: $_editedProduct.id');

        //setting initial value to imageUrl textField
        _imageUrlController.text = result.imageUrl;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void setLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  //This a trick to force the image preview
  //on the image url input when the text field
  //loose its focus.
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  //
  void _saveForm() async {
    final bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    setLoading(true);

/*
    So this is the logic to differenciate between {editing}
    and {creating} states.

    - Editing State:
      We are able to use the updateProduct Moehod from Products
      Provider.

    - Creating State:
       We are able to use the addProduct from the Products
       Provider.

       if the id of the product container is null so it could be
       because the didChangeDependencies logic didn't get any
       match with an existing product or simply the user decided
       to create a new product.

*/
    _formKey.currentState.save();

    if (_editedProduct.id != null)
      await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct);
    else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong. Try it later.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
        // } finally {
        //   setLoading(false);
        //   Navigator.of(context).pop();
        // }
      }
    }
    setLoading(false);
    Navigator.of(context).pop();
  }

  /* NOTE 1: ListView or Column

  For very long forms (i.e. many input fields) OR in landscape mode 
  (i.e. less vertical space on the screen), you might encounter a 
  strange behavior: User input might get lost if an input fields 
  scrolls out of view.

  That happens because the ListView widget dynamically removes and
  re-adds widgets as they scroll out of and back into view.

  For short lists/ portrait-only apps, where only minimal scrolling 
  might be needed, a ListView should be fine, since items won't 
  scroll that far out of view (ListView has a certain threshold 
  until which it will keep items in memory).

  But for longer lists or apps that should work in landscape mode 
  as well - or maybe just to be safe - you might want to use a 
  Column (combined with SingleChildScrollView) instead. Since 
  SingleChildScrollView doesn't clear widgets that scroll out of
  view, you are not in danger of losing user input in that case.
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      //Form is kinda invisible widget, it dont
      //display a thing on the screen, but allows
      //us to use some "special" Elements and
      //prooperties to manage the way we collect,
      //display and validate the incoming data from
      //the user
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        //This tells to flutter when this textfield
                        //is submitted we actually want to focus the
                        //element with [_priceFocusNode]
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (String text) {
                        if (text.isEmpty) return 'Plase provide a value.';
                        return null;
                      },
                      onSaved: (String text) {
                        _editedProduct.title = text;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (String text) {
                        if (text.isEmpty) return 'Plase enter a price.';
                        if (double.tryParse(text) == null)
                          return 'Plase enter a valid number.';
                        if (double.parse(text) <= 0)
                          return 'please enter a number greater than 0.';
                        return null;
                      },
                      onSaved: (String text) {
                        _editedProduct.price = double.parse(text);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      onSaved: (String text) {
                        _editedProduct.description = text;
                      },
                      validator: (String text) {
                        if (text.isEmpty) return 'Plase enter a description.';
                        if (text.length < 10)
                          return 'Should be ar least 10 characters long.';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: (_imageUrlController.text.isEmpty)
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (String text) {
                              if (text.isEmpty)
                                return 'Please enter an image URL.';
                              if (!text.startsWith('http') ||
                                  !text.startsWith('https'))
                                return 'Please enter a valid URL.';
                              if (!text.endsWith('.png') &&
                                  !text.endsWith('.jpg') &&
                                  !text.endsWith('.jepg') &&
                                  !text.endsWith('.gif'))
                                return 'Please enter a valid image URL.';
                              return null;
                            },
                            onSaved: (String text) {
                              _editedProduct.imageUrl = text;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

/* Extra Note

REGULAR EXPRESSION EXAMPLE
(for url structure and validation only)

var urlPattern = r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
var result = new RegExp(urlPattern, caseSensitive: false).firstMatch('https://www.google.com');


*/
