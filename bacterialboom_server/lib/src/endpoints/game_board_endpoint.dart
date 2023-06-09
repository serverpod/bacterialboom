import 'dart:async';

import 'package:bacterialboom_server/src/extensions/game_state.dart';
import 'package:bacterialboom_server/src/extensions/player.dart';
import 'package:bacterialboom_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class GameBoardEndpoint extends Endpoint {
  GameBoardEndpoint() {
    // Tick the game state every 100ms.
    Timer.periodic(GameStateExtension.tickTime, (timer) {
      GameStateExtension.tickAll();
    });
  }

  @override
  bool get requireLogin => true;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    var userId = await session.auth.authenticatedUserId;
    if (userId == null) {
      throw Exception('User not authenticated.');
    }

    // Find an open game.
    var game = GameStateExtension.findOrCreateGame();

    // Create a player for the user.
    Player player = PlayerExtension.create(
      userId,
      game,
    );

    // Associate the user with a game.
    var userObject = _UserObject(
      player: player,
      game: game,
    );
    setUserObject(
      session,
      userObject,
    );

    // Pass messages from the game channel along to the new player.
    session.messages.addListener(userObject.game.channel, (message) {
      sendStreamMessage(session, message);
    });

    // Send the initial game state.
    sendStreamMessage(session, game);
  }

  @override
  Future<void> streamClosed(StreamingSession session) async {
    // Remove the user from the game.
    var userObject = getUserObject(session) as _UserObject;
    userObject.game.removePlayer(userObject.player);
  }
}

class _UserObject {
  _UserObject({
    required this.player,
    required this.game,
  });

  final GameState game;
  final Player player;
}
