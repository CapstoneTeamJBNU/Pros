import 'package:flutter/material.dart';
import 'package:flutter_application_1/time_table.dart';
import 'account.dart';

class UserDataSelectionPage extends StatefulWidget {
  const UserDataSelectionPage({super.key});
  @override
  UserDataSelectionPageState createState() => UserDataSelectionPageState();
}

class UserDataSelectionPageState extends State<UserDataSelectionPage> {
  String? dropdownValue1;
  String? dropdownValue2;
  String? dropdownValue3;
  String? dropdownValue4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
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
                child: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // 제목을 가운데에 배치
              Text(
                '시간표 생성',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(width: 80), // 추가: 로그아웃 버튼과 '시간표 생성' 텍스트 사이의 간격 조절
            ],
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '강의년도/학기',
                  ),
                  value: dropdownValue1,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue1 = newValue!;
                    });
                  },
                  items: <String>['2024/1', '2023/2', '2023/1']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '학년',
                  ),
                  value: dropdownValue3,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue3 = newValue!;
                    });
                  },
                  items: <String>['1학년', '2학년', '3학년', '4학년']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '건물',
                  ),
                  value: dropdownValue4,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue4 = newValue!;
                    });
                  },
                  items: <String>['공대5호관', '공대4호관', '공대3호관']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimeTable(Account('', ''))),
          );
        },
        child: Text('저장'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
