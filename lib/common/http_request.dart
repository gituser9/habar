import 'package:habar/common/costants.dart';
import 'package:http/http.dart';

class HttpRequest {
  static final _client = Client();

  static Future<String> get(String url, {Map<String, String>? params, int version = 2}) async {
    if (params == null) {
      params = {};
    }

    params['fl'] = 'ru';
    params['hl'] = 'ru';

    final uri = Uri.https(Constant.baseUrl, '/kek/v$version' + url, params);
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      print(uri);
      print('get body error');
      return '';
    }
    if (response.body.isEmpty) {
      print('body is empty');
      return '';
    }

    return response.body;
  }

  static close() {
    _client.close();
  }
}
