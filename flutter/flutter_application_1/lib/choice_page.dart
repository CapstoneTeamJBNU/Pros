import 'package:flutter/material.dart';
import 'package:flutter_application_1/userData_page.dart';

class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true, // 제목을 가운데로 정렬
        // automaticallyImplyLeading = false : 뒤로가기 버튼을 없애기, true : 뒤로가기 버튼을 보이기
        // automaticallyImplyLeading : false,
        // 위 구문에 사이드바 병합 - 로그아웃 및 정보 조회 버튼 연결 예정?
        leading: TextButton(
          onPressed: () {
            // 로그아웃 버튼 클릭 시 처리할 로직 추가
            print('로그아웃 버튼이 클릭되었습니다.');
          },
          child: Text('로그아웃'),
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
                  MaterialPageRoute(builder: (context) => const UserDataSelectionPage()),
                );
              },
              child: Text('시간표 생성'),
            ),
            SizedBox(height: 20), // 버튼 사이에 간격 추가
            ElevatedButton(
              onPressed: () {
                // 두 번째 버튼 클릭 시 처리할 로직 추가.
                print('내 시간표 버튼이 클릭되었습니다.');
              },
              child: Text('내 시간표'),
            ),
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
