import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mobile/views/register_mobile_view.dart';
import 'web/view/register_web_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (GetPlatform.isWeb)
        ? const RegisterWebView()
        : const RegisterMobileView();
  }
}
