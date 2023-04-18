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
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 237, 190, 180)),
        ),
        home: MyHomePage(),
      ),       
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;                 // ← Add this.

    return Scaffold(
      body: Column(
        children: [
          Text('\n\n\n\n'),
          Text('A random AWSOME idea:'),
          // Text(appState.current.asPascalCase),
          BigCard(pair: pair),                // ← Change to this.
          // ↓ Add this.
          ElevatedButton(
            onPressed: () {
              // print('button pressed. hahaha..!');
              appState.getNext();  // ← This instead of print().
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);       // ← Add this.
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,    // ← And also this.
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asPascalCase, style: style),
      ),
    );
  }
}