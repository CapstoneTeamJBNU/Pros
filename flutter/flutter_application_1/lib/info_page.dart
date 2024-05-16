import 'package:flutter/material.dart';

// stateful로 바꿔야함
class InfoPage extends StatelessWidget{
  const InfoPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('내 정보')
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
            ],
          ),
        )
      );
  }
}