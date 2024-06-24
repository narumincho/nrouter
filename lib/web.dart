import 'dart:async';
import 'dart:math';
import 'package:web/web.dart';

Uri? locationHref() {
  print(('called locationHref in web', window.location.href));
  return Uri.tryParse(window.location.href);
}

void historyReplaceState(Uri uri) {
  window.history.replaceState(null, '', uri.toString());
}

void historyBack() {
  window.history.back();
}

Future<void> Function() listenLocationChange(
    void Function(Uri, num?) listener) {
  final subscription = window.onPopState.listen((event) {
    // if (event.state is num) {
    listener(Uri.parse(window.location.href), null
        // event.state as num,
        );
    // } else {
    //   listener(
    //     Uri.parse(window.location.href),
    //     null,
    //   );
    // }
  });
  return subscription.cancel;
}
