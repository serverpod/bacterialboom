import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class TransactionalEmails {
  static Future<bool> sendValidationEmail(
    Session session,
    String recipient,
    String validationCode,
  ) async {
    return await sendEmail(
      session,
      recipient: recipient,
      subject: 'Your verification code',
      text: '''Hello,

Your Bacterial Boom verification code is $validationCode.

Best redgards,
Serverpod
''',
      html: '''<p>Hello,</p>
<p>Your Bacterial Boom verification code is $validationCode.</p>
<p>Best regards,<br>
Serverpod</p>
''',
    );
  }

  static Future<bool> sendPasswordResetEmail(
    Session session,
    UserInfo userInfo,
    String validationCode,
  ) async {
    return await sendEmail(
      session,
      recipient: userInfo.email!,
      subject: 'Your verification code',
      text: '''Hello ${userInfo.userName},

Your Bacterial Boom password reset code is $validationCode.

Best redgards,
Serverpod
''',
      html: '''<p>Hello ${userInfo.userName},</p>
<p>Your Bacterial Boom password reset code is $validationCode.</p>
<p>Best regards,<br>
Serverpod</p>
''',
    );
  }

  static Future<bool> sendEmail(
    Session session, {
    required String recipient,
    required String subject,
    required String text,
    required String html,
  }) async {
    try {
      var smtp = SmtpServer(
        'smtp.mandrillapp.com',
        username: 'updates',
        password: Serverpod.instance!.getPassword('mandrill')!,
      );

      var message = Message()
        ..from = Address('updates@serverpod.news', 'Serverpod')
        ..recipients.add(recipient)
        ..subject = subject
        ..text = text
        ..html = html;

      await send(message, smtp);
    } catch (e, stackTrace) {
      session.log(
        'Failed to send email',
        level: LogLevel.warning,
        exception: e,
        stackTrace: stackTrace,
      );
      return false;
    }
    return true;
  }
}
