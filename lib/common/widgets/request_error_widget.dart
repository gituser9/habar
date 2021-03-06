import 'package:flutter/material.dart';
import 'package:habar/common/http_request.dart';
import 'package:rxdart/subjects.dart';

class RequestErrorWidget extends StatelessWidget {
  final String requestUrl;
  final BehaviorSubject<String> errorStream;

  const RequestErrorWidget({
    Key? key,
    required this.requestUrl,
    required this.errorStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('Ошибка загрузки'),
            ElevatedButton(
              child: Text('Попробовать еще раз'),
              onPressed: () async {
                errorStream.add('');
                await HttpRequest.get(requestUrl);
              },
            )
          ],
        ),
      ),
    );
  }
}
