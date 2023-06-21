/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/module.dart' as _i3;
import 'dart:io' as _i4;
import 'protocol.dart' as _i5;

class _EndpointGameBoard extends _i1.EndpointRef {
  _EndpointGameBoard(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'gameBoard';
}

class _EndpointMailingList extends _i1.EndpointRef {
  _EndpointMailingList(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mailingList';

  _i2.Future<void> join() => caller.callServerEndpoint<void>(
        'mailingList',
        'join',
        {},
      );
}

class _Modules {
  _Modules(Client client) {
    auth = _i3.Caller(client);
  }

  late final _i3.Caller auth;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i4.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i5.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    gameBoard = _EndpointGameBoard(this);
    mailingList = _EndpointMailingList(this);
    modules = _Modules(this);
  }

  late final _EndpointGameBoard gameBoard;

  late final _EndpointMailingList mailingList;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'gameBoard': gameBoard,
        'mailingList': mailingList,
      };
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
