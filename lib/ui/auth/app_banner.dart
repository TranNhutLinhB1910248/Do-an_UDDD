import 'dart:math';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 94.0,
      ),
      child: Text(
        'MyApp',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.blue,
              fontFamily: 'Anton',
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
