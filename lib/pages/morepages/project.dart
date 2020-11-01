import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_account/pages/projectpages/bill_search_project.dart';
import 'package:i_account/db/db_helper.dart';
import 'package:i_account/pages/projectpages/project_create.dart';
import 'package:i_account/router_jump.dart';
import 'package:i_account/widgets/input_textview_dialog_project.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List projectNames = new List();

  Future<List> _loadProjectNames() async {
    List list = await dbHelp.getProjects();
    List listTemp = new List();
    list.forEach((element) {
      listTemp.add(element.project);
    });
    print(projectNames.length);
    return listTemp;
  }

  @override
  void initState() {
    _loadProjectNames().then((value) => setState(() {
          projectNames = value;
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
          "项目",
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
                  MaterialPageRoute(builder: (context) => ProjectCreatePage()));
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
              projectNames[item],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: (projectNames.length == null) ? 0 : projectNames.length,
        ),
      ),
    );
  }

  Widget buildListData(BuildContext context, String titleItem) {
    return new ListTile(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return BillSearchListProject(titleItem);
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
                  children: <Widget>[Text("是否删除该项目？\n删除商家的同时也会删除相应的流水信息。")],
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
                          return TextViewDialogProject(
                            confirm: (text) async {
                                var tempProject = await dbHelp.getProject(titleItem);
                                await dbHelp.updateProjectBills(tempProject, text);
                                tempProject.project = text;
                                await dbHelp.insertProject(tempProject);
                            },
                          );
                        });
                  },
                  child: Text("编辑"),
                ),
                FlatButton(
                  onPressed: () async {
                    await dbHelp.deleteProject(titleItem);
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
                              children: <Widget>[Text("已经删除该项目！")],
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
