import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bacterialboom_flutter/src/util.dart/image_from_pixels.dart';
import 'package:bacterialboom_flutter/src/util.dart/noise.dart';
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class ResourceManager {
  final ImageMap images = ImageMap();

  static const _blobParticleFile = 'assets/blob_particle.png';
  static const _sporeParticleFile = 'assets/spore_particle.png';
  static const _foodSpriteFile = 'assets/food.png';

  late final SpriteTexture blobParticle;
  late final SpriteTexture sporeParticle;
  late final SpriteTexture foodSprite;

  late final ui.Image backgroundImage;
  late final ui.Image backgroundOverlayImage;

  Future<void> load() async {
    await images.load([
      _blobParticleFile,
      _sporeParticleFile,
      _foodSpriteFile,
    ]);

    blobParticle = SpriteTexture(images[_blobParticleFile]!);
    sporeParticle = SpriteTexture(images[_sporeParticleFile]!);
    foodSprite = SpriteTexture(images[_foodSpriteFile]!);

    backgroundImage = await _generateBackground();
    backgroundOverlayImage = await _generateBackgroundOverlay();
  }
}

Future<ui.Image> _generateBackground() async {
  var noise = LoopingNoiseGrid(
    width: 512,
    height: 512,
    frequency: 1,
    seed: 10,
  );

  var length = noise.width * noise.height;
  var pixels = Uint8List(length * 4);
  var data = noise.data;

  var colorSequence = ColorSequence(
    colors: const [
      Color(0xff09ab9e),
      Color(0xff001d27),
      Color(0xff004857),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  for (var i = 0; i < length; i += 1) {
    var colorPosition = (data[i] * 0.5 + 0.5).clamp(0.0, 1.0);
    var color = colorSequence.colorAtPosition(colorPosition);

    pixels[i * 4 + 0] = color.red;
    pixels[i * 4 + 1] = color.green;
    pixels[i * 4 + 2] = color.blue;
    pixels[i * 4 + 3] = 255;
  }

  return await imageFromPixels(
    pixels: pixels,
    width: noise.width,
    height: noise.height,
  );
}

Future<ui.Image> _generateBackgroundOverlay() async {
  var noise = LoopingNoiseGrid(
    width: 512,
    height: 512,
    frequency: 25,
    seed: 10,
  );

  var length = noise.width * noise.height;
  var pixels = Uint8List(length * 4);
  var data = noise.data;

  var colorSequence = ColorSequence(
    colors: const [
      Color(0xff03dadc),
      Color(0xff000000),
      Color(0xff000000),
      Color(0xffbeef7c),
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  for (var i = 0; i < length; i += 1) {
    var colorPosition = (data[i] * 0.5 + 0.5).clamp(0.0, 1.0);
    var color = colorSequence.colorAtPosition(colorPosition);

    pixels[i * 4 + 0] = color.red;
    pixels[i * 4 + 1] = color.green;
    pixels[i * 4 + 2] = color.blue;
    pixels[i * 4 + 3] = 255;
  }

  return await imageFromPixels(
    pixels: pixels,
    width: noise.width,
    height: noise.height,
  );
}
