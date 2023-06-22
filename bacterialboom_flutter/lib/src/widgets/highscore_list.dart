import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/main.dart';
import 'package:flutter/material.dart';

class HighScoreList extends StatelessWidget {
  const HighScoreList({
    Key? key,
    required this.gameState,
    required this.compact,
  }) : super(key: key);

  final GameState gameState;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final players = List<Player>.from(gameState.players);
    players.sort((a, b) {
      if ((a.userId < 0) == (b.userId < 0)) {
        return b.score.compareTo(a.score);
      } else {
        return a.userId < 0 ? 1 : -1;
      }
    });

    final highScores = players
        .take(10)
        .map((player) => HighScore(
              name: player.name,
              score: player.score,
              compact: compact,
              isNPC: player.userId < 0,
              isUser: player.userId == sessionManager.signedInUser?.id,
            ))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withOpacity(0.7),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: compact ? 120 : 160,
      child: Column(
        children: highScores,
      ),
    );
  }
}

class HighScore extends StatelessWidget {
  const HighScore({
    Key? key,
    required this.name,
    required this.score,
    required this.compact,
    required this.isNPC,
    required this.isUser,
  }) : super(key: key);

  final String name;
  final double score;
  final bool compact;
  final bool isNPC;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 0.0 : 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isNPC ? Colors.white60 : Colors.white,
                fontSize: 12,
                fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            score.floor().toString(),
            style: TextStyle(
              color: isNPC ? Colors.white60 : Colors.white,
              fontSize: 12,
              fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
