import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:finalprojectfinal/components/poke_cell.dart';
import 'package:finalprojectfinal/screens/search_screen.dart';
import '../utils/api_service.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelineScreen> {
  int _offset = 0;

  void _increaseOffset(){
    setState(() {
      _offset += 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) =>
              GridTile(child:
              pokeCell(),
              )
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(Icons.search_rounded, size: 40,)
        ),
        onPressed: () {
          fetchPokemon(_offset);
          _increaseOffset();
          /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchScreen())
            );
             */
        },
      ),
    );
  }
}