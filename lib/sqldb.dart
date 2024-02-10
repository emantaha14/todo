import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqlDb{

  Database? _dp;
  Future<Database? >get dp async{
    if(_dp == null){
      _dp = await initialSqlDp();
      return _dp;
    }
    else{
      return _dp;
    }
  }
  Future<Database> initialSqlDp() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'todo.dp');
    Database todoDp = await openDatabase(path,onCreate: _onCreate,version: 1,);
    return todoDp;
  }

  // _onUpgrade(Database dp, int oldVersion, int newVersion) async {
  //   await dp.execute("ALTER TABLE TODO ADD COLUMN isCheckedNew BOOLEAN");
  //   print('onUpgrade ==============================');
  // }

  void _onCreate(Database dp, int version) async {
    await dp.execute('CREATE TABLE TODO (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, date TEXT NOT NULL, isChecked BOOLEAN )');
    print('onCreate.. =======================');
  }

  Future<List<Map>> readData(String sql) async {
    Database? todoDp = await dp;
    List<Map> response = await todoDp!.rawQuery(sql);
    return response;
  }

  Future<int> insertData(String sql) async {
    Database? todoDp = await dp;
    int response = await todoDp!.rawInsert(sql);
    return response;
  }
  Future<int> updateData(String sql) async {
    Database? todoDp = await dp;
    int response = await todoDp!.rawUpdate(sql);
    return response;
  }
  Future<int> deleteData(String sql) async {
    Database? myDp = await dp;
    int response = await myDp!.rawDelete(sql);
    return response;
  }

  onDeleteDataBase() async {
    String databasePath = await getDatabasesPath();
    String pathName = join(databasePath, 'todo.dp');
    await deleteDatabase(pathName);
  }
}