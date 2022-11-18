// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:userapp/data.dart';
import 'package:userapp/info.dart';

import 'user_model.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box? mybox;
  late List<User> users = [];

  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

    mybox = Hive.box("data");
  }

  getData() {
    var data = jsonDecode(userdata);

    data = data[0]["users"];
    data.forEach((e) {
      String name = e['name'] ?? "error";
      int id = int.parse(e['id'] ?? 11);
      String type = e['atype'] ?? "error";
      users.add(User(
        id: id,
        name: name,
        type: type,
      ));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.separated(
        itemCount: users.length,
        itemBuilder: (cnx, listIndex) {
          String name = users.elementAt(listIndex).name;
          var user = mybox!.get(name);
          return ListTile(
            title: GestureDetector(
              child: Text(
                users.elementAt(listIndex).name,
                textAlign: TextAlign.left,
              ),
              onTap: () async {
                if (await mybox!.get(name) == null) {
                  showDialogBox(context, listIndex);
                } else {
                  await mybox!.put("login", await mybox!.get(name));
                  Route route = MaterialPageRoute(builder: (_) => const Info());
                  Navigator.push(cnx, route);
                }
              },
            ),
            trailing: (user != null)
                ? ElevatedButton(
                    child: const Text("signin"),
                    onPressed: () async {
                      await mybox!.put("login", await mybox!.get(name));
                      Route route =
                          MaterialPageRoute(builder: (_) => const Info());
                      Navigator.push(cnx, route);
                    },
                  )
                : const SizedBox(),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.grey,
            height: 1,
          );
        },
      ),
    );
  }

  showDialogBox(conx, index) {
    return showDialog(
        context: conx,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 400,
              child: ListView(
                children: [
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: age,
                        decoration: const InputDecoration(
                            label: Text("Age"),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2))),
                      ),
                    ),
                  ),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: gender,
                        decoration: const InputDecoration(
                            label: Text("Gender"),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2))),
                      ),
                    ),
                  ),
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        child: const Text("Save"),
                        onPressed: () async {
                          String n = users.elementAt(index).name;
                          String a = age.text;
                          String g = gender.text;

                          if (a.isNotEmpty && g.isNotEmpty) {
                            Map usr = {
                              "name": n,
                              "age": a,
                              "gender": g,
                            };
                            await mybox!.put(n, usr);
                            await mybox!.put("login", usr);
                            age.text = '';
                            gender.text = '';
                            Navigator.pop(conx);
                            Route route =
                                MaterialPageRoute(builder: (_) => const Info());

                            Navigator.push(conx, route);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please fill textfield"),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
