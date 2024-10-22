import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyModel with ChangeNotifier {

  late List<String> labels;
  late List<String> links;
    Future<void> initialize() async{
    await _loadLabels();
    await _loadLinks();
  }

  Future<void> _loadLabels() async {
    final data = await rootBundle.loadString('my_model/labels.txt');
    labels = data.split('\n');
    labels.removeLast();
  }

  Future<void> _loadLinks() async {
    final data = await rootBundle.loadString('my_model/flowers_links.txt');
    links = data.split('\n');
    links.removeLast();
  }

  Future<List<String>> classifyImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.56.1:5000/classify')
      );

      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path)
      );

      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseString);
        String predictedClass = labels[jsonResponse['predicted_class']];
        String linkHelper= links[jsonResponse['predicted_class']];
        String link = 'https://en.wikipedia.org/wiki/$linkHelper'  ;

        return ['$predictedClass',link];
      } else {
        return ['Error: ${response.statusCode}, ${responseString}',""];
      }
    } catch (e) {
      return ['Error: $e',""];
    }
  }
}


