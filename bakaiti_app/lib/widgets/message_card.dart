import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/my_date_formator.dart';
import '../main.dart';
import '../models/messages.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  //Getting Message from the user.
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromID
        ? _greenMessages()
        : _orangeMessages();
  }

  //
  Widget _greenMessages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: IntrinsicWidth(
            stepWidth: Checkbox.width,
            child: Container(
              padding: EdgeInsets.only(
                  top: mq.width * .02,
                  right: mq.width * .03,
                  left: mq.width * .02,
                  bottom: mq.width * .001),
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * .01, horizontal: mq.width * .03),
              decoration: BoxDecoration(
                  color: Color(0xF808A98C),
                  border: Border.all(color: Color.fromARGB(255, 0, 115, 94)),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: Column(
                children: [
                  //user chat messAGE
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.message.msg}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  //to show time of message.
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Text(
                          MyDateFormator.getFormatedTime(
                              context: context,
                              time: '${widget.message.sentTime}'),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),

                        //For some Space
                        SizedBox(
                          width: mq.width * .005,
                        ),

                        //Double thick icon
                        if (widget.message.readTime!.isNotEmpty)
                          const Icon(
                            Icons.done_all_outlined,
                            color: Colors.white,
                            size: 16,
                          )
                        else
                          const Icon(
                            Icons.done_all_outlined,
                            color: Color.fromARGB(255, 45, 45, 45),
                            size: 16,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //
  Widget _orangeMessages() {
    //to update read status of message
    if (widget.message.readTime!.isEmpty) {
      APIs.getupdatedMessageReadStatus(widget.message);
    }

    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: IntrinsicWidth(
            stepWidth: Checkbox.width,
            child: Container(
              padding: EdgeInsets.only(
                  top: mq.width * .02,
                  right: mq.width * .03,
                  left: mq.width * .02,
                  bottom: mq.width * .001),
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * .01, horizontal: mq.width * .03),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 156, 70),
                  border: Border.all(color: Color.fromARGB(255, 240, 88, 0)),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.message.msg}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                  // to show the time.
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      MyDateFormator.getFormatedTime(
                          context: context, time: '${widget.message.sentTime}'),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
