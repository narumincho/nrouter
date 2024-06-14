import 'package:web/web.dart';

const bool isWeb = true;

Uri? locationHref() {
  print(('called locationHref in web', window.location.href));
  return Uri.tryParse(window.location.href);
}
