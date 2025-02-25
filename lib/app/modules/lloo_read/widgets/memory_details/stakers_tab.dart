
import 'package:flutter/material.dart';

class StakersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        StakerListItem('Pamella Levin', '34 ATTN'),
        StakerListItem('Alex Brody', '70 ATTN'),
        StakerListItem('Cris Kross', '10 ATTN'),
      ],
    );
  }
}

class StakerListItem extends StatelessWidget {
  final String name;
  final String amount;

  const StakerListItem(this.name, this.amount);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(name[0])),
      title: Text(name),
      trailing: Text(amount),
    );
  }
}