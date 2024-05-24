import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

typedef HttpClientRequestDelegateResponseMaker = Future<http.Response> Function(
  http.Client client,
);
typedef HttpClientRequestDelegateResponseParser<T> = FutureOr<T> Function(
  http.Response response,
  Map<String, dynamic> data,
);

sealed class HttpClientRequestDelegateException implements Exception {}

final class HttpClientRequestDelegateRequestException
    implements HttpClientRequestDelegateException {
  const HttpClientRequestDelegateRequestException({
    required this.exception,
  });

  final dynamic exception;

  @override
  String toString() {
    return exception.toString();
  }
}

final class HttpClientRequestDelegateParseException
    implements HttpClientRequestDelegateException {
  const HttpClientRequestDelegateParseException({
    required this.exception,
    required this.response,
  });

  final dynamic exception;
  final http.Response response;

  @override
  String toString() {
    return 'Failed to parse the response.'
        '\nException:$exception'
        '\nResponse${response.body}';
  }
}

@injectable
final class HttpClientRequestDelegate {
  const HttpClientRequestDelegate(
    this._client,
  );

  final http.Client _client;

  Future<T> call<T>({
    required HttpClientRequestDelegateResponseMaker responseMaker,
    required HttpClientRequestDelegateResponseParser<T> parser,
  }) async {
    final http.Response rawResponse;
    try {
      rawResponse = await responseMaker(_client);
    } catch (ex) {
      throw HttpClientRequestDelegateRequestException(
        exception: ex,
      );
    }
    try {
      final decoded =
          (jsonDecode(rawResponse.body) as Map).cast<String, dynamic>();
      return parser(rawResponse, decoded);
    } catch (ex) {
      throw HttpClientRequestDelegateParseException(
        exception: ex,
        response: rawResponse,
      );
    }
  }
}
