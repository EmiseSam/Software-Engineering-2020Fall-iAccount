import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/pages/morepages/account.dart';
import 'package:i_account/pages/accountpages/model/account_keyboard.dart';
import 'package:i_account/res/styles.dart';

class AccountCFPage extends StatefulWidget {
  @override
  _AccountCFPageState createState() => _AccountCFPageState();
}

class _AccountCFPageState extends State<AccountCFPage> {
  String name;
  String amount;
  String _tittleCreate = '';
  bool _isAdd = false;
  String _numberString = '';

  //账户名称控制器
  TextEditingController accountnameController = TextEditingController();


  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建${_tittleCreate}账户',
          style: TextStyle(
              fontSize: 18,
              color: Colours.app_main,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
        actionName: "确定",
        onPressed: (){
          //TODO 这里要做一个判断数据类型是否正确 以及把新增的账户读到数据库里去
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountPage()));
        },
      ),
      body: Container(
        color: Color(0xFFF0F0F0),
        child: Column(
          children: [
            Container(
              height: 48,
              color: Color(0xFFF0F0F0),
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("账户名称", style: TextStyle(fontSize: 18),),
            ),
            Divider(height: 1),
            TextField(
              controller: accountnameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                icon:Icon(Icons.account_balance_wallet),
              ),
              autofocus: false,
            ),
            Container(
              height: 48,
              color: Color(0xFFF0F0F0),
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("初始金额", style: TextStyle(fontSize: 18),),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  _numberString.isEmpty ? '0.0' : _numberString,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            MyKeyBoard(
              isAdd: _isAdd,
              // 键盘输入
              numberCallback: (number) => inputVerifyNumber(number),
              // 删除
              deleteCallback: () {
                if (_numberString.length > 0) {
                  setState(() {
                    _numberString =
                        _numberString.substring(0, _numberString.length - 1);
                  });
                }
              },
              // 清除
              clearZeroCallback: () {
                _clearZero();
              },
              // 等于
              equalCallback: () {
                setState(() {
                  _addNumber();
                });
              },
              //继续
              //nextCallback: () {
                //if (_isAdd == true) {
                  //_addNumber();
                //}
                //_record();
                //_clearZero();
                //setState(() {});
              //},
              // 保存
              saveCallback: () {
              _record();
                //TODO ;
              },
            ),
            MediaQuery.of(context).padding.bottom > 0
                ? Gaps.vGapLine(gap: 0.3)
                : Gaps.empty,
          ],
        ),
      ),
    );
  }

  void _addNumber() {
    _isAdd = false;
    List<String> numbers = _numberString.split('+');
    double number = 0.0;
    for (String item in numbers) {
      if (item.isEmpty == false) {
        number += double.parse(item);
      }
    }
    String numberString = number.toString();
    if (numberString.split('.').last == '0') {
      numberString = numberString.substring(0, numberString.length - 2);
    }
    _numberString = numberString;
  }

  void _onConfirm() {
    _createAccount();
  }

  void _createAccount() {
    //TODO
  }

  /// 键盘输入验证
  void inputVerifyNumber(String number) {
    //小数点精确分，否则不能输入
    //加法
    if (_numberString.isEmpty) {
      //没输入的时候，不能输入+或者.
      if (number == '+') {
        return;
      }

      if (number == '.') {
        setState(() {
          _numberString += '0.';
        });
        return;
      }

      setState(() {
        _numberString += number;
      });
    } else {
      List<String> numbers = _numberString.split('');
      if (numbers.length == 1) {
        // 当只有一个数字
        if (numbers.first == '0') {
          //如果第一个数字是0，那么输入其他数字和+不生效
          if (number == '.') {
            setState(() {
              _numberString += number;
            });
          } else if (number != '+') {
            setState(() {
              _numberString = number;
            });
          }
        } else {
          //第一个数字不是0 为1-9
          setState(() {
            if (number == '+') {
              _isAdd = true;
            }
            _numberString += number;
          });
        }
      } else {
        List<String> temps = _numberString.split('+');
        if (temps.last.isEmpty && number == '+') {
          //加号
          return;
        }

        //拿到最后一个数字
        String lastNumber = temps.last;
        List<String> lastNumbers = lastNumber.split('.');
        if (lastNumbers.last.isEmpty && number == '.') {
          return;
        }
        if (lastNumbers.length > 1 &&
            lastNumbers.last.length >= 2 &&
            number != '+') {
          return;
        }

        setState(() {
          if (number == '+') {
            _isAdd = true;
          }
          _numberString += number;
        });
      }
    }
  }

  void _record() {
    if (_numberString.isEmpty || _numberString == '0.') {
      return;
    }
    _isAdd = false;
  }

  /// 清零
  void _clearZero() {
    setState(() {
      _isAdd = false;
      _numberString = '';
    });
  }

}
