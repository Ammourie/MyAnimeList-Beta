import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final Function func;

  const MyListTile(
      {Key key,
      this.title,
      this.subtitle,
      this.leading,
      this.trailing,
      this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(color: Colors.black45),
      //   ),
      // ),
      child: ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: func,
      ),
    );
  }
}
