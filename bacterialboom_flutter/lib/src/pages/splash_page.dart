import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    required this.onPressedPlay,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressedPlay;

  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressedPlay,
        child: const Text('Play'),
      ),
    );
  }
}
