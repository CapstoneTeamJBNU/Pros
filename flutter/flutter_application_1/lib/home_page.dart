import 'package:flutter/material.dart';
import 'package:flutter_application_1/info_page.dart';
import 'package:flutter_application_1/shedule_table.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();

}

class HomePageState extends State{
  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading : false,
          title: const Text('Home Page'),
          centerTitle: true,
          elevation: 0.0,
          actions: [
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                print('add button is clicked');
              },
            )
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScheduleTable(),
              ],
            );
        },
      ),
      );
  }
}