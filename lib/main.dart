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
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0x00FF00FF),
          ), // NOTE : ARGB
          // colorScheme: ColorScheme.fromSeed(
          //   seedColor: Color.fromRGBO(100, 0, 100, 1.0),
          // ), // NOTE : RGBO
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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  // Every widget defines a build() method which automatically called every time
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Every build() method must return a widget or (more typically) a nested tree of widgets
    return LayoutBuilder(
      // builder callback is called every time the constraints change
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              // SafeArea ensures that its child is not obscured by a hardware notch or a status bar
              SafeArea(
                child: NavigationRail(
                  extended:
                      // true
                      constraints.maxWidth >=
                      600, // shows the labels next to the icons or not, responsively
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],

                  selectedIndex: selectedIndex,

                  onDestinationSelected: (value) {
                    print('selected: $value'); // debugging message
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The Text widget no longer refers to the whole appState, rather it only takes 'current' value
          BigCard(pair: pair),

          // SizedBox widget just takes space and doesn't render anything by itself.
          // It's commonly used to create visual "gaps"
          SizedBox(height: 100),

          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  print('like button pressed'); // debug message
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),

              SizedBox(width: 10),

              ElevatedButton(
                onPressed: () {
                  appState.getNext(); // get new state (current)
                  print('next button pressed'); // debug message
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // bang operator (!)
    final styleSmall = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final styleMedium = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final styleLarge = theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Column(
      children: [
        Card(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              pair.asPascalCase,
              style: styleMedium,
              // improving accessibility
              semanticsLabel: "${pair.first} ${pair.second}",
            ),
          ),
        ), // PascalCase

        Card(
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pair.asSnakeCase, style: styleSmall),
          ),
        ), // snake_case

        Card(
          color: theme.colorScheme.tertiary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pair.asLowerCase, style: styleSmall),
          ),
        ), // snakecase

        Card(
          color: theme.colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(pair.asUpperCase, style: styleLarge),
          ),
        ), // SNAKE_CASE
      ],
    );
  }
}
