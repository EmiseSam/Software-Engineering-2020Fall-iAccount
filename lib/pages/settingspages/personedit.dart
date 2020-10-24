import 'package:i_account/db/member.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:i_account/widgets/input_textview_dialog_person.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/db/db_helper_demo.dart';

class PersonEdit extends StatefulWidget {
  @override
  _PersonEditState createState() => _PersonEditState();
}

class _PersonEditState extends State<PersonEdit> {

  DBHelper dbHelper = new DBHelper();
  List _personData;

  @override
  void initState() {
    super.initState();
    initData();
    //读数据
  }

   void initData() async{

  }



  List<Map> _list = List<Map>.generate(
    10,
    (i) => {'title': 'tittle'},
  );


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar:AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //修改颜色
        ),
        centerTitle: true,
        title: Text('成员管理', style: TextStyle(fontSize: 18, color: Colours.app_main, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return TextViewDialog(
                      confirm: (text) {
                        setState(() {
                          _list.add({'title': '$text'});
                        });
                      },
                    );
                  });
            },
            icon: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _bodybuild(),
    );
  }

  Widget _bodybuild(){
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _list[index];
        return Dismissible(
          key: Key(item.toString()),
          dragStartBehavior: DragStartBehavior.down,
          direction: DismissDirection.endToStart,
          background: Container(color: Colors.red),
          child: ListTile(
            onTap: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return TextViewDialog(
                      confirm: (text) {
                        setState(() {
                          item['title'] = text;
                        });
                      },
                    );
                  });
            },
            title: Text(item['title']),
          ),
          onDismissed: (direction) {
            setState(() {
              _list.removeAt(index);
              print(_list.length);
            });
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('删除成功...'),
            ));
          },
        );
      },
    );
  }
}
