import 'package:web/web.dart';

Uri? locationHref() {
  print(('called locationHref in web', window.location.href));
  return Uri.tryParse(window.location.href);
}
