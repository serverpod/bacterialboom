import 'package:bacterialboom_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinMailingList extends StatelessWidget {
  const JoinMailingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
                'Bacterial Boom is a demo for Serverpod, a backend framework '
                'for Flutter. Join our mailing list to learn more.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setHasAskedToJoinMailingList();
                Navigator.of(context).pop();
              },
              child: const Text('Just Play'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setHasAskedToJoinMailingList();
                Navigator.of(context).pop();
                client.mailingList.join();
              },
              child: const Text('Join Mailing List'),
            ),
          ],
        ),
      ),
    );
  }
}

void showJoinMailingListDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const JoinMailingList(),
  );
}

bool _hasAskedToJoinMailingList = false;

Future<void> loadHasAskedToJoinMailingList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _hasAskedToJoinMailingList =
      prefs.getBool('hasAskedToJoinMailingList') ?? false;
}

bool hasAskedToJoinMailingList() {
  return _hasAskedToJoinMailingList;
}

void setHasAskedToJoinMailingList() async {
  _hasAskedToJoinMailingList = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasAskedToJoinMailingList', true);
}
