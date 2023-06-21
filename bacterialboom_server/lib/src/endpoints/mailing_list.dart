import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:bacterialboom_server/src/util/mailing_list.dart';

class MailingListEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> join(Session session) async {
    var userId = (await session.auth.authenticatedUserId)!;
    var userInfo = await Users.findUserByUserId(session, userId);

    var email = userInfo?.email;
    if (email != null) {
      // Join mailing list
      await addToMailingList(email, userInfo!.userName);
    } else {
      session.log(
        'Failed join emailing list, no email was found.',
        level: LogLevel.warning,
      );
    }
  }
}
