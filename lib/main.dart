import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/html_escape.dart';
import 'package:html/parser.dart';
import 'package:html/html_escape.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    /*
    var excel = Excel.createExcel();
    Sheet sheet = excel.sheets.values.first;
    CellIndex cellIndex = CellIndex.indexByString('A1');
    sheet.cell(cellIndex).value = 'TestNJW';
    String outputFile = 'my950.xls';

    //stopwatch.reset();
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }

     */
    generateCSV();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
List<List<dynamic>> rows = [];

void generateCSV(){
  // we will declare the list of headers that we want
   List<String> rowHeader = ["Name","Address","Phone"];
  // here we will make a 2D array to handle a row
  //First add entire row header into our first row
  rows.add(rowHeader);
  //Now lets add 5 data rows
  for(int i=0;i<5;i++){
    //everytime loop executes we need to add new row
    List<dynamic> dataRow=[];
    dataRow.add("NAME :$i");
    dataRow.add("ADDRESS :$i");
    dataRow.add("PHONE:$i");
    //lastly add dataRow to our 2d list
    rows.add(dataRow);
  }
//now convert our 2d array into the csvlist using the plugin of csv
  String csv = const ListToCsvConverter().convert(rows);
//this csv variable holds entire csv data
//Now Convert or encode this csv string into utf8
  final bytes = utf8.encode(csv);
//NOTE THAT HERE WE USED HTML PACKAGE
  final blob = Blob([bytes]);
//It will create downloadable object
  final url = Url.createObjectUrlFromBlob(blob);
//It will create anchor to download the file
  final anchor = document.createElement('a')  as  AnchorElement..href = url..style.display = 'none'
    ..download = 'yourcsvname.csv';
//finally add the csv anchor to body
  document.body?.children.add(anchor);
// Cause download by calling this function
  anchor.click();
//revoke the object
  Url.revokeObjectUrl(url);

}