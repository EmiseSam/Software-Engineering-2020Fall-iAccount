import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tablePassword = 'Password';
final String columnintpassword = '_integerpassword';
final String columngesture = 'gesture';
final String columnauthentication = '_authentication';

class Password {
  String integerpassword;
  List gesture;
  bool authentication;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnintpassword: integerpassword,
      columngesture: gesture,
      columnauthentication: authentication
    };
    if (integerpassword != null) {
      map[columnintpassword] = integerpassword;
    }
    if (gesture != null) {
      map[columngesture] = gesture;
    }
    return map;
  }

  Password([String password, List gestrue, bool authentication = false]) {
    this.integerpassword = password;
    this.gesture = gestrue;
    this.authentication = authentication;
  }

  Password.fromMap(Map<String, dynamic> map) {
    integerpassword = map[columnintpassword];
    gesture = map[columngesture];
    authentication = map[columnauthentication];
  }
}

class PWSqlite {
  Database db;

  openSqlite() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'PW.db');

//根据数据库文件路径和数据库版本号创建数据库表
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $tablePassword (
            $columnintpassword STRING PRIMARY KEY, 
            $columngesture LIST PRIMARY,
            $columnauthentication BOOL PRIMARY, )
          ''');
    });
  }

  // 插入新数字密码
  Future<Password> insert(Password pw) async {
    pw.integerpassword = (await db.insert(tablePassword, pw.toMap())) as String;
    return pw;
  }

  // 读取数字密码
  Future<String> loadintPassword() async {
    List<Map> maps = await db.query(tablePassword,
        columns: [columnintpassword, columngesture, columnauthentication]);

    if (maps == null || maps.length == 0) {
      return null;
    }
    var pw = Password.fromMap(maps.first);
    return pw.integerpassword;
  }

// 读取密码认证状态
  Future<bool> loadAuthentication() async {
    List<Map> maps = await db.query(tablePassword,
        columns: [columnintpassword, columngesture, columnauthentication]);

    if (maps == null || maps.length == 0) {
      return null;
    }
    var pw = Password.fromMap(maps.first);
    return pw.authentication;
  }

  // 更新密码
  Future<int> updatePW(Password pw, String key) async {
    return await db.update(tablePassword, pw.toMap(),
        where: '$columnintpassword = ?', whereArgs: [key]);
  }

  //更新密码认证状态
  Future<int> updateAT(Password pw, bool at) async {
    return await db.update(tablePassword, pw.toMap(),
        where: '$columnauthentication = ?', whereArgs: [at]);
  }

  // 记得及时关闭数据库，防止内存泄漏
  close() async {
    await db.close();
  }
}
