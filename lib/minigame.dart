import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

class MiniGame extends FlameGame with KeyboardEvents, TapDetector, PanDetector {
  late SpriteComponent player;
  late SpriteComponent background;
  double speed = 200;
  bool moveLeft = false;
  bool moveRight = false;

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll(['background.png', 'player.png']);

    background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size
      ..position = Vector2.zero()
      ..anchor = Anchor.topLeft;
    add(background);

    player = SpriteComponent()
      ..sprite = await loadSprite('player.png')
      ..size = Vector2.all(50)
      ..position = Vector2(size.x / 2, size.y - 100);
    add(player);
  }
}
