import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/widgets/email_signup.dart';
import 'package:bacterialboom_flutter/src/widgets/scrolling_background.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:url_launcher/url_launcher.dart';

final scrollingBackgroundKey = GlobalKey();

class SplashPage extends StatefulWidget {
  const SplashPage({
    required this.onPressedPlay,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressedPlay;

  static const String routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashLogoNode _logoNode = SplashLogoNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasAskedToJoinMailingList()) {
        showJoinMailingListDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollingBackground(
          key: scrollingBackgroundKey,
        ),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < constraints.maxHeight) {
            return _buildPortrait();
          } else {
            return _buildLandscape();
          }
        }),
        Positioned(
          top: 16,
          right: 16,
          left: 16,
          child: _buildTopMenu(),
        ),
        Positioned(
          bottom: 14,
          right: 16,
          left: 16,
          child: Center(
            child: Image.asset(
              'assets/serverpod.png',
              width: 150,
              color: Colors.black,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          left: 16,
          child: Center(
            child: Image.asset(
              'assets/serverpod.png',
              width: 150,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortrait() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo(),
        const SizedBox(height: 32),
        _buildPlayButton(),
      ],
    );
  }

  Widget _buildLandscape() {
    return Stack(
      children: [
        Center(child: _buildLogo()),
        Center(child: _buildPlayButton()),
      ],
    );
  }

  Widget _buildLogo() {
    return AspectRatio(
      aspectRatio: 2,
      child: SpriteWidget(
        _logoNode,
      ),
    );
  }

  Widget _buildPlayButton() {
    return ElevatedButton(
      onPressed: widget.onPressedPlay,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 32,
        ),
        elevation: 32,
        shadowColor: Colors.black,
        backgroundColor: Colors.green.shade600,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.yellow.shade200,
        side: const BorderSide(
          color: Colors.black,
          width: 4,
        ),
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          shadows: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
      child: const Text('PLAY'),
    );
  }

  Widget _buildTopMenu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTopMenuButton(
          text: 'Logout',
          onPressed: () {
            sessionManager.signOut();
          },
        ),
        const Spacer(),
        _buildTopMenuButton(
          text: 'Mailing List',
          onPressed: () {
            showJoinMailingListDialog(context);
          },
        ),
        _buildTopMenuButton(
          text: 'View Code',
          onPressed: () {
            launchUrl(Uri.parse('https://github.com/serverpod/bacterialboom'));
          },
        ),
      ],
    );
  }

  Widget _buildTopMenuButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashLogoNode extends NodeWithSize {
  SplashLogoNode() : super(const Size(1024, 512)) {
    // Animated logo.
    var logo = Sprite(texture: resourceManager.logoSprite);
    logo.position = Offset(size.width / 2, size.height / 2);
    logo.scale = 0.52;
    addChild(logo);

    // Pulsating animation
    var logoPulsating = MotionSequence(motions: [
      MotionDelay(delay: 1.0),
      MotionTween(
        setter: (double a) => logo.scale = a,
        start: 0.52,
        end: 0.63,
        duration: 0.5,
        curve: Curves.bounceOut,
      ),
      MotionTween(
        setter: (double a) => logo.scale = a,
        start: 0.63,
        end: 0.52,
        duration: 0.5,
        curve: Curves.bounceOut,
      ),
    ]);
    logo.motions.run(MotionRepeatForever(motion: logoPulsating));
  }
}
