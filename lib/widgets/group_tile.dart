import 'package:flutter/material.dart';
import 'package:groopie/widgets/widgets.dart';

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
        child: GestureDetector(
          onTap: () {
            nextScreen(context,  ChatPage(groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName,));
          },
          child: Container(
            height: 68,
            decoration: BoxDecoration(
                color: kPrimary, borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: kPrimaryLight,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  title: Text(
                    widget.groupName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("join the conversation as ${widget.userName}",
                      style: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis))),
            ),
          ),
        ));
  }
}
