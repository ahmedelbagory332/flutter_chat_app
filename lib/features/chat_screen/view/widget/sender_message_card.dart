import 'package:flutter/material.dart';

class SenderMessageCard extends StatefulWidget {
  const SenderMessageCard(this.fileName, this.msgType, this.msg, this.time,
      {Key? key}) : super(key: key);

  final String msg;
  final String time;
  final String msgType;
  final String fileName;

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {

  Widget messageBuilder(context) {
    Widget body = Container();
  if (widget.msgType == "text") {
      body = Padding(
        padding: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
        child: SelectableText(
          widget.msg,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Card(
          color: const Color(0xff048067),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
           margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            messageBuilder(context),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(widget.time,
                  style: const TextStyle(fontSize: 13, color: Colors.white)),
            )
          ]),
        ));
  }
}
