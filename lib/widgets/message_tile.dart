import 'package:flutter/material.dart';
import 'package:groopie/widgets/widgets.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sendByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: widget.sendByMe ? 0 : 24,
          right: widget.sendByMe ? 24 :0,
          
        ),
        alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: widget.sendByMe
              ? const EdgeInsets.only(left: 30)
              : const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: widget.sendByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(20))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              color: widget.sendByMe ? kPrimaryDark.withOpacity(0.8) : kPrimary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sender.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800, color: Colors.yellow),
              ),
              const SizedBox(height: 5,),
              Text(
                widget.message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w100, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
