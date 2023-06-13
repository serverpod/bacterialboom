import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:bacterialboom_flutter/src/widgets/game_board.dart';
import 'package:bacterialboom_flutter/src/widgets/connection_display.dart';
import 'package:bacterialboom_flutter/src/widgets/game_controls.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

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
          setState(() {
            _gameState = update;
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
    client.gameBoard.resetStream();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionDisplay(
      connectionState: _connectionHandler.status,
      child: _gameState == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  color: Colors.grey[800],
                ),
                GameBoardWidget(
                  gameState: _gameState!,
                  inputController: _gameInputController,
                ),
                GameControlsWidget(
                  controller: _gameInputController,
                ),
              ],
            ),
    );
  }
}
