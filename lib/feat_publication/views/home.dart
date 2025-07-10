import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yansnet/feat_publication/widgets/add_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
    State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AddButton(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Hello",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            )
          ],
        )
    ),
    );
  }
}

