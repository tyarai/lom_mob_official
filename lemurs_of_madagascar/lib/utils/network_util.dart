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

      if(res != null && res.length != 0) {

        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw new LOMException(statusCode);
        }
        return _decoder.convert(res);

      }

      return null;

    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {

    print("network util posting....$url ..$headers.. $body ... $encoding");
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {

       print("[NETWORK_UTIL::post()]" + response.body);

       final String res = response.body;

       if(res != null && res.length != 0) {

         final int statusCode = response.statusCode;
         dynamic decodedData = _decoder.convert(res);

         if (statusCode < 200 || statusCode > 400 || json == null) {
           print("NETWORK STATUS CODE :" + statusCode.toString());
           //throw new Exception(statusCode);
           throw new LOMException(statusCode);
         }

         return decodedData;
       }

       return null;

    }).catchError((Object error){

        //@TODO Handle SocketException when the user does not have to internet.
      print("[NETWORK_UTIL::post()] error " + error.toString());
      throw error;

    });
  }

  Future<dynamic> put(String url, {Map headers, body, encoding}) {

    print("network util putting...$url ..$body.. $headers.. $encoding");

    return http
        .put(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {

      print("[NETWORK_UTIL::put()]" + response.body);

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
      print("[NETWORK_UTIL::put()] error" + error.toString());
      throw error;

    });
  }

  Future<dynamic> delete(String url, {Map headers}) {
    print("network util deleting...$url");
    return http
        .delete(url, headers: headers)
        .then((http.Response response) {

      print("[NETWORK_UTIL::delete()]" + response.body);

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
      print("[NETWORK_UTIL::delete()] Exception " + error.toString());
      throw error;

    });
  }

}