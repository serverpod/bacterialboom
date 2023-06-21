import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/game_nodes/tiled_sprite.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class ScrollingBackground extends StatefulWidget {
  const ScrollingBackground({Key? key}) : super(key: key);

  @override
  ScrollingBackgroundState createState() => ScrollingBackgroundState();
}

class ScrollingBackgroundState extends State<ScrollingBackground> {
  final _splashBackgroundNode = _ScrollingBackgroundNode();

  @override
  Widget build(BuildContext context) {
    return SpriteWidget(
      _splashBackgroundNode,
      transformMode: SpriteBoxTransformMode.letterbox,
    );
  }
}

class _ScrollingBackgroundNode extends NodeWithSize {
  _ScrollingBackgroundNode() : super(const Size(1024, 1024)) {
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
