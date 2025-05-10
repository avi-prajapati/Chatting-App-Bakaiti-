import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import '../models/user_chat.dart';
import '../screens/chat_screen.dart';

class UserChatCard extends StatefulWidget {
  final UserChat user;
  const UserChatCard({super.key, required this.user});

  @override
  State<UserChatCard> createState() => _UserChatCardState();
}

class _UserChatCardState extends State<UserChatCard> {
  @override
  Widget build(BuildContext context) {
    return
        //Card of userChat.
        Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .03, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: InkWell(
        //Logic for chatting.
        onTap: () {
          //For navigating to chatScreen.
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  user: widget.user,
                ),
              ));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              height: mq.height * .055,
              width: mq.height * .055,
              imageUrl: '${widget.user.image}',
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundColor: Color(0xF42A3145),
                child: Icon(
                  CupertinoIcons.person_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //Tile of the card.
          title: Text('${widget.user.name}'),

          //Subtitle in the card.
          subtitle: Text('${widget.user.about}'),

          //To show timming in the card.
          trailing: Text('12:00 pm'),
        ),
      ),
    );
  }
}
