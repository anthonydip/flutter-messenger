import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friend {
  final String name;

  const Friend(this.name);
}

void main() {
  runApp(const MessengerApp());
}

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessengerAppState(),
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

class MessengerAppState extends ChangeNotifier {
  var friends = <Friend>[];

  void addFriend(name) {
    if (friends.contains(name)) {
      // Friend already exists
      // code..
    } else {
      print('Added $name');
      friends.add(Friend(name));
    }

    notifyListeners();
  }
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MessengerAppState>();
    var friends = appState.friends;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Add Friend'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add friend
                      appState.addFriend(controller.text);

                      Navigator.pop(context, 'Add');
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(friends[index].name),
              trailing: const Icon(Icons.message),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(friend: friends[index]),
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}

class MessagePage extends StatelessWidget {
  // In the constructor, require a Friend
  const MessagePage({super.key, required this.friend});

  // Declare a field that holds the Friend
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