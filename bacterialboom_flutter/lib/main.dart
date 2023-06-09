import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/src/pages/game_page.dart';
import 'package:bacterialboom_flutter/src/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:made_with_serverpod/made_with_serverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late SessionManager sessionManager;
late Client client;

void main() async {
  // Setup Serverpod client and session manager.
  WidgetsFlutterBinding.ensureInitialized();

  client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  // Run the app.
  runApp(const BacterialBoomApp());
}

class BacterialBoomApp extends StatelessWidget {
  const BacterialBoomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bacterial Boom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Bacterial Boom'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   actions: sessionManager.isSignedIn
      //       ? [
      //           IconButton(
      //             icon: Icon(Icons.logout),
      //             onPressed: sessionManager.signOut,
      //           )
      //         ]
      //       : const [],
      // ),
      body: SafeArea(
        child: MadeWithServerpod(
          url: Uri.parse('https://github.com/serverpod/bacterialboom'),
          child:
              sessionManager.isSignedIn ? const GamePage() : const SignInPage(),
        ),
      ),
    );
  }
}
