import 'dart:async';

import 'package:web/web.dart';

Uri? locationHref() {
  print(('called locationHref in web', window.location.href));
  return Uri.tryParse(window.location.href);
}

void historyReplaceState(Uri uri) {
  window.history.replaceState(null, '', uri.toString());
}

Future<void> Function() listenLocationChange(void Function(Uri) listener) {
  final subscription = window.onPopState.listen((event) {
    listener(Uri.parse(window.location.href));
  });
  return subscription.cancel;
}
