import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  Future call(String url) async {
    // String url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list";
    print("CALLING...");
    var data = [];

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200)
        data = JsonCodec().decode(response.body)["drinks"];
      else
        return [];
      return data;
    } catch (e) {
      print("====== ERROR ======\n $e");
      return [];
    }
  }
}
