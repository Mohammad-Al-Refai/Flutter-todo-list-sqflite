import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseConnection {
  Future<Database> CreateDataBase() async {
    var dirctory = await getApplicationDocumentsDirectory();
    var path = join(dirctory.path, "db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int v) async {
    await db.execute(
        "CREATE TABLE users(id INTEGER  PRIMARY KEY,name VARCHAR(255) NOT NULL)");
  }

  insert_user(String name) async {
    var db = await CreateDataBase();
    return db.rawInsert("insert into users (name) values ('$name');");
  }

  getAll() async {
    var db = await CreateDataBase();
    return await db.query("users");
  }

  remove(int id) async {
    var db = await CreateDataBase();
    return db.rawDelete("delete from users where users.id=$id;");
  }

  change(int id, String value) async {
    var db = await CreateDataBase();
    return db.rawUpdate("update users set name='$value' where id=$id");
  }
}
