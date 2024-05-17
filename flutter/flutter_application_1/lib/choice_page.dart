import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true, // 제목을 가운데로 정렬
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
              onPressed: () {
                // 첫 번째 버튼 클릭 시 처리할 로직 추가.
                print('첫 번째 버튼이 클릭되었습니다.');
              },
              child: Text('첫 번째 버튼'),
            ),
            SizedBox(height: 20), // 버튼 사이에 간격 추가
            ElevatedButton(
              onPressed: () {
                // 두 번째 버튼 클릭 시 처리할 로직 추가.
                print('두 번째 버튼이 클릭되었습니다.');
              },
              child: Text('두 번째 버튼'),
            ),
          ],
        ),
      ),
    );
  }
}
//추후에 home_page.dart에서 테이블 분리후 홈페이지 병합