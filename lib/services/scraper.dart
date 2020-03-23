import 'dart:convert';

import 'package:http/http.dart';
import 'package:html/parser.dart';

class Scraper {
  Future initiate() async {
    // Make get Request to Website
    var client = Client();
    Response response = await client.get('https://www.mohfw.gov.in/');
    // print(response.body);

    // Use html parser
    var document = parse(response.body);
    List<String> data = [];
    String element = '';

    var table = document.querySelectorAll('tbody');

    //as there are two tables on the website
    var rows = table.elementAt(table.length-1).querySelectorAll('tr');

    for (var row in rows) {
      var cols = row.querySelectorAll('td');
      //adding elements to List
      for (var col in cols) {
        element = col.text;
        element = element.replaceAll('\n', '');
        element = element.replaceAll('\t', '');
        data.add(element);
      }
    }

    // print(data.toString() + ' ended List');

    List<Map<String, dynamic>> dataMap = [];

    for (var i = 0; i < (data.length - 6);) {
      //don't change order you over-smart
      dataMap.add({
        'index': data[i++],
        'stateName': data[i++],
        'confirmedCases': data[i++],
        'confirmedCasesNRI': data[i++],
        'recovered': data[i++],
        'deaths': data[i++],
      });
    }
    print(dataMap.toString());
    var jsonEncode = json.encode(dataMap);
    return jsonDecode(jsonEncode);
  }
}

// for testing
void main() async {
  await Scraper().initiate();
}
