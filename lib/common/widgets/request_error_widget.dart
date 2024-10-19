import 'package:flutter/material.dart';
import 'package:habar/common/http_request.dart';
import 'package:rxdart/subjects.dart';

class RequestErrorWidget extends StatelessWidget {
  final String requestUrl;
  final BehaviorSubject<String> errorStream;

  const RequestErrorWidget({
    super.key,
    required this.requestUrl,
    required this.errorStream,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Ошибка загрузки'),
          ElevatedButton(
            child: const Text('Попробовать еще раз'),
            onPressed: () async {
              errorStream.add('');
              await HttpRequest.get(requestUrl);
            },
          )
        ],
      ),
    );
  }
}
