import 'package:spritewidget/spritewidget.dart';

class ResourceManager {
  final ImageMap images = ImageMap();

  static const _blobParticleFile = 'assets/blob_particle.png';
  late final SpriteTexture blobParticle;

  Future<void> load() async {
    await images.load([_blobParticleFile]);

    blobParticle = SpriteTexture(images[_blobParticleFile]!);
  }
}
