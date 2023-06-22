import 'dart:io';

import 'package:bacterialboom_server/src/web/widgets/default_page_widget.dart';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(Session session, HttpRequest request) async {
    request.response.headers.add(
      'Cache-Control',
      'no-cache, no-store, must-revalidate',
    );
    return DefaultPageWidget();
  }
}
