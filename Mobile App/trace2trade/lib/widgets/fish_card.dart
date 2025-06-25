import 'package:flutter/material.dart';

class FishCard extends StatelessWidget {
  final String fishName;
  final String weight;

  const FishCard({super.key, required this.fishName, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(fishName),
        subtitle: Text("Weight: $weight kg"),
      ),
    );
  }
}