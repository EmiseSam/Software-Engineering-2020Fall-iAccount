import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/styles.dart';
import '../routers/fluro_navigator.dart';
import 'highlight_well.dart';
import 'package:i_account/router_jump.dart';

typedef void Confirm(String text);

class TextViewDialogCategory extends StatefulWidget {
  const TextViewDialogCategory({Key key, this.confirm}) : super(key: key);
  final Confirm confirm;

  @override
  State<StatefulWidget> createState() {
    return _TextViewDialogCategoryState();
  }
}

class _TextViewDialogCategoryState extends State<TextViewDialogCategory> {
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  FocusScopeNode _scopeNode;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: 300), () {
      _scopeNode.requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null == _scopeNode) {
      _scopeNode = FocusScope.of(context);
    }
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(160)),
          child: Container(
            width: ScreenUtil.getInstance().setWidth(560),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '修改分类名',
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onSubmitted: (text) {
                      if (widget.confirm != null) {
                        widget.confirm(text);
                      }
                      NavigatorUtils.goBack(context);
                    },
                    controller: _editingController,
                    focusNode: _focusNode,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: '分类名...', border: InputBorder.none),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 49,
                  child: Stack(
                    children: <Widget>[
                      Gaps.line,
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: HighLightWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '取消',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onTap: () {
                                NavigatorUtils.goBack(context);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: HighLightWell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '确认',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              onTap: () {
                                if (widget.confirm != null) {
                                  widget.confirm(_editingController.text);
                                }
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
                                showDialog<Null>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("提示"),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[Text("分类名编辑成功！")],
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
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
