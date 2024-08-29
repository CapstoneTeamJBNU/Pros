import 'package:RTT/userData_page.dart';
import 'package:flutter/material.dart';


class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 로그아웃 버튼을 Row 위젯의 앞쪽에 배치
              TextButton(
                onPressed: () {
                  // 로그아웃 버튼 클릭 시 처리할 로직 추가
                  print('로그아웃 버튼이 클릭되었습니다.');
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // 제목을 가운데에 배치
              const Text(
                'Home Page',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 80), // 추가: 로그아웃 버튼과 'Home Page' 텍스트 사이의 간격 조절
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectionSheet()),
                );
              },
              child: Text('시간표 생성'),
            ),
            SizedBox(height: 20), // 버튼 사이에 간격 추가
            // ElevatedButton(
            //   // onPressed: () {
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(builder: (context) => const (?)),
            //   //   );
            //   },
              // child: Text('내 시간표'),
            // ),
          ],
        ),
      ),


      // 사이드바. 잠정 주석 처리
      // drawer: Drawer(
      //     child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
      //       // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
      //       UserAccountsDrawerHeader(
      //         // currentAccountPicture: CircleAvatar(
      //         //   // 현재 계정 이미지 set
      //         //   backgroundImage: AssetImage('assets/profile.png'),
      //         //   backgroundColor: Colors.white,
      //         // ),
      //         // otherAccountsPictures: <Widget>[
      //           // 다른 계정 이미지[] set
      //           // CircleAvatar(
      //           //   backgroundColor: Colors.white,
      //           //   backgroundImage: AssetImage('assets/profile2.png'),
      //           // ),
      //           // CircleAvatar(
      //           //   backgroundColor: Colors.white,
      //           //   backgroundImage: AssetImage('assets/profile2.png'),
      //           // )
      //         // ],
      //         accountName: Text('GANGPRO'),
      //         accountEmail: Text('gangpro@email.com'),
      //         onDetailsPressed: () {
      //           print('arrow is clicked');
      //         },
      //         decoration: BoxDecoration(
      //             color: Colors.red[200],
      //             borderRadius: BorderRadius.only(
      //                 bottomLeft: Radius.circular(40.0),
      //                 bottomRight: Radius.circular(40.0))),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.home,
      //           color: Colors.grey[850],
      //         ),
      //         title: Text('Home'),
      //         onTap: () {
      //           print('Home is clicked');
      //         },
      //         trailing: Icon(Icons.add),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.settings,
      //           color: Colors.grey[850],
      //         ),
      //         title: Text('내 정보'),
      //         onTap: () async {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => const InfoPage()),
      //               );
      //         },
      //         trailing: Icon(Icons.add),
      //       ),
      //       ListTile(
      //         leading: Icon(
      //           Icons.question_answer,
      //           color: Colors.grey[850],
      //         ),
      //         title: Text('TEMP'),
      //         // onTap: () async {
      //         //     Navigator.push(
      //         //       context,
      //         //       MaterialPageRoute(builder: (context) => const UserDataSelectionPage()),
      //         //       );
      //         // },
      //         trailing: Icon(Icons.add),
      //       ),
      //     ],
      //   ),
      //   ),
    );
  }
}
