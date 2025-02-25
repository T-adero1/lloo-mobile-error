

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LlooView<ViewController extends GetxController, State> extends GetView<ViewController> {

  final State state = Get.find();
  ThemeData get theme => Theme.of(Get.context!);

  LlooView({super.key});

}

