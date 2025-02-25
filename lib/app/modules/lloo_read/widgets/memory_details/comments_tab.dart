
import 'package:flutter/material.dart';

class CommentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CommentItem('John Doe', 'This is devastating, we must help however we can'),
        CommentItem('Jane Smith', 'Donating and raising awareness is so important right now'),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  final String name;
  final String comment;

  CommentItem(this.name, this.comment);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(name[0])),
      title: Text(name),
      subtitle: Text(comment),
    );
  }
}