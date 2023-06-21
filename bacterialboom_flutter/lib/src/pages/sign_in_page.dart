import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/pages/splash_page.dart';
import 'package:bacterialboom_flutter/src/widgets/scrolling_background.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollingBackground(
          key: scrollingBackgroundKey,
        ),
        Center(
          child: Dialog(
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignInWithEmailButton(
                    caller: client.modules.auth,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
