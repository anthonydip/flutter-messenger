import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friend {
  final String name;

  const Friend(this.name);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Simple Messenger',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const FriendsPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  
}

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: () { 
              // Add friend functionality
              // code...
             },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: ListView(
          children: [
            for (var i = 1; i <= 100; i++)
              ListTile(
                title: Text('Friend $i'),
                trailing: const Icon(Icons.message),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePage(friend: Friend('Name $i')),
                    )
                  );
                }
              )
          ]
        ),
      )
    );
  }
}

// class MessagePage extends StatefulWidget {
//   const MessagePage({super.key, required this.friend});

//   final Friend friend;

//   @override
//   State<MessagePage> createState() => _MessagePageState();
// }

class MessagePage extends StatelessWidget {
  const MessagePage({super.key, required this.friend});

  final Friend friend;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () { 
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsPage()),
                );
              },
            );
          }
        )
      ),
    );
  }
}