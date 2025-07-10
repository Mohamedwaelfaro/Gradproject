import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mahsoly_app1/payment/dio_helper.dart';

Future<void> initializeApp() async {
  DioHelper.init();
  await InAppWebViewController.setWebContentsDebuggingEnabled(true);
}
