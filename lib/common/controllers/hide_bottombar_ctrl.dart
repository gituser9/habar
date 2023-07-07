import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class HideBottomBarCtrl {
  final scrollCtrl = ScrollController();
  final isBottomBarVisible = true.obs;
  final duration = const Duration(milliseconds: 700);

  HideBottomBarCtrl() {
    scrollCtrl.addListener(() {
      if (scrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
        if (isBottomBarVisible.isFalse) {
          showNavBar();
        }
      } else {
        if (isBottomBarVisible.isTrue) {
          hideNavBar();
        }
      }
    });
  }

  void showNavBar() {
    isBottomBarVisible.value = true;
  }

  void hideNavBar() {
    isBottomBarVisible.value = false;
  }
}
