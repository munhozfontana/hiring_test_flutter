import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxbit_hiring_test_template/app/application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(FoxbitApp());
}
