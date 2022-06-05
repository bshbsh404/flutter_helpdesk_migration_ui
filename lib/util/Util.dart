import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shopping_app_ui/colors/Colors.dart';
import 'package:shopping_app_ui/global_keys/navbar_key.dart';
import 'package:shopping_app_ui/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

bool isAnimate = false;
int currentIndex = -1;

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void navigateToScreen(BuildContext context, Widget screenWidget) {
  Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return screenWidget;
    },
  ));
}

void navigateHomeScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void navigateAndReplaceScreen(BuildContext context, String destination) {
  Navigator.of(context).pushReplacementNamed(destination);
}

void navigateAndClearHistory(BuildContext context, String destination) {
  Navigator.pushNamedAndRemoveUntil(context, destination, (r) => false);
}

void navigateToScreenFromDrawer(BuildContext context, Widget screenWidget) {
  Navigator.pop(context);
  Future.delayed(Duration(milliseconds: 300), () {
    navigateToScreen(context, screenWidget);
  });
}

Widget displayLoadingIndicator() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryColor),
      backgroundColor: Colors.transparent,
    ),
  );
}

void showInfoToast(BuildContext context, String message) {
  ToastUtils.showCustomToast(context, message, primaryColor, 3);
}

void showErrorToast(BuildContext context, String message) {
  ToastUtils.showCustomToast(context, message, Colors.red, 3);
}

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

State<StatefulWidget> getNavState(){
  return NavbarKey.getKey().currentState;
}

List<CropAspectRatioPreset> setAspectRatios() {
  return Platform.isAndroid
      ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
      : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ];
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
