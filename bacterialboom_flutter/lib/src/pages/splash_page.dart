import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/tiled_sprite.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

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
  final SplashBackgroundNode _splashNode = SplashBackgroundNode();
  final SplashLogoNode _logoNode = SplashLogoNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SpriteWidget(
          _splashNode,
          transformMode: SpriteBoxTransformMode.letterbox,
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 3,
                child: SpriteWidget(
                  _logoNode,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SplashBackgroundNode extends NodeWithSize {
  SplashBackgroundNode() : super(const Size(1024, 1024)) {
    // Parallax background.
    var background = TiledSprite(
      image: resourceManager.backgroundImage,
      size: size,
    );
    background.imageScale = 5.0;
    addChild(background);
    _backgroundLayers.add(background);
    _backgroundLayersSpeeds.add(20.0);

    var overlay0 = TiledSprite(
      image: resourceManager.backgroundOverlayImage,
      blendMode: BlendMode.plus,
      size: size,
    );
    overlay0.imageScale = 1.0;
    addChild(overlay0);
    _backgroundLayers.add(overlay0);
    _backgroundLayersSpeeds.add(50.0);

    var overlay1 = TiledSprite(
      image: resourceManager.backgroundOverlayImage,
      blendMode: BlendMode.plus,
      size: size,
    );
    overlay1.imageScale = 1.5;
    addChild(overlay1);
    _backgroundLayers.add(overlay1);
    _backgroundLayersSpeeds.add(75.0);

    var overlay2 = TiledSprite(
      image: resourceManager.backgroundOverlayImage,
      blendMode: BlendMode.plus,
      size: size,
    );
    overlay2.imageScale = 2.0;
    addChild(overlay2);
    _backgroundLayers.add(overlay2);
    _backgroundLayersSpeeds.add(100.0);
  }

  double _yOffset = 0.0;

  final _backgroundLayers = <TiledSprite>[];
  final _backgroundLayersSpeeds = <double>[];

  @override
  void update(double dt) {
    _yOffset -= dt * 0.25;

    for (var i = 0; i < _backgroundLayers.length; i++) {
      var layer = _backgroundLayers[i];
      var speed = _backgroundLayersSpeeds[i];
      layer.offset = Offset(0.0, _yOffset * speed);
    }
  }
}

class SplashLogoNode extends NodeWithSize {
  SplashLogoNode() : super(const Size(1024, 512)) {
    // Animated logo.
    var logo = Sprite(texture: resourceManager.logoSprite);
    logo.position = Offset(size.width / 2, size.height / 3);
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
