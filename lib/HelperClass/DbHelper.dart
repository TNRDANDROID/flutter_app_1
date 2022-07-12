import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_app/ModelClass/employee.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DbHelper{

  Database? myDb;

  Future<Database?> get db async {
    if (myDb != null) return myDb;
    myDb = await initDb();
    return myDb;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: onCreate);
    return theDb;
  }

   void onCreate(Database db,int version) async{
     await db.execute(
         "CREATE TABLE Employee(id INTEGER PRIMARY KEY, lang TEXT, image TEXT , dropdownItem TEXT )");
     print("Created tables");
  }

  void saveEmployee(Employee employee) async {
      var dbClient = await db;
      List<Map> list = await dbClient!.query('Employee', where: 'lang = ?', whereArgs: [employee.lang],);
      int count =list.length;
      print('count >>'+count.toString());

      if(count == 0){
      await dbClient.transaction((txn) async {
        return await txn.rawInsert(
            'INSERT INTO Employee(lang, image, dropdownItem) VALUES(' +
                '\'' +
                employee.lang +
                '\'' +
                ',' +
                '\'' +
                employee.image +
                '\'' +
                ',' +
                '\'' +
                employee.dropdownItem +
                '\'' +
                ')');
      });
      Fluttertoast.showToast(
          msg: "Data saved successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );

      }else{
      Fluttertoast.showToast(
          msg: "Data already exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
    }

  }

  Future<int> update(Employee employee) async {
    var dbClient = await db;
    List<Map> list = await dbClient!.query('Employee', where: 'lang = ?', whereArgs: [employee.lang],);
    int count =list.length;
    print('count >>'+count.toString());
    if(count ==1) {
      Fluttertoast.showToast(
          msg: "Data Updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
      return await dbClient.update(
        'Employee',
        employee.toMap(),
        where: 'lang = ?',
        whereArgs: [employee.lang],
      );

    }else{
      Fluttertoast.showToast(
          msg: "No Data exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
    }
    return count;
  }
  Future<int> delete(String lang) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'Employee',
      where: 'lang = ?',
      whereArgs: [lang],
    );
  }

  void updateEmployee(Employee employee) async {
    var dbClient = await db;
    await dbClient!.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE Employee(lang, image) VALUES(' +
              '\'' +
              employee.lang +
              '\'' +
              ',' +
              '\'' +
              employee.image +
              '\'' +
              ')'+
              '\'' +"where lang = ?"+'\'' +employee.lang );
    });
  }

  Future<List<Employee>> getEmployees(String dropdownValue) async {
    var dbClient = await db;
//    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Employee where lang');
    List<Map> list = await dbClient!.query('Employee', where: 'lang = ?', whereArgs: [dropdownValue],);
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["lang"], list[i]["image"], list[i]["dropdownItem"]));
    }
    print('length >>'+employees.length.toString());
    return employees;
  }
  Future<List<Employee>> getAllEmployees() async {
    var dbClient = await db;
//    List<Map> list = await dbClient!.rawQuery('SELECT * FROM Employee where lang');
    List<Map> list = await dbClient!.query('Employee');
    List<Employee> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Employee(list[i]["lang"], list[i]["image"], list[i]["dropdownItem"]));
    }
    print('length >>'+employees.length.toString());
    return employees;
  }
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }

}