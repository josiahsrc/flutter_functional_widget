import 'package:flutter/material.dart';
import 'package:flutter_functional_widget/flutter_functional_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: CounterText(counter: _counter),
      floatingActionButton: Fab(
        onPressed: _incrementCounter,
      ),
    );
  }
}

@Functional()
Widget _counterText(BuildContext context, {required int counter}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '$counter',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    ),
  );
}

@Functional()
Widget _fab(BuildContext context, {VoidCallback? onPressed}) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
  );
}
