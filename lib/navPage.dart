import 'package:costumer_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  home: Scaffold(body:Column(children: [Center(child: ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),));
        
      },child: Text('efsef'),))],),),
    );
  }
}