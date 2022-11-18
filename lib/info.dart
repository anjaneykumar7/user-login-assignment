import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:userapp/home.dart';

class Info extends StatefulWidget {
  const Info({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  Box? mybox = Hive.box("data");

  late Map user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = mybox!.get("login");
    //loginState();
  }

  loginState() async {
    user["islogin"] = true;
    // await mybox!.put(widget.name, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user["name"]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Name: ${user["name"]}"),
            25.height,
            Text("Age: ${user["age"]}"),
            25.height,
            Text("Gender: ${user["gender"]}"),
            25.height,
            ElevatedButton(
                onPressed: () async {
                  await mybox!.put("login", null);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  Route route = MaterialPageRoute(builder: (_) => Home());
                  // ignore: use_build_context_synchronously
                  Navigator.push(context, route);
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
