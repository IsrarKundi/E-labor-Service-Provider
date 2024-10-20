import 'package:e_labors/chat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<WorkerChat> chats = [
    WorkerChat(
      profileImage: 'images/labor.jpeg',
      name: 'Ahmed Khan',
      msg: 'I will be there in half hour',
    ),
    WorkerChat(
      profileImage: 'images/israr2.jpeg',
      name: 'Abu Bakkar',
      msg: 'Okay',
    ),
    WorkerChat(
      profileImage: 'images/plumber.webp',
      name: 'Arbaz Butt',
      msg: 'Send pictures of work',
    ),
    WorkerChat(
      profileImage: 'images/carpenter.jpg',
      name: 'kamran Khan',
      msg: 'Find someone else',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset('images/logo.png', height: 33,),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(
              'Recent Chats',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatCard(chat: chats[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class ChatCard extends StatelessWidget {
  final WorkerChat chat;

  ChatCard({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xfffef1e9),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(chat.profileImage),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 2.0),

                  Text(
                    chat.msg,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

