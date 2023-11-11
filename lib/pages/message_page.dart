import 'package:flutter/material.dart';
import 'package:simple_messenger/components/message_textfield.dart';
import 'package:simple_messenger/services/connection_service.dart';
import 'package:simple_messenger/models/friend.dart';
// import 'package:simple_messenger/models/message.dart';

class MessagePage extends StatelessWidget {
  // In the constructor, require a Friend
  const MessagePage({super.key, required this.friend});

  // Declare a field that holds the Friend
  final Friend friend;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    List<String> messages = [];

    void onSend() {
      if (textController.text.isNotEmpty) {
        ConnectionService().sendMessage(textController.text, friend.id);
        textController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.email),
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () { 
                // Navigate back to Friends page
                Navigator.pop(context);
              },
            );
          }
        )
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: ConnectionService().stream,
              builder: (context, snapshot) {  
                // Check if user receives a message
                if (snapshot.hasData) {
                  List<String> received = snapshot.data.toString().split(" ");
                  // Check that the message received is from the current friend they are viewing
                  if (received[0] == friend.id) {
                    messages.add(received[2]);
                  }
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index])
                      );
                    },
                  )
                );
              },
            ),
            MessageTextField(
              controller: textController,
              hintText: 'Message',
              onIconTap: onSend,
            ),
            const SizedBox(height: 20),
          ]
        )
      )
    );
  }
}