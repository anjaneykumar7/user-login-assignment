import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:userapp/home.dart';
import 'package:userapp/info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("data");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box? mybox = Hive.box("data");
  Map user = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = mybox!.get("login") ?? {};
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: mybox!.get("login") == null ? Home() : Info(),
    );
  }
}
