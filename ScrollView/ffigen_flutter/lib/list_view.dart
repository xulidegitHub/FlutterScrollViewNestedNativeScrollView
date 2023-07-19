import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ffigen/ffigen.dart';

const platform = MethodChannel("flutter.com/channel");

class ListViewWidget extends StatefulWidget {
  const ListViewWidget({super.key});

  @override
  State<StatefulWidget> createState() => ListViewWidgetState();
}

class ListViewWidgetState extends State<ListViewWidget> {
final List<String> entries = <String>['A', 'B', 'C', 'dsf', 'adsf', 'asdf', 'asdf', 'asdf', 'asdf', 'asdf', 'A', 'B', 'C', 'dsf', 'adsf', 'asdf', 'asdf', 'asdf', 'asdf', 'asdf'];
final List<int> colorCodes = <int>[600, 500, 100, 100, 100, 100, 100, 200, 500, 200, 600, 500, 100, 100, 100, 100, 100, 200, 500, 200];
// 设置一个controller
final ScrollController _controller = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      print(_controller.offset);
      /// 测试原生=打开此代码
      // _controller.jumpTo(0);
      _setNativeContentOffset(_controller.offset);
    });
  }

  _setNativeContentOffset(double controllerOffset) async {
    final tempOffset = await platform.invokeMethod("setContentOffset", controllerOffset);
    setState(() {
      _controller.jumpTo(tempOffset);
    });
  }


@override
Widget build(BuildContext context) {
  return ListView.separated(
    controller: _controller,
    padding: const EdgeInsets.all(8),
    itemCount: entries.length,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        height: 50,
        color: Colors.amber[colorCodes[index]],
        child: Center(child: Text('Entry ${entries[index]}')),
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
}