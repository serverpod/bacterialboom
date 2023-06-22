import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/extensions/game_state.dart';
import 'package:bacterialboom_flutter/src/pages/splash_page.dart';
import 'package:bacterialboom_flutter/src/widgets/game_board.dart';
import 'package:bacterialboom_flutter/src/widgets/connection_display.dart';
import 'package:bacterialboom_flutter/src/widgets/game_controls.dart';
import 'package:bacterialboom_flutter/src/widgets/highscore_list.dart';
import 'package:bacterialboom_flutter/src/widgets/scrolling_background.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.onDone,
  });

  final VoidCallback onDone;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameState? _gameState;
  final _gameInputController = GameInputController();

  late final StreamingConnectionHandler _connectionHandler;

  @override
  void initState() {
    super.initState();

    _listenToUpdates();

    _connectionHandler = StreamingConnectionHandler(
      client: client,
      listener: (connectionState) {
        if (!mounted) {
          return;
        }
        setState(() {
          if (connectionState.status != StreamingConnectionStatus.connected) {
            _gameState = null;
          }
        });
      },
    );
    _connectionHandler.connect();
  }

  Future<void> _listenToUpdates() async {
    client.gameBoard.resetStream();

    try {
      await for (var update in client.gameBoard.stream) {
        if (update is GameState) {
          // Got a full game state update.
          setState(() {
            _gameState = update;
          });
        } else if (update is GameStateUpdate && _gameState != null) {
          // Got an incremental game update. Apply it to the current game
          // state.
          setState(() {
            _gameState!.update(update);
          });
        }
      }
    } catch (e) {
      print('Error listening to updates: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _connectionHandler.dispose();
    _gameState = null;
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionDisplay(
      connectionState: _connectionHandler.status,
      child: _gameState == null
          ? Stack(
              fit: StackFit.expand,
              children: [
                ScrollingBackground(
                  key: scrollingBackgroundKey,
                ),
                Container(
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 128,
                    height: 128,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    color: Colors.grey[800],
                  ),
                  GameBoardWidget(
                    gameState: _gameState!,
                    inputController: _gameInputController,
                    onDone: () {
                      widget.onDone();
                      _connectionHandler.close();
                    },
                  ),
                  GameControlsWidget(
                    controller: _gameInputController,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: HighScoreList(
                      gameState: _gameState!,
                      compact: constraints.maxWidth < 400,
                    ),
                  )
                ],
              );
            }),
    );
  }
}
