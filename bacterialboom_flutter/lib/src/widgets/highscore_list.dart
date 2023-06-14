import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:flutter/material.dart';

class HighScoreList extends StatelessWidget {
  const HighScoreList({
    Key? key,
    required this.gameState,
  }) : super(key: key);

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final players = List<Player>.from(gameState.players);
    players.sort((a, b) => b.score.compareTo(a.score));

    final highScores = players
        .take(10)
        .map((player) => HighScore(
              name: player.name,
              score: player.score,
            ))
        .toList();

    return SizedBox(
      width: 120,
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
  }) : super(key: key);

  final String name;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            score.floor().toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
