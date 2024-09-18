import 'dart:developer';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  final _appLinks = AppLinks();

  Stream<Uri?> get uriLinkStream => _appLinks.uriLinkStream;

  Future<void> init() async {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleUri(uri);
      }
    });
  }

  void handleUri(Uri uri) {
    // get the path from the uri
    final path = uri.path;
    log(path);
  }
}
