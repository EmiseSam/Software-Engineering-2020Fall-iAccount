import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/storepages/bill_search_store.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/pages/storepages/store_create.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/widgets/input_textview_dialog_store.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List storeNames = new List();

  Future<List> _loadStoreNames() async {
    List list = await dbHelp.getStores();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.store);
    });
    print(storeNames.length);
    return listTemp;
  }

  @override
  void initState() {
    _loadStoreNames().then((value) => setState(() {
          storeNames = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "商家",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StoreCreatePage()));
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, item) {
            return buildListData(
              context,
              storeNames[item],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: (storeNames.length == null) ? 0 : storeNames.length,
        ),
      ),
    );
  }

  Widget buildListData(BuildContext context, String titleItem) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListStore(titleItem);
        }));
      },
      onLongPress: () async {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("提示"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("是否删除该商家？\n删除商家的同时也会删除相应的流水信息。")],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text("取消"),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return TextViewDialogStore(
                            confirm: (text) async {
                                var tempStore = await dbHelp.getStore(titleItem);
                                await dbHelp.updateStoreBills(tempStore, text);
                                tempStore.store = text;
                                await dbHelp.insertStore(tempStore);
                            },
                          );
                        });
                  },
                  child: Text("编辑"),
                ),
                FlatButton(
                  onPressed: () async {
                    await dbHelp.deleteStore(titleItem);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => RouterJump()),
                        ModalRoute.withName('/'));
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[Text("已经删除该商家！")],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text("确定"),
                            ),
                          ],
                        );
                      },
                    ).then((val) {
                      print(val);
                    });
                  },
                  child: Text("确定"),
                ),
              ],
            );
          },
        ).then((val) {
          print(val);
        });
      },
      leading: Icon(Icons.person),
      title: new Text(
        titleItem,
        style: TextStyle(fontSize: 18),
      ),
      trailing: new Icon(Icons.keyboard_arrow_right),
    );
  }
}
