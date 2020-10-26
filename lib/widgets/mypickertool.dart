import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';


const double kPickerHeight = 216.0;
const double kItemHeight = 40.0;
const Color kBtnColor = Color(0xFF323232); //50
const Color kTitleColor = Color(0xFF787878); //120
const double kTextFontSize = 17.0;

typedef StringClickCallback = void Function(int selectIndex, Object selectStr);
typedef ArrayClickCallback = void Function(
    List<int> selecteds, List<dynamic> strData);
typedef DateClickCallback = void Function(
    dynamic selectDateStr, dynamic selectDate);

enum DateType {
  YMD, // y, m, d
  YM, // y ,m
  YMD_HM, // y, m, d, hh, mm
  YMD_AP_HM, // y, m, d, ap, hh, mm
}

class MyPickerTool {
  /*单列*/
  static void showStringPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    int normalIndex,
    PickerDataAdapter adapter,
    @required StringClickCallback clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: false),
        clickCallBack: (Picker picker, List<int> selecteds) {
      //          print(picker.adapter.text);
      clickCallBack(selecteds[0], data[selecteds[0]]);
    }, selecteds: [normalIndex ?? 0], title: title);
  }

  /*多列*/
  static void showArrayPicker<T>(
    BuildContext context, {
    @required List<T> data,
    String title,
    List<int> normalIndex,
    PickerDataAdapter adapter,
    @required ArrayClickCallback clickCallBack,
  }) {
    openModalPicker(context,
        adapter: adapter ?? PickerDataAdapter(pickerdata: data, isArray: true),
        clickCallBack: (Picker picker, List<int> selecteds) {
      clickCallBack(selecteds, picker.getSelectedValues());
    }, selecteds: normalIndex, title: title);
  }

  static void openModalPicker(
    BuildContext context, {
    @required PickerAdapter adapter,
    String title,
    List<int> selecteds,
    @required PickerConfirmCallback clickCallBack,
  }) {
    new Picker(
            adapter: adapter,
            title: new Text(title ?? "请选择",
                style: TextStyle(color: kTitleColor, fontSize: kTextFontSize)),
            selecteds: selecteds,
            cancelText: '取消',
            confirmText: '确定',
            cancelTextStyle:
                TextStyle(color: kBtnColor, fontSize: kTextFontSize),
            confirmTextStyle:
                TextStyle(color: kBtnColor, fontSize: kTextFontSize),
            textAlign: TextAlign.right,
            itemExtent: kItemHeight,
            height: kPickerHeight,
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: clickCallBack)
        .showModal(context);
  }

}
