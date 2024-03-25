

import 'package:QLCVTB/src/app.dart';
import 'package:QLCVTB/src/thongbao/local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

export 'src/fire_base/fire_user.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}




