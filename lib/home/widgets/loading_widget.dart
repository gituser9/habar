import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: const Align(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
