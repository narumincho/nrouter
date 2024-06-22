import 'dart:async';

Uri? locationHref() {
  print('called locationHref in no_web');
  return null;
}

void historyReplaceState(Uri uri) {
  print('called replace in no_web');
}

Future<void> Function() listenLocationChange(
    void Function(Uri, num?) listener) {
  print('called listen in no_web');
  return () async {};
}
