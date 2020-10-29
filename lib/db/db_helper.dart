import 'dart:convert';
import 'dart:io';
import 'package:i_account/bill/models/bill_record_group.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/bill/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:i_account/db/column.dart';

var dbHelp = new Dbhelper();

class Dbhelper {
  // 单例
  Dbhelper._internal();

  static Dbhelper _singleton = new Dbhelper._internal();

  factory Dbhelper() => _singleton;

  Database _db;

  /// 获取数据库
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, 'AccountDb', 'Account.db');
    debugPrint(path);
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  /// When creating the db, create the table type 1支出 2收入
  void _onCreate(Database db, int version) async {
    // 账单记录表
    //是否同步 是否删除 金额、备注、类型 1支出 2收入 、 类别名、图片路径、创建时间、更新时间
    String queryBill = """
    CREATE TABLE $tableBill(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      money REAL NOT NULL,
      person TEXT,
      account TEXT,
      remark TEXT,
      categoryName TEXT NOT NULL,
      type INTEGER DEFAULT(1),
      isSync INTEGER DEFAULT(0),
      createTime TEXT,
      createTimestamp INTEGER,
      updateTime TEXT,
      updateTimestamp INTEGER
    )
    """;
    await db.execute(queryBill);

    // 支出类别表
    String queryStringExpen = """
    CREATE TABLE $tableExpenCategory(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      image TEXT,
      sort INTEGER
    )
    """;
    await db.execute(queryStringExpen);

    // 收入类别表
    String queryStringIncome = """
    CREATE TABLE $tableIncomeCategory(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      image TEXT,
      type INTEGER,
      sort INTEGER
    )
    """;
    await db.execute(queryStringIncome);

    // 初始化支出类别表数据
    rootBundle
        .loadString('assets/data/initialExpenCategory.json')
        .then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models =
          list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableExpenCategory, item.toJson());
      });
    });

    // 初始化收入类别表数据
    rootBundle
        .loadString('assets/data/initialIncomeCategory.json')
        .then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models =
          list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableIncomeCategory, item.toJson());
      });
    });
  }

  /// 获取记账支出类别列表
  Future<List> getInitialExpenCategory() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableExpenCategory ORDER BY id ASC');
    return result.toList();
  }

  /// 获取记账收入类别列表
  Future<List> getInitialIncomeCategory() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableIncomeCategory ORDER BY id ASC');
    return result.toList();
  }

  /// 获取记账支出类别列表
  Future<List> getExpenCategory() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery('SELECT * FROM $tableExpenCategory ORDER BY id ASC');
    List<CategoryItem> categorys = new List();
    for (int i = 0; i < maps.length; i++) {
      categorys.add(CategoryItem.fromMap(maps[i]));
    }
    return categorys;
  }

  /// 获取记账收入类别列表
  Future<List> getlIncomeCategory() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery('SELECT * FROM $tableIncomeCategory ORDER BY id ASC');
    List<CategoryItem> categorys = new List();
    for (int i = 0; i < maps.length; i++) {
      categorys.add(CategoryItem.fromMap(maps[i]));
    }
    return categorys;
  }

  // // 支出类别表
  //     String queryStringExpen = """
  //     CREATE TABLE $_initialExpenCategory(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT,
  //       name TEXT,
  //       image TEXT,
  //       sort INTEGER
  //     )
  //     """;
  //     await db.execute(queryStringExpen);

  //新增分类
  Future<int> insertSort(CategoryItem category, int typeofS) async {
    print('正在更新类别');
    var dbClient = await db;
    var result;
    List<Map> maps = await dbClient
        .query(tableExpenCategory, columns: ['id', 'name', 'image', 'sort']);
    List<CategoryItem> categorys = new List();
    for (int i = 0; i < maps.length; i++) {
      categorys.add(CategoryItem.fromMap(maps[i]));
    }
    List templist = new List();
    categorys.forEach((element) {
      templist.add(element.name);
    });
    if (typeofS == 1) {
      try {
        if (category.id != null) {
          result = await dbClient.update(tableExpenCategory, category.toMap(),
              where: 'id = ?', whereArgs: [category.id]);
          print('已更新分类');
        } else if (templist.contains(category.name)) {
          result = await dbClient.update(tableExpenCategory, category.toMap(),
              where: 'id = ?', whereArgs: [category.id]);
          print('已有同名分类');
        } else {
          result = await dbClient.insert(tableExpenCategory, category.toMap());
          print('成功添加分类');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      try {
        if (category.id != null) {
          result = await dbClient.update(tableIncomeCategory, category.toMap(),
              where: 'id = ?', whereArgs: [category.id]);
          print('已更新分类');
        } else if (templist.contains(category.name)) {
          result = await dbClient.update(tableIncomeCategory, category.toMap(),
              where: 'id = ?', whereArgs: [category.id]);
          print('已有同名分类');
        } else {
          result = await dbClient.insert(tableIncomeCategory, category.toMap());
          print('成功添加分类');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return result;
  }

  //删除分类
  Future<int> deleteSort(String sort, int typeofS) async {
    var dbClient = await db;
    if (sort == '其他收入' || sort == '其他支出') {
      print('此分类不可删除');
      return 0;
    }
    if (typeofS == 1) {
      print('正在删除支出分类$sort');
      return await dbClient
          .delete(tableExpenCategory, where: 'name = ?', whereArgs: [sort]);
    } else {
      print('正在删除收入分类$sort');
      return await dbClient
          .delete(tableIncomeCategory, where: 'name = ?', whereArgs: [sort]);
    }
  }

  /// 插入或者更新账单记录
  Future<int> insertBillRecord(BillRecordModel model) async {
    var dbClient = await db;
    var now = DateTime.now();
    String nowTime =
        DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch)
            .toString();
    //这里不要使用Map 声明map
    var map = {
      'money': model.money,
      'person': model.person,
      'account': model.account,
      'remark': model.remark,
      'type': model.type,
      'categoryName': model.categoryName,
      'createTime': model.createTime != null ? model.createTime : nowTime,
      'createTimestamp': model.createTimestamp != null
          ? model.createTimestamp
          : now.millisecondsSinceEpoch,
      'updateTime': model.updateTime != null ? model.updateTime : nowTime,
      'updateTimestamp': model.updateTimestamp != null
          ? model.updateTimestamp
          : now.millisecondsSinceEpoch,
    };
    var result;
    try {
      if (model.id == null) {
        result = await dbClient.insert(tableBill, map);
      } else {
        result =
            await dbClient.update(tableBill, map, where: 'id == ${model.id}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  //SELECT * FROM BillRecord WHERE DATETIME(updateTime) >= DATETIME('2019-08-29') and DATETIME(updateTime) <= DATETIME('2019-08-29 23:59')
  //SELECT * FROM BillRecord WHERE updateTimestamp >= 1567094400000 and updateTimestamp <= 1567180799999
  /// 查询账单记录 13位时间戳
  Future<BillRecordMonth> getBillRecordMonth(int startTime, int endTime) async {
    //DESC ASC
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime ORDER BY updateTimestamp ASC, id ASC");
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();
    DateTime _preTime;

    /// 当天总支出金额
    double expenMoney = 0;

    /// 当日总收入
    double incomeMoney = 0;

    /// 当月总支出金额
    double monthExpenMoney = 0;

    /// 当月总收入
    double monthIncomeMoney = 0;

    /// 账单记录
    List recordLsit = List();

    /// 账单记录
    List<BillRecordModel> itemList = List();

    void addAction(BillRecordModel item) {
      itemList.insert(0, item);
      if (item.type == 1) {
        // 支出
        expenMoney += item.money;
      } else {
        incomeMoney += item.money;
      }
    }

    void buildGroup() {
      recordLsit.insertAll(0, itemList);
      DateTime time =
          DateTime.fromMillisecondsSinceEpoch(itemList.first.updateTimestamp);
      String groupDate =
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
      BillRecordGroup group =
          BillRecordGroup(groupDate, expenMoney, incomeMoney);
      recordLsit.insert(0, group);

      // 计算月份金额
      monthExpenMoney += expenMoney;
      monthIncomeMoney += incomeMoney;

      // 清除重构
      expenMoney = 0;
      incomeMoney = 0;
      itemList = List();
    }

    int length = models.length;

    List.generate(length, (index) {
      BillRecordModel item = models[index];
      //格式化时间戳
      if (_preTime == null) {
        _preTime = DateTime.fromMillisecondsSinceEpoch(item.updateTimestamp);
        addAction(item);
        if (length == 1) {
          buildGroup();
        }
      } else {
        // 存在两条或以上数
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(item.updateTimestamp);
        //判断账单是不是在同一天
        if (time.year == _preTime.year &&
            time.month == _preTime.month &&
            time.day == _preTime.day) {
          //如果是同一天
          addAction(item);
          if (index == length - 1) {
            //这是最后一条数据
            buildGroup();
          }
        } else {
          //如果不是同一天 这条数据是某一条的第一条 构建上一条的组
          buildGroup();
          addAction(item);
          if (index == length - 1) {
            //这是最后一条数据
            buildGroup();
          }
        }
        _preTime = time;
      }
    });

    return BillRecordMonth(monthExpenMoney, monthIncomeMoney, recordLsit);
  }

  /// 查询账单记录 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillList(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and categoryName = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单记录 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListType(
    int startTime,
    int endTime,
    int myType,
  ) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    result = await dbClient.rawQuery(
        "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and type = '$myType' and updateTimestamp <= $endTime");
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单记录账户版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListAccount(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and account = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单记录账户版带类型 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListAccountWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and type = '$myType' and account = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单记录成员版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListPerson(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and person = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单记录成员版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListPersonWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and type = '$myType' and person = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  /// 查询账单
  Future<BillRecordModel> queryBillRecord(int id) async {
    if (id == null) {
      return null;
    }
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableBill WHERE id == $id LIMIT 1');
    var list = result.toList();
    if (list.length > 0) {
      return BillRecordModel.fromJson(list.first);
    } else {
      return null;
    }
  }

  /// 删除账单
  Future<int> deleteBillRecord(int id) async {
    if (id == null) {
      return null;
    }
    var dbClient = await db;
    //UPDATE BillRecord SET money = 123 WHERE id = 42
    return await dbClient.delete(tableBill, where: 'id = ?', whereArgs: [id]);
  }

  ///删除账户的同时删除所有相关账单
  Future<int> deleteAccountBills(String account) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableBill, where: 'account = ?', whereArgs: [account]);
  }

  ///删除成员的同时修改所有相关账单
  Future<int> deleteMemberBills(String person) async {
    var dbClient = await db;
    print('$person');
    var maps = await dbClient
        .rawQuery('SELECT * FROM $tableBill WHERE person = ?', [person]);
    List<BillRecordModel> bills = new List();
    for (var i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    print(bills.length);
    for (var i = 0; i < bills.length; i++) {
      bills[i].person = '';
      await dbClient.update(tableBill, bills[i].toMap(),
          where: 'id = ?', whereArgs: [bills[i].id]);
    }
    print('test01 正在更新成员账单');
    return bills.length;
  }

  /// 查询账单记录分类版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListCategoryWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime and type = '$myType' and categoryName = '$categoryName'  ORDER BY updateTimestamp ASC, id ASC");
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE updateTimestamp >= $startTime and updateTimestamp <= $endTime");
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromJson(i)).toList();

    return models;
  }

  ///删除类别的同时修改所有相关账单
  Future<int> deleteSortBills(String sort, int typeofS) async {
    var dbClient = await db;
    if (typeofS == 1) {
      var maps = await dbClient
          .rawQuery('SELECT * FROM $tableBill WHERE categoryName = ?', [sort]);
      List<BillRecordModel> bills = new List();
      for (var i = 0; i < maps.length; i++) {
        bills.add(BillRecordModel.fromMap(maps[i]));
      }
      for (var i = 0; i < bills.length; i++) {
        bills[i].categoryName = '其他支出';
        await dbClient.update(tableBill, bills[i].toMap(),
            where: 'id = ?', whereArgs: [bills[i].id]);
      }
      print('正在更新支出类别账单');
      return bills.length;
    } else {
      var maps = await dbClient
          .rawQuery('SELECT * FROM $tableBill WHERE categoryName = ?', [sort]);
      List<BillRecordModel> bills = new List();
      for (var i = 0; i < maps.length; i++) {
        bills.add(BillRecordModel.fromMap(maps[i]));
      }
      for (var i = 0; i < bills.length; i++) {
        bills[i].categoryName = '其他收入';
        await dbClient.update(tableBill, bills[i].toMap(),
            where: 'id = ?', whereArgs: [bills[i].id]);
      }
      print('正在更新收入类别账单');
      return bills.length;
    }
  }
}
