import 'dart:convert';
import "package:http/http.dart" as http;
import "package:arsketch/constants.dart";

class WebService {
  Future getSketches() async {
    http.Response response = await http.get(Uri.parse(kHost + "api/a/"));
    return jsonDecode(response.body);
  }
}
