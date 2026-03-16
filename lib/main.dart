import 'package:flutter/material.dart';

void main() {
  runApp(CounterApp());
}

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {

  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter Counter Demo")),
        body: Center(
          child: Text(
            "Count: $count",
            style: TextStyle(fontSize: 30),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: increment,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}