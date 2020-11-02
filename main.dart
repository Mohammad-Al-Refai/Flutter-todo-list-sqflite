import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/db.dart';
import 'package:sqlite/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => update())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SQfite"),
        ),
        body: content(context));
  }
}

Widget content(context) {
  var db = DataBaseConnection();
  db.CreateDataBase();
  var x = Provider.of<update>(context);
  db.getAll().then((data) async {
    x.list = data;
    x.ref();
  });

  return Center(
      child: ListView(
    children: [
      Center(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: Wrap(
            children: [
              Container(
                  width: 220,
                  child: TextField(
                    onChanged: (v) async {
                      x.text = v;
                      x.ref();
                    },
                  )),
              IconButton(
                onPressed: () async {
                  await db.insert_user(x.text);
                  x.ref();
                  await db.getAll().then((data) => x.list = data);
                  x.ref();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.green,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * .6 + 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
        child: ListView(
            children: x.list
                .map((e) => ListTile(
                      onLongPress: () async =>
                          await edit(Map.of(e)["id"], db, context),
                      trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () async {
                            await db.remove(Map.of(e)["id"]);
                            x.ref();
                            await db.getAll().then((data) => x.list = data);
                            x.ref();
                          }),
                      title: Text(Map.of(e)["name"].toString()),
                      subtitle: Text("id : " + Map.of(e)["id"].toString()),
                    ))
                .toList()),
      )
    ],
  ));
}

edit(id, DataBaseConnection db, context) {
  var x = Provider.of<update>(context);
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
              actions: [
                RaisedButton(
                  onPressed: () async {
                    await db.change(id, x.change_value);
                    x.ref();
                    await db.getAll().then((data) async => x.list = data);
                    x.ref();
                    Navigator.pop(context);
                  },
                  child: Text("change"),
                )
              ],
              content: TextField(
                onChanged: (v) async {
                  x.change_value = v;
                  x.ref();
                },
              )));
}
