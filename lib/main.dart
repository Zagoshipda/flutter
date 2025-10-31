import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // app-wide state
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    // 1. reassigns 'current' state with another random word
    current = WordPair.random();

    // 2. a method of ChangeNotifier, ensuring that anyone watching MyAppState is notified.
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  // Every widget defines a build() method which automatically called every time
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // Every build() method must return a widget or (more typically) a nested tree of widgets
    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea ? :'),
          Text(appState.current.asLowerCase), // youthchart
          Text(appState.current.asPascalCase), // YouthChart
          Text(appState.current.asSnakeCase), // youth_chart

          ElevatedButton(
            onPressed: () {
              appState.getNext(); // get new state (current)

              print('button pressed!'); // debug message
            },
            child: Text('This is a button !'),
          ),
        ],
      ),
    );
  }
}
