import 'dart:convert';
import 'dart:developer';

import 'package:bakaiti_app/models/user_chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/messages.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final UserChat user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //List of Messages.
  List<Messages> _list = [];

  //this help to get data and send data from text field.
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/chatscreenback.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),

            //body of the Chat Screen.
            body: Column(
              children: [
                //To show chat of user.
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //If data is loading.
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(child: CircularProgressIndicator());

                        //After loading Data
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          /*If data is not null, convert each item into a Message 
                      object using its JSON data, and return the list. Otherwise,
                      return an empty list.*/
                          _list = data
                                  ?.map((e) => Messages.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                padding: EdgeInsets.only(top: mq.height * .01),
                                itemCount: _list.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //Typing bar Function.
                _chatTypingBar(),
              ],
            )),
      ),
    );
  }

  //Customised AppBar For chat Screen.
  Widget _appBar() {
    // ignore: prefer_const_constructors
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          //Icon Back Button of Chat Screen.
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),

          //Circle image in Appbar of the Chat Screen.
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              height: mq.height * .050,
              width: mq.height * .050,
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

          const SizedBox(
            width: 10,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.user.name}',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
              const Text(
                'Last Seen not Available',
                style: TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 215, 210, 210)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Chat Typing Bar.
  Widget _chatTypingBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .02, vertical: mq.height * .02),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: const Color(0xF42A3145),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: Row(
                children: [
                  //Emoji button.
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.smiley_fill,
                      color: Color.fromARGB(244, 255, 255, 255),
                    ),
                  ),

                  //Textfield to type message.
                  Expanded(
                      child: TextField(
                    controller: _textFieldController,
                    style: const TextStyle(fontSize: 17),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Color.fromARGB(244, 255, 255, 255))),
                  )),

                  //Camera Button.
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.camera_fill,
                      color: Color.fromARGB(244, 255, 255, 255),
                    ),
                  ),

                  //Gallery Button.
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.photo,
                      color: Color.fromARGB(244, 255, 255, 255),
                    ),
                  )
                ],
              ),
            ),
          ),

          //Send Message button.
          MaterialButton(
            onPressed: () {
              if (_textFieldController.text.isNotEmpty) {
                APIs.sendMessages(widget.user, _textFieldController.text);
                _textFieldController.text = '';
              }
            },
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 8),
            shape: const CircleBorder(),
            minWidth: 0,
            color: const Color(0xFF028E74),
            child: const Icon(
              Icons.send,
              size: 32,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
