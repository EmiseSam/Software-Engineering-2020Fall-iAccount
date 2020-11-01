import 'dart:convert';
import 'dart:io';
import 'package:i_account/bill/models/bill_record_group.dart';
import 'package:i_account/bill/models/bill_record_response.dart';
import 'package:i_account/bill/models/category_model.dart';
import 'package:i_account/bill/models/account_model.dart';
import 'package:i_account/bill/models/member_model.dart';
import 'package:i_account/bill/models/project_model.dart';
import 'package:i_account/bill/models/store_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:i_account/db/column.dart';

var dbHelp = new Dbhelper();

class Dbhelper {
  /// 单例
  Dbhelper._internal();

  static Dbhelper _singleton = new Dbhelper._internal();

  factory Dbhelper() => _singleton;

  Database _db;

  /// 获取数据库
  Future<Database> get db async {
    if (_db != null) {
      print("成功获取账单数据库");
      return _db;
    }
    _db = await _initDb();
    print("成功创建账单数据库");
    return _db;
  }

  _initDb() async {
    Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, 'iAccountBillDb', 'iAccountBill.db');
    debugPrint(path);
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  /// When creating the db, create the table type 1支出 2收入
  void _onCreate(Database db, int version) async {
    /// 账单记录表
    ///id 金额 成员 账户 备注 一级分类 二级分类 账单类型（1是支出） 创建时间 更新时间
    String queryBill = """
    CREATE TABLE $tableBill(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnMoney REAL NOT NULL,
      $columnMember TEXT,
      $columnAccount TEXT,
      $columnRemark TEXT,
      $columnClassification1 TEXT NOT NULL,
      $columnClassification2 TEXT,
      $columnProject TEXT,
      $columnStore TEXT,
      $columntypeofB INTEGER DEFAULT(1),
      $columnCreateTime TEXT,
      $columnCreateTimestamp INTEGER,
      $columnUpdateTime TEXT,
      $columnUpdateTimestamp INTEGER
    )
    """;
    await db.execute(queryBill);

    /// 支出类别表
    String queryStringExpen = """
    CREATE TABLE $tableExpenCategory(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnClassification1 TEXT NOT NULL,
      $columnClassification2 TEXT
    )
    """;
    await db.execute(queryStringExpen);

    /// 收入类别表
    String queryStringIncome = """
    CREATE TABLE $tableIncomeCategory(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnClassification1 TEXT NOT NULL,
      $columnClassification2 TEXT
    )
    """;
    await db.execute(queryStringIncome);

    ///账户表
    String queryStringAccount = """
    CREATE TABLE $tableAccount(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnAccount TEXT NOT NULL,
      $columnMoney REAL,
      $columnBalance REAL,
      $columntypeofA INTEGER
    )
    """;
    await db.execute(queryStringAccount);

    ///成员表
    String queryStringMember = """
    CREATE TABLE $tableMember(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnMember TEXT NOT NULL
    )
    """;
    await db.execute(queryStringMember);

    ///项目表
    String queryStringProject = """
    CREATE TABLE $tableProject(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnProject TEXT NOT NULL
    )
    """;
    await db.execute(queryStringProject);

    ///商家表
    String queryStringStore = """
    CREATE TABLE $tableStore(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnStore TEXT NOT NULL
    )
    """;
    await db.execute(queryStringStore);

    /// 初始化账户表数据
    rootBundle.loadString('assets/data/initialAccount.json').then((value) {
      List list = jsonDecode(value);
      List<AccountClassification> models =
          list.map((i) => AccountClassification.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableAccount, item.toJson());
        print(item.account);
      });
    });

    /// 初始化成员表数据
    rootBundle.loadString('assets/data/initialMember.json').then((value) {
      List list = jsonDecode(value);
      List<Member> models = list.map((i) => Member.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableMember, item.toJson());
        print(item.member);
      });
    });

    /// 初始化项目表数据
    rootBundle.loadString('assets/data/initialProject.json').then((value) {
      List list = jsonDecode(value);
      List<Project> models = list.map((i) => Project.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableProject, item.toJson());
        print(item.project);
      });
    });

    /// 初始化商家表数据
    rootBundle.loadString('assets/data/initialStore.json').then((value) {
      List list = jsonDecode(value);
      List<Store> models = list.map((i) => Store.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableStore, item.toJson());
        print(item.store);
      });
    });

    /// 初始化支出类别表数据
    rootBundle
        .loadString('assets/data/initialExpenCategory.json')
        .then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models =
          list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableExpenCategory, item.toJson());
        print(item.classification1 + item.classification2);
      });
    });

    /// 初始化收入类别表数据
    rootBundle
        .loadString('assets/data/initialIncomeCategory.json')
        .then((value) {
      List list = jsonDecode(value);
      List<CategoryItem> models =
          list.map((i) => CategoryItem.fromJson(i)).toList();
      models.forEach((item) async {
        await db.insert(tableIncomeCategory, item.toJson());
        print(item.classification1 + item.classification2);
      });
    });
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
      columnMoney: model.money,
      columnMember: model.member,
      columnAccount: model.account,
      columnRemark: model.remark,
      columntypeofB: model.typeofB,
      columnClassification1: model.classification1,
      columnClassification2: model.classification2,
      columnProject: model.project,
      columnStore: model.store,
      columnCreateTime: model.createTime != null ? model.createTime : nowTime,
      columnCreateTimestamp: model.createTimestamp != null
          ? model.createTimestamp
          : now.millisecondsSinceEpoch,
      columnUpdateTime: model.updateTime != null ? model.updateTime : nowTime,
      columnUpdateTimestamp: model.updateTimestamp != null
          ? model.updateTimestamp
          : now.millisecondsSinceEpoch,
    };
    var result;
    try {
      if (model.id == null) {
        result = await dbClient.insert(tableBill, map);
      } else {
        result = await dbClient.update(tableBill, map,
            where: '$columnId == ${model.id}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    print("成功更新账单");
    return result;
  }

  //SELECT * FROM BillRecord WHERE DATETIME(updateTime) >= DATETIME('2019-08-29') and DATETIME(updateTime) <= DATETIME('2019-08-29 23:59')
  //SELECT * FROM BillRecord WHERE updateTimestamp >= 1567094400000 and updateTimestamp <= 1567180799999
  /// 查询账单记录 13位时间戳
  Future<BillRecordMonth> getBillRecordMonth(int startTime, int endTime) async {
    //DESC ASC
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
        [startTime, endTime]);
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();
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
    List recordList = List();

    /// 账单记录
    List<BillRecordModel> itemList = List();

    void addAction(BillRecordModel item) {
      itemList.insert(0, item);
      if (item.typeofB == 1) {
        // 支出
        expenMoney += item.money;
      } else {
        incomeMoney += item.money;
      }
    }

    void buildGroup() {
      recordList.insertAll(0, itemList);
      DateTime time =
          DateTime.fromMillisecondsSinceEpoch(itemList.first.updateTimestamp);
      String groupDate =
          '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
      BillRecordGroup group =
          BillRecordGroup(groupDate, expenMoney, incomeMoney);
      recordList.insert(0, group);

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
    return BillRecordMonth(monthExpenMoney, monthIncomeMoney, recordList);
  }

  /// 查询账单记录 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillList(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columnClassification1 = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

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
        "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columntypeofB = ? and $columnUpdateTimestamp <= ?",
        [startTime, myType, endTime]);
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

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
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columnAccount = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

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
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columntypeofB = ? and $columnAccount = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, myType, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录成员版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListMember(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columnMember = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录项目版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListProject(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columnProject = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
    list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录商家版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListStore(int startTime, int endTime,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columnStore = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
    list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录成员版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListMemberWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columntypeofB = ? and $columnMember = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, myType, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录项目版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListProjectWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columntypeofB = ? and $columnProject = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, myType, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
    list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单记录商家版 13位时间戳 type类型 1支出 2收入
  Future<List<BillRecordModel>> getBillListStoreWithType(
      int startTime, int endTime, int myType,
      {String categoryName}) async {
    //DESC ASC
    var dbClient = await db;
    var result;
    if (categoryName != null) {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columntypeofB = ? and $columnStore = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, myType, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
    list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  /// 查询账单
  Future<BillRecordModel> queryBillRecord(int id) async {
    if (id == null) {
      return null;
    }
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $tableBill WHERE $columnId = ?', [id]);
    var list = result.toList();
    if (list.length > 0) {
      return BillRecordModel.fromMap(list.first);
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
    return await dbClient
        .delete(tableBill, where: '$columnId = ?', whereArgs: [id]);
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
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ? and $columntypeofB = ? and $columnClassification1 = ?  ORDER BY $columnUpdateTimestamp ASC, $columnId ASC",
          [startTime, endTime, myType, categoryName]);
    } else {
      result = await dbClient.rawQuery(
          "SELECT * FROM $tableBill WHERE $columnUpdateTimestamp >= ? and $columnUpdateTimestamp <= ?",
          [startTime, endTime]);
    }
    List list = result.toList();
    List<BillRecordModel> models =
        list.map((i) => BillRecordModel.fromMap(i)).toList();

    return models;
  }

  ///获取初始化表
  Future<List> getInitialExpenCategory() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery('SELECT * FROM $tableExpenCategory ORDER BY $columnId ASC');
    return maps.toList();
  }

  ///获取初始化表
  Future<List> getInitialIncomeCategory() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery('SELECT * FROM $tableIncomeCategory ORDER BY $columnId ASC');
    return maps.toList();
  }

  /// 获取一级分类id
  Future<CategoryItem> getCategoryid1(
      String classification1, int typeofC) async {
    var dbClient = await db;
    if (typeofC == 1) {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableExpenCategory WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
          [classification1]);
      CategoryItem category = CategoryItem.fromMap(maps.first);
      category.classification2 = null;
      return category;
    } else {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableIncomeCategory WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
          [classification1]);
      CategoryItem category = CategoryItem.fromMap(maps.first);
      category.classification2 = null;
      return category;
    }
  }

  /// 获取二级分类id
  Future<CategoryItem> getCategoryid2(
      String classification2, int typeofC) async {
    var dbClient = await db;
    if (typeofC == 1) {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableExpenCategory WHERE $columnClassification2 = ? ORDER BY $columnId ASC',
          [classification2]);
      CategoryItem category = CategoryItem.fromMap(maps.first);
      return category;
    } else {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableIncomeCategory WHERE $columnClassification2 = ? ORDER BY $columnId ASC',
          [classification2]);
      CategoryItem category = CategoryItem.fromMap(maps.first);
      return category;
    }
  }

  /// 获取分类表
  Future<List> getCategories(int typeofC, [String classification1]) async {
    var dbClient = await db;
    if (typeofC == 1) {
      if (classification1 != null) {
        var maps = await dbClient.rawQuery(
            'SELECT * FROM $tableExpenCategory WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
            [classification1]);
        List<CategoryItem> categories = new List();
        for (int i = 0; i < maps.length; i++) {
          categories.add(CategoryItem.fromMap(maps[i]));
        }
        List tempList = new List();
        categories.forEach((element) {
          if (!tempList.contains(element.classification2)) {
            tempList.add(element.classification2);
          }
        });
        print("成功获取支出二级分类表");
        print(tempList);
        return tempList;
      } else {
        var maps = await dbClient.rawQuery(
            'SELECT * FROM $tableExpenCategory ORDER BY $columnId ASC');
        List<CategoryItem> categories = new List();
        for (int i = 0; i < maps.length; i++) {
          categories.add(CategoryItem.fromMap(maps[i]));
        }
        List tempList = new List();
        categories.forEach((element) {
          if (!tempList.contains(element.classification1)) {
            tempList.add(element.classification1);
          }
        });
        print("成功获取支出一级分类表");
        print(tempList);
        return tempList;
      }
    } else {
      if (classification1 != null) {
        var maps = await dbClient.rawQuery(
            'SELECT * FROM $tableIncomeCategory WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
            [classification1]);
        List<CategoryItem> categories = new List();
        for (int i = 0; i < maps.length; i++) {
          categories.add(CategoryItem.fromMap(maps[i]));
        }
        List tempList = new List();
        categories.forEach((element) {
          if (!tempList.contains(element.classification2)) {
            tempList.add(element.classification2);
          }
        });
        print("成功获取收入二级分类表");
        print(tempList);
        return tempList;
      } else {
        var maps = await dbClient.rawQuery(
            'SELECT * FROM $tableIncomeCategory ORDER BY $columnId ASC');
        List<CategoryItem> categories = new List();
        for (int i = 0; i < maps.length; i++) {
          categories.add(CategoryItem.fromMap(maps[i]));
        }
        List tempList = new List();
        categories.forEach((element) {
          if (!tempList.contains(element.classification1)) {
            tempList.add(element.classification1);
          }
        });
        print("成功获取收入一级分类表");
        print(tempList);
        return tempList;
      }
    }
  }

  ///新增或者更新分类
  Future<int> insertCategory(CategoryItem category, int typeofC,
      [String newcategory]) async {
    var dbClient = await db;
    var result;
    if (category.classification2 != null) {
      List tempList =
          await this.getCategories(typeofC, category.classification1);
      try {
        if (category.id != null &&
            !tempList.contains(category.classification2)) {
          result = await dbClient.update(
              typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
              category.toMap(),
              where: '$columnId = ?',
              whereArgs: [category.id]);
          print('已更新二级分类${category.classification2}');
        } else if (!tempList.contains(category.classification2)) {
          result = await dbClient.insert(
              typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
              category.toMap());
          print('已新增二级分类${category.classification2}');
        } else {
          result = -1;
          print('已有同名二级分类${category.classification2}');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    } else {
      List tempList = await this.getCategories(typeofC);
      try {
        if (category.id != null && !tempList.contains(newcategory)) {
          var maps = await dbClient.rawQuery(
              'SELECT * FROM ${typeofC == 1 ? tableExpenCategory : tableIncomeCategory} WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
              [category.classification1]);
          List<CategoryItem> categories = new List();
          for (int i = 0; i < maps.length; i++) {
            categories.add(CategoryItem.fromMap(maps[i]));
          }
          categories.forEach((element) async {
            element.classification1 = newcategory;
            print(element.classification1);
            await dbClient.update(
                typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
                element.toMap(),
                where: '$columnId = ?',
                whereArgs: [element.id]);
          });
          print('已更新一级分类${category.classification1}');
        } else if (!tempList.contains(category.classification1)) {
          result = await dbClient.insert(
              typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
              category.toMap());
          print('已新增一级分类${category.classification1}');
        } else {
          result = -1;
          print('已有同名一级分类${category.classification1}');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    }
  }

  ///删除分类
  Future<int> deleteCategory(CategoryItem category, int typeofC) async {
    var dbClient = await db;
    var result;
    if (category.classification2 != null) {
      try {
        await dbClient.delete(
            typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
            where: '$columnClassification2 = ?',
            whereArgs: [category.classification2]);
        print('已删除二级分类');
        result = await this.deleteCategoryBills(category, typeofC);
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    } else {
      try {
        await dbClient.delete(
            typeofC == 1 ? tableExpenCategory : tableIncomeCategory,
            where: '$columnClassification1 = ?',
            whereArgs: [category.classification1]);
        print('已删除一级分类');
        result = await this.deleteCategoryBills(category, typeofC);
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    }
  }

  ///删除类别的同时修改所有相关账单
  Future<int> deleteCategoryBills(CategoryItem category, int typeofC) async {
    var dbClient = await db;
    var result;
    if (category.classification2 != null) {
      try {
        result = await dbClient.delete(tableBill,
            where: '$columnClassification2 = ? AND $columntypeofB = ?',
            whereArgs: [category.classification2, typeofC]);
        print('已删除二级分类相关账单');
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    } else {
      try {
        result = await dbClient.delete(tableBill,
            where: '$columnClassification1 = ? AND $columntypeofB = ?',
            whereArgs: [category.classification1, typeofC]);
        print('已删除一级分类相关账单');
      } catch (e) {
        debugPrint(e.toString());
      }
      return result;
    }
  }

  ///修改类别的同时修改所有相关账单
  Future<int> updateCategoryBills(
      CategoryItem category, String newCategory, int typeofC) async {
    var dbClient = await db;
    if (category.classification2 != null) {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableBill WHERE $columnClassification2 = ? ORDER BY $columnId ASC',
          [category.classification2]);
      List<BillRecordModel> bills = new List();
      for (int i = 0; i < maps.length; i++) {
        bills.add(BillRecordModel.fromMap(maps[i]));
      }
      bills.forEach((element) async {
        element.classification2 = newCategory;
        await dbClient.update(tableBill, element.toMap(),
            where: '$columnId = ?', whereArgs: [element.id]);
      });
      return bills.length;
    } else {
      var maps = await dbClient.rawQuery(
          'SELECT * FROM $tableBill WHERE $columnClassification1 = ? ORDER BY $columnId ASC',
          [category.classification1]);
      List<BillRecordModel> bills = new List();
      for (int i = 0; i < maps.length; i++) {
        bills.add(BillRecordModel.fromMap(maps[i]));
      }
      bills.forEach((element) async {
        element.classification1 = newCategory;
        await dbClient.update(tableBill, element.toMap(),
            where: '$columnId = ?', whereArgs: [element.id]);
      });
      return bills.length;
    }
  }

  ///插入或者更新账户（已完成）
  Future<int> insertAccount(AccountClassification ac) async {
    var dbClient = await db;
    var result;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableAccount ORDER BY $columnId ASC");
    List<AccountClassification> accounts = new List();
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    List templist = new List();
    accounts.forEach((element) {
      templist.add(element.account);
    });
    try {
      if (ac.id != null && !templist.contains(ac.account)) {
        result = await dbClient.update(tableAccount, ac.toMap(),
            where: '$columnId = ?', whereArgs: [ac.id]);
      } else if (!templist.contains(ac.account)) {
        result = await dbClient.insert(tableAccount, ac.toMap());
        print('成功添加账户');
      } else {
        result = -1;
        print('已有同名账户');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    print('已更新账户');
    print(result);
    return result;
  }

  ///删除账户（已完成）
  Future<int> deleteAccount(String account) async {
    var dbClient = await db;
    await dbClient.delete(tableAccount,
        where: '$columnAccount = ?', whereArgs: [account]);
    print('已删除账户');
    var result = await dbClient
        .delete(tableBill, where: '$columnAccount = ?', whereArgs: [account]);
    print('已删除该账户其下账单');
    return result;
  }

  ///获取单个用户
  Future<AccountClassification> getAccount(String acname) async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableAccount ORDER BY $columnId ASC");
    AccountClassification account = AccountClassification.fromMap(maps.first);
    print('已获取账户');
    return account;
  }

  ///获取账户列表（已完成）
  Future<List> getAccountList() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableAccount ORDER BY $columnId ASC");
    List<AccountClassification> accounts = new List();
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    accounts.forEach((element) async {
      await this.getAccountBalance(element.account);
    });
    print('已获取所有账户列表');
    print(accounts.length);
    return accounts;
  }

  ///获取某一种类的账户列表
  Future<List> getAccounts(int typeofA) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableAccount WHERE $columntypeofA = ? ORDER BY $columnId ASC",
        [typeofA]);
    List<AccountClassification> accounts = new List();
    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
      print(accounts[i].account);
    }
    accounts.forEach((element) async {
      print('test' + element.balance.toString());
      await this.getAccountBalance(element.account);
    });
    print('已获取$typeofA 类账户');
    print(accounts.length);
    return accounts;
  }

  ///查询单个账户的余额（已完成）
  Future<double> getAccountBalance(String accountName) async {
    var dbClient = await db;
    var map = await dbClient.rawQuery(
        "SELECT * FROM $tableAccount WHERE $columnAccount = ? ORDER BY $columnId ASC",
        [accountName]);
    AccountClassification account = AccountClassification.fromMap(map.first);
    account.balance = account.sum;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableBill WHERE $columnAccount = ? ORDER BY $columnId ASC",
        [accountName]);
    List<BillRecordModel> bills = new List();
    for (var i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    if (account.typeofA == 0) {
      bills.forEach((element) {
        if (element.typeofB == 1) {
          account.balance -= element.money;
        } else {
          account.balance += element.money;
        }
      });
    } else {
      bills.forEach((element) {
        if (element.typeofB == 1) {
          account.balance += element.money;
        } else {
          account.balance -= element.money;
        }
      });
    }
    await dbClient.update(tableAccount, account.toMap(),
        where: '$columnId = ?', whereArgs: [account.id]);
    print('已查询$accountName 的余额');
    print(account.balance);
    return account.balance;
  }

  ///计算单类资产
  Future<double> accountsTotalize(int typeofA) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableAccount WHERE $columntypeofA = ? ORDER BY $columnId ASC",
        [typeofA]);
    List<AccountClassification> accounts = new List();

    for (int i = 0; i < maps.length; i++) {
      accounts.add(AccountClassification.fromMap(maps[i]));
    }
    double money = 0;
    accounts.forEach((element) {
      money += element.balance;
    });
    print('已计算$typeofA 类账户总额');
    print(money);
    return money;
  }

  ///修改账户的同时修改其下所有账单
  Future<int> updateAccountBills(
      AccountClassification preAccount, String newAccount) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        'SELECT * FROM $tableBill WHERE $columnAccount = ? ORDER BY $columnId ASC',
        [preAccount.account]);
    List<BillRecordModel> bills = new List();
    for (int i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    bills.forEach((element) async {
      element.account = newAccount;
      await dbClient.update(tableBill, element.toMap(),
          where: '$columnId = ?', whereArgs: [element.id]);
    });
    return bills.length;
  }

  ///获取单个成员
  Future<Member> getMember(String mname) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableMember WHERE $columnMember = ? ORDER BY $columnId ASC",
        [mname]);
    Member member = Member.fromMap(maps.first);
    print('已获取成员{$mname}');
    return member;
  }

  ///获取成员列表
  Future<List> getMembers() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableMember ORDER BY $columnId ASC");
    List<Member> members = new List();
    for (int i = 0; i < maps.length; i++) {
      members.add(Member.fromMap(maps[i]));
    }
    print('已获取所有成员列表');
    print(members.length);
    return members;
  }

  ///插入或者更新成员
  Future<int> insertMember(Member member) async {
    var dbClient = await db;
    var result;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableMember ORDER BY $columnId ASC");
    List<Member> members = new List();
    for (int i = 0; i < maps.length; i++) {
      members.add(Member.fromMap(maps[i]));
    }
    List templist = new List();
    members.forEach((element) {
      templist.add(element.member);
    });
    try {
      if (member.id != null && !templist.contains(member.member)) {
        result = await dbClient.update(tableMember, member.toMap(),
            where: '$columnId = ?', whereArgs: [member.id]);
        print('已更新成员${member.member}');
      } else if (!templist.contains(member.member)) {
        result = await dbClient.insert(tableMember, member.toMap());
        print('已成功添加成员${member.member}');
      } else {
        result = -1;
        print('已有同名成员${member.member}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  ///删除成员
  Future<int> deleteMember(String member) async {
    var dbClient = await db;
    print(member);
    await dbClient
        .delete(tableMember, where: '$columnMember = ?', whereArgs: [member]);
    print('已删除成员$member');
    var result = await dbClient
        .delete(tableBill, where: '$columnMember = ?', whereArgs: [member]);
    print('已删除该成员其下账单');
    return result;
  }

  ///修改成员的同时修改其下所有账单
  Future<int> updateMemberBills(Member preMember, String newMember) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        'SELECT * FROM $tableBill WHERE $columnMember = ? ORDER BY $columnId ASC',
        [preMember.member]);
    List<BillRecordModel> bills = new List();
    for (int i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    bills.forEach((element) async {
      element.member = newMember;
      await dbClient.update(tableBill, element.toMap(),
          where: '$columnId = ?', whereArgs: [element.id]);
    });
    return bills.length;
  }

  ///获取单个项目
  Future<Project> getProject(String pname) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableProject WHERE $columnProject = ? ORDER BY $columnId ASC",
        [pname]);
    Project project = Project.fromMap(maps.first);
    print('已获取项目{$pname}');
    return project;
  }

  ///获取项目列表
  Future<List> getProjects() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableProject ORDER BY $columnId ASC");
    List<Project> projects = new List();
    for (int i = 0; i < maps.length; i++) {
      projects.add(Project.fromMap(maps[i]));
    }
    print('已获取所有项目列表');
    print(projects.length);
    return projects;
  }

  ///插入或者更新项目
  Future<int> insertProject(Project project) async {
    var dbClient = await db;
    var result;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableProject ORDER BY $columnId ASC");
    List<Project> projects = new List();
    for (int i = 0; i < maps.length; i++) {
      projects.add(Project.fromMap(maps[i]));
    }
    List templist = new List();
    projects.forEach((element) {
      templist.add(element.project);
    });
    try {
      if (project.id != null && !templist.contains(project.project)) {
        result = await dbClient.update(tableProject, project.toMap(),
            where: '$columnId = ?', whereArgs: [project.id]);
        print('已更新项目${project.project}');
      } else if (!templist.contains(project.project)) {
        result = await dbClient.insert(tableProject, project.toMap());
        print('已成功添加项目${project.project}');
      } else {
        result = -1;
        print('已有同名项目${project.project}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  ///删除项目
  Future<int> deleteProject(String project) async {
    var dbClient = await db;
    await dbClient.delete(tableProject,
        where: '$columnProject = ?', whereArgs: [project]);
    print('已删除项目$project');
    var result = await dbClient
        .delete(tableBill, where: '$columnProject = ?', whereArgs: [project]);
    print('已删除该项目其下账单');
    return result;
  }

  ///修改项目的同时修改其下所有账单
  Future<int> updateProjectBills(Project preProject, String newProject) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        'SELECT * FROM $tableBill WHERE $columnProject = ? ORDER BY $columnId ASC',
        [preProject.project]);
    List<BillRecordModel> bills = new List();
    for (int i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    bills.forEach((element) async {
      element.project = newProject;
      await dbClient.update(tableBill, element.toMap(),
          where: '$columnId = ?', whereArgs: [element.id]);
    });
    return bills.length;
  }

  ///获取单个商家
  Future<Store> getStore(String storeName) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        "SELECT * FROM $tableStore WHERE $columnStore = ? ORDER BY $columnId ASC",
        [storeName]);
    Store project = Store.fromMap(maps.first);
    print('已获取商家{$storeName}');
    return project;
  }

  ///获取商家列表
  Future<List> getStores() async {
    var dbClient = await db;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableStore ORDER BY $columnId ASC");
    List<Store> stores = new List();
    for (int i = 0; i < maps.length; i++) {
      stores.add(Store.fromMap(maps[i]));
    }
    print('已获取所有商家列表');
    print(stores.length);
    return stores;
  }

  ///插入或者更新商家
  Future<int> insertStore(Store store) async {
    var dbClient = await db;
    var result;
    var maps = await dbClient
        .rawQuery("SELECT * FROM $tableStore ORDER BY $columnId ASC");
    List<Store> stores = new List();
    for (int i = 0; i < maps.length; i++) {
      stores.add(Store.fromMap(maps[i]));
    }
    List templist = new List();
    stores.forEach((element) {
      templist.add(element.store);
    });
    try {
      if (store.id != null && !templist.contains(store.store)) {
        result = await dbClient.update(tableStore, store.toMap(),
            where: '$columnId = ?', whereArgs: [store.id]);
        print('已更新商家${store.store}');
      } else if (!templist.contains(store.store)) {
        result = await dbClient.insert(tableStore, store.toMap());
        print('已成功添加商家${store.store}');
      } else {
        result = -1;
        print('已有同名商家${store.store}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  ///删除商家
  Future<int> deleteStore(String store) async {
    var dbClient = await db;
    await dbClient
        .delete(tableStore, where: '$columnStore = ?', whereArgs: [store]);
    print('已删除商家$store');
    var result = await dbClient
        .delete(tableBill, where: '$columnStore = ?', whereArgs: [store]);
    print('已删除该商家其下账单');
    return result;
  }

  ///修改商家的同时修改其下所有账单
  Future<int> updateStoreBills(Store preStore, String newStore) async {
    var dbClient = await db;
    var maps = await dbClient.rawQuery(
        'SELECT * FROM $tableBill WHERE $columnStore = ? ORDER BY $columnId ASC',
        [preStore.store]);
    List<BillRecordModel> bills = new List();
    for (int i = 0; i < maps.length; i++) {
      bills.add(BillRecordModel.fromMap(maps[i]));
    }
    bills.forEach((element) async {
      element.project = newStore;
      await dbClient.update(tableBill, element.toMap(),
          where: '$columnId = ?', whereArgs: [element.id]);
    });
    return bills.length;
  }
}
