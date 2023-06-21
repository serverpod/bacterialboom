/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/game_board_endpoint.dart' as _i2;
import '../endpoints/mailing_list.dart' as _i3;
import 'package:serverpod_auth_server/module.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'gameBoard': _i2.GameBoardEndpoint()
        ..initialize(
          server,
          'gameBoard',
          null,
        ),
      'mailingList': _i3.MailingListEndpoint()
        ..initialize(
          server,
          'mailingList',
          null,
        ),
    };
    connectors['gameBoard'] = _i1.EndpointConnector(
      name: 'gameBoard',
      endpoint: endpoints['gameBoard']!,
      methodConnectors: {},
    );
    connectors['mailingList'] = _i1.EndpointConnector(
      name: 'mailingList',
      endpoint: endpoints['mailingList']!,
      methodConnectors: {
        'join': _i1.MethodConnector(
          name: 'join',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mailingList'] as _i3.MailingListEndpoint)
                  .join(session),
        )
      },
    );
    modules['serverpod_auth'] = _i4.Endpoints()..initializeEndpoints(server);
  }
}
