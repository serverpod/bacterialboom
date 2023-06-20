import 'package:bacterialboom_server/src/extensions/blob.dart';
import 'package:bacterialboom_server/src/extensions/body.dart';
import 'package:bacterialboom_server/src/extensions/food.dart';
import 'package:bacterialboom_server/src/extensions/npc.dart';
import 'package:bacterialboom_server/src/extensions/player.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:bacterialboom_server/src/logic/collisions.dart';
import 'package:serverpod/serverpod.dart';

const numPlayerColorIndices = 8;

const _maxPlayers = 40;
const _maxFood = 500;

const _splitTime = 5.0;

extension GameStateExtension on GameState {
  static const boardWidth = 1024.0;
  static const boardHeight = 1024.0;

  static const fps = 10;
  static const tickDuration = Duration(milliseconds: 1000 ~/ fps);
  static const deltaTime = 1 / fps;

  static final List<GameState> _runningGames = [];
  static int _gameId = 0;

  String get channel => 'game-$gameId';

  static GameState findOrCreateGame() {
    for (var game in _runningGames) {
      if (game.numPlayersInGame < _maxPlayers) {
        return game;
      }
    }

    var newGame = GameState(
      board: Board(width: boardWidth, height: boardHeight),
      gameId: _gameId++,
      food: [],
      players: [],
      time: 0.0,
      deltaTime: deltaTime,
      nextColorIdx: 0,
    );

    newGame._spawnNpcs();
    newGame._spawnFood();

    _runningGames.add(newGame);
    return newGame;
  }

  void addPlayer(Player player) {
    players.add(player);
  }

  void removePlayer(Player player) {
    players.removeWhere((e) => e.userId == player.userId);
    if (numPlayersInGame == 0) {
      _runningGames.remove(this);
    }
  }

  int get numPlayersInGame {
    var count = 0;
    for (var player in players) {
      if (!player.isNpc) count++;
    }
    return count;
  }

  static Future<void> tickAll() async {
    for (var game in _runningGames) {
      game.tick();
      var session = await Serverpod.instance!.createSession();

      session.messages.postMessage(
        game.channel,
        game,
      );

      await session.close();
    }
  }

  void tick() {
    // Move non playing characters.
    for (var npc in players) {
      if (npc.isNpc) {
        npc.tickNpc(this);
      }
    }

    // Check collisions.
    var removeBlobIds = <int>{};
    var removeFoodIds = <int>{};
    var playerLookup = <int, Player>{};

    var blobs = <Blob>[];
    for (var player in players) {
      blobs.addAll(player.blobs);
      playerLookup[player.userId] = player;
    }

    var collisionHandler = CollisionHandler(
      blobs: blobs,
      food: food,
    );

    for (var player in players) {
      for (var blob in player.blobs) {
        // Check collisions with other blobs.
        var collidingBlobs = collisionHandler.collidesWithBlob(blob.body);
        for (var collidingBlob in collidingBlobs) {
          // Skip collisons with self.
          if (collidingBlob.userId == player.userId) {
            continue;
          }
          var otherPlayer = playerLookup[collidingBlob.userId];
          if (otherPlayer == null) {
            continue;
          }

          // Skip already eaten blobs.
          if (removeBlobIds.contains(collidingBlob.blobId)) {
            continue;
          }

          // Skip collisions with players that have been alive for less
          // than 5 seconds.
          if (otherPlayer.getLifeTime(this) < 5) {
            continue;
          }

          // Eat smaller blobs.
          if (collidingBlob.body.radius < blob.body.radius) {
            blob.area += collidingBlob.area;
            removeBlobIds.add(collidingBlob.blobId);
            player.score += collidingBlob.area / defaultFoodArea;
          }
        }

        // Check collisions with food.
        var collidingFood = collisionHandler.collidesWithFood(blob.body);
        for (var f in collidingFood) {
          if (!removeFoodIds.contains(f.foodId)) {
            blob.area += f.body.area;
            removeFoodIds.add(f.foodId);
            player.score += f.body.area / defaultFoodArea;
          }
        }
      }
    }

    // Remove eaten food.
    food.removeWhere((e) => removeFoodIds.contains(e.foodId));

    // Remove eaten blobs.
    var removePlayerIds = <int>{};
    for (var player in players) {
      player.blobs.removeWhere((e) => removeBlobIds.contains(e.blobId));
      if (player.blobs.isEmpty) {
        print('Player died. Lifetime: ${player.getLifeTime(this)}');
        removePlayerIds.add(player.userId);
      }
    }

    // Remove players with no blobs.
    players.removeWhere((e) => removePlayerIds.contains(e.userId));

    // Spawn new food.
    _spawnFood();

    // Spawn new npcs.
    _spawnNpcs();

    // Shrink blobs.
    for (var player in players) {
      player.shrinkBlobs();
    }

    // Join blobs.
    for (var player in players) {
      if (player.splittedAt != null && player.splittedAt! + _splitTime < time) {
        player.joinBlobs(this);
      }
    }

    // Update time.
    time += deltaTime;
  }

  void _spawnFood() {
    var numNewFood = _maxFood - food.length;
    for (var i = 0; i < numNewFood; i++) {
      FoodExtension.create(this);
    }
  }

  void _spawnNpcs() {
    int numNewNpcs = _maxPlayers - players.length;
    for (var i = 0; i < numNewNpcs; i++) {
      NpcExtension.create(game: this);
    }
  }
}
