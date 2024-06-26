import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/features/chat/presentation/models/messagemodel.dart';
import 'package:graduation/features/chat/presentation/models/romemodel.dart';
import 'package:graduation/features/chat/presentation/views/widgets/chat_body.dart';

class ChatCard extends StatelessWidget {
  ChatCard({
    required this.chatroom,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final ChatRoom chatroom;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
                                          final isMe = chatroom.userid != myUid;

    return Card(
      color: selected ? accentColor3.withOpacity(0.5) : ksecondcolor2,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: ListTile(
          
          onTap: onTap,
          onLongPress: onLongPress,
          leading: const CircleAvatar(),
          trailing: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('rooms')
                .doc(chatroom.id)
                .collection('messages')
                .snapshots(),
            builder: (context, snapshot) {

              if (snapshot.hasData && snapshot.data != null) {
                final unreadmessglist = snapshot.data!.docs
                
                    .map((e) => Message.fromJson(e.data()))
                    .where((element) => element.read != null && !element.read!)
                    .where((element) => element.fromId != myUid)
                    .toList();
        
                if (unreadmessglist.isNotEmpty) {
                  return Badge(
                    backgroundColor: accentColor3,
                    largeSize: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    label: Text(unreadmessglist.length.toString()),
                  );
                } else {
                  return const Text('');
                }
              } else {
                return const SizedBox();
              }
            },
          ),
          title: Text(isMe?chatroom.name.toString():chatroom.myname.toString(),
              style: const TextStyle(color: kmaincolor, fontWeight: FontWeight.bold)),
          subtitle: Text(
            chatroom.lastMessage == "" ? 'send a message' : chatroom.lastMessage!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: ksecondcolor),
          ),
        ),
      ),
    );
  }
}
