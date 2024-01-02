import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

const String _baseURL = 'csci410itani.000webhostapp.com';

class Desktops {

String _name;
String _processor;
String _graphics;
String _ram;
String _storage;
int _price;
int _quantity;
String _image;

Desktops(this._name, this._processor, this._graphics, this._ram,
      this._storage, this._price, this._quantity, this._image);
@override
String toString() {
  return 'Name: $_name Name: $_name\nProcessor: $_processor \nGraphics: $_graphics \nRam: $_ram \nStorage: $_storage \nPrice: \$$_price \nIn Stock: $_quantity \nImage: $_image';
}
}

List<Desktops> _desktops = [];

void updateProducts(Function(bool success) update) async {
  try {
    final url = Uri.https(_baseURL, 'get.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _desktops.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(
          response.body); //
      for (var row in jsonResponse) {
        Desktops d = Desktops(
            row['name'],
            row['processor'],
            row['graphics'],
            row['ram'],
            row['storage'],
            int.parse(row['quantity']),
            int.parse(row['price']),
            row['image']);
        _desktops.add(d);
      }
      update(
          true);
    }
  }
  catch (e) {
    update(false);
  }
}

void searchProduct(Function(String text) update, int pid) async {
  try {
    final url = Uri.https(_baseURL, 'searchProduct.php', {'pid': '$pid'});
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _desktops.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      Desktops d = Desktops(
          row['name'],
          row['processor'],
          row['graphics'],
          row['ram'],
          row['storage'],
          int.parse(row['quantity']),
          int.parse(row['price']),
          row['image']);
      _desktops.add(d);
      update(d.toString());
    }
  }
  catch (e) {
    update("can't load data");
  }
}
class ShowProducts extends StatelessWidget {
  const ShowProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _desktops.length,
      itemBuilder: (context, index) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            _desktops[index].toString(),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}