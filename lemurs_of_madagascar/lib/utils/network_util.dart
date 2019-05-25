import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lemurs_of_madagascar/utils/error_handler.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    print("network util posting....$url .. $body ... $encoding");
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {

       print("[NETWORK_UTIL::post()]" + response.body);

      final String res = response.body;
      final int statusCode = response.statusCode;
      dynamic decodedData = _decoder.convert(res);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        print("NETWORK STATUS CODE :"+statusCode.toString());
        //throw new Exception(statusCode);
        throw new LOMException(statusCode);
      }

      return decodedData;

    }).catchError((Object error){

        //@TODO Handle SocketException when the user does not have to internet.
      print("[NETWORK_UTIL::post()] error" + error.toString());
      throw error;

    });
  }
}