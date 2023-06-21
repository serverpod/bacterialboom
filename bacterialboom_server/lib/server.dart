import 'package:bacterialboom_server/src/util/transactional_emails.dart';
import 'package:serverpod/serverpod.dart';

import 'package:bacterialboom_server/src/web/routes/root.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      print('Sending validation email to $email with code $validationCode');
      return await TransactionalEmails.sendValidationEmail(
        session,
        email,
        validationCode,
      );
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      print(
        'Sending password reset email to ${userInfo.email} with '
        'code $validationCode',
      );
      return await TransactionalEmails.sendPasswordResetEmail(
        session,
        userInfo,
        validationCode,
      );
    },
  ));

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  // Start the server.
  await pod.start();
}
