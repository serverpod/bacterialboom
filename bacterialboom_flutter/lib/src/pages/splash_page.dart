import 'package:bacterialboom_flutter/main.dart';
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
        ),
        Center(
          child: ElevatedButton(
            onPressed: onPressedPlay,
            child: const Text('Play'),
          ),
        ),
      ],
    );
  }
}
