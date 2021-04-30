import "package:flutter/material.dart";
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if(i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;
        if(index >= _suggestions.length) {
          print("Added after line $i");
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                )
              );
            }
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Suggestion"),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  void _displayStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final numOfPairs = _suggestions.length;
          final numOfSaved = _saved.length;
          return Scaffold(
            appBar: AppBar(
              title: Text("Stats"),
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text(
                    "Num of word pairs: $numOfPairs",
                    style: _biggerFont,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Num of favorites: $numOfSaved",
                    style: _biggerFont
                  )
                )
              ],
            ),
          );
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          IconButton(icon: Icon(Icons.equalizer), onPressed: _displayStats)
        ],
      ),
      body: _buildSuggestions()
    );
  }
}