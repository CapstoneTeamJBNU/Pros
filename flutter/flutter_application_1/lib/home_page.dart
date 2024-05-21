import 'package:flutter/material.dart';
import 'package:flutter_application_1/choice_page.dart';
import 'package:flutter_application_1/info_page.dart';
import 'package:flutter_application_1/shedule_table.dart';
import 'package:flutter_application_1/userData_page.dart';

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
          // automaticallyImplyLeading = false : 뒤로가기 버튼을 없애기, true : 뒤로가기 버튼을 보이기
          // automaticallyImplyLeading : false,
          title: const Text('Home Page'),
          centerTitle: true,
          elevation: 0.0,
          actions: <Widget>[
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
      drawer: Drawer(
          child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
            // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
            UserAccountsDrawerHeader(
              // currentAccountPicture: CircleAvatar(
              //   // 현재 계정 이미지 set
              //   backgroundImage: AssetImage('assets/profile.png'),
              //   backgroundColor: Colors.white,
              // ),
              // otherAccountsPictures: <Widget>[
                // 다른 계정 이미지[] set
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   backgroundImage: AssetImage('assets/profile2.png'),
                // ),
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   backgroundImage: AssetImage('assets/profile2.png'),
                // )
              // ],
              accountName: Text('GANGPRO'),
              accountEmail: Text('gangpro@email.com'),
              onDetailsPressed: () {
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('Home'),
              onTap: () {
                print('Home is clicked');
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey[850],
              ),
              title: Text('Setting'),
              onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfoPage()),
                    );
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: Colors.grey[850],
              ),
              title: Text('Q&A'),
              onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserDataSelectionPage()),
                    );
              },
              trailing: Icon(Icons.add),
            ),
          ],
        ),
        ),
      );
  }
}