import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:bacterialboom_flutter/src/pages/game_page.dart';
import 'package:bacterialboom_flutter/src/pages/sign_in_page.dart';
import 'package:bacterialboom_flutter/src/pages/splash_page.dart';
import 'package:bacterialboom_flutter/src/resources/resource_manager.dart';
import 'package:bacterialboom_flutter/src/widgets/email_signup.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late SessionManager sessionManager;
late Client client;

late ResourceManager resourceManager;

void main() async {
  // Make sure Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Load resources
  resourceManager = ResourceManager();
  await resourceManager.load();

  // Load settings.
  await loadHasAskedToJoinMailingList();

  // Setup Serverpod client and session manager.
  client = Client(
    // 'http://localhost:8080/',
    'https://api.bacterialboom.com/',
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
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Bacterial Boom'),
      // showPerformanceOverlay: true,
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
  bool _playing = false;

  @override
  void initState() {
    super.initState();

    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (sessionManager.isSignedIn) {
      if (_playing) {
        page = GamePage(
          onDone: () {
            setState(() {
              _playing = false;
            });
          },
        );
      } else {
        page = SplashPage(
          onPressedPlay: () {
            setState(() {
              _playing = true;
            });
          },
        );
      }
    } else {
      page = const SignInPage();
    }

    return Scaffold(
      body: SafeArea(
        child: page,
      ),
    );
  }
}
