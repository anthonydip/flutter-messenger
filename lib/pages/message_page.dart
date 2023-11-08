import 'package:flutter/material.dart';
import 'package:simple_messenger/components/message_textfield.dart';
import 'package:simple_messenger/services/connection_service.dart';
import '../models/friend.dart';

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
        ConnectionService().sendMessage(textController.text);
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
              stream: ConnectionService().channel?.stream,
              builder: (context, snapshot) {  
                if (snapshot.hasData) {
                  messages.add(snapshot.data.toString());
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
          ]
        )
      )
    );
  }
}