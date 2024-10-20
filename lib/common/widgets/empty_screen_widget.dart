import 'package:flutter/material.dart';

class EmptyScreenWidget extends StatelessWidget {
  final String text;

  const EmptyScreenWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
