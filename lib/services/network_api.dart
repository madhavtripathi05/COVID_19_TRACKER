import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkAPI {
  NetworkAPI(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));

    // return if only request is successful
    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
