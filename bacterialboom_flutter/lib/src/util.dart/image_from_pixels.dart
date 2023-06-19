import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bacterialboom_flutter/src/util.dart/noise.dart';

Future<ui.Image> imageFromPixels({
  required Uint8List pixels,
  required int width,
  required int height,
  ui.PixelFormat pixelFormat = ui.PixelFormat.rgba8888,
}) async {
  assert(pixels.length ~/ 4 == width * height, 'Only 4 byte pixels supported');

  var immutableBuffer = await ui.ImmutableBuffer.fromUint8List(pixels);
  var imageDescriptor = ui.ImageDescriptor.raw(
    immutableBuffer,
    width: width,
    height: height,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  var codec = await imageDescriptor.instantiateCodec(
    targetWidth: width,
    targetHeight: height,
  );

  var frameInfo = await codec.getNextFrame();
  codec.dispose();
  immutableBuffer.dispose();
  imageDescriptor.dispose();

  return frameInfo.image;
}

Future<ui.Image> imageFromNoiseGrid(LoopingNoiseGrid noise) async {
  var length = noise.width * noise.height;
  var pixels = Uint8List(length * 4);
  var data = noise.data;

  for (var i = 0; i < length; i += 1) {
    var color = ((data[i] + 1) * 0.5 * 255).round().clamp(0, 255);

    pixels[i * 4 + 0] = color;
    pixels[i * 4 + 1] = color;
    pixels[i * 4 + 2] = color;
    pixels[i * 4 + 3] = 255;
  }

  return await imageFromPixels(
    pixels: pixels,
    width: noise.width,
    height: noise.height,
  );
}
