import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/memberpages/member_create.dart';
import 'package:i_account/pages/memberpages/bill_search_member.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/widgets/input_textview_dialog_member.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List personNames = new List();

  Future<List> _loadPersonNames() async {
    List list = await dbHelp.getMembers();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.member);
    });
    print(personNames.length);
    return listTemp;
  }

  @override
  void initState() {
    _loadPersonNames().then((value) => setState(() {
          personNames = value;
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
          "成员",
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
                  MaterialPageRoute(builder: (context) => MemberCreatePage()));
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
              personNames[item],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: (personNames.length == null) ? 0 : personNames.length,
        ),
      ),
    );
  }

  Widget buildListData(BuildContext context, String titleItem) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListPerson(titleItem);
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
                  children: <Widget>[Text("是否删除该成员？\n删除成员的同时也会删除相应的流水信息。")],
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
                          return TextViewDialogMember(
                            confirm: (text) async {
                                var tempMember = await dbHelp.getMember(titleItem);
                                await dbHelp.updateMemberBills(tempMember, text);
                                tempMember.member = text;
                                await dbHelp.insertMember(tempMember);
                            },
                          );
                        });
                  },
                  child: Text("编辑"),
                ),
                FlatButton(
                  onPressed: () async {
                    await dbHelp.deleteMember(titleItem);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[Text("已经删除该成员！")],
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
