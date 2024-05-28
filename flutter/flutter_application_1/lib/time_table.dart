import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import 'account.dart';
import 'lecture.dart';

class TimeTable extends StatelessWidget {
  final Account account;
  const TimeTable(this.account, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('수업 시간표'),
        ),
        body: Container(
          margin: EdgeInsets.all(20), // 외부 여백 추가
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // 테두리 추가
          ),
          child: ScheduleTable(account),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatefulWidget {
  const ScheduleTable(Account account,{super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 55; // kBoxSize 변수의 값을 줄임
  double kButtonWidth = 163; // 버튼의 가로 크기를 조절할 수 있는 변수
  late List<Lecture> lectureList;
  ScheduleTableState(){
    lectureList = [];
    lectureList.add(Lecture(
      '교양','50','50','50',
      '공개','','공업수학','2',
      '1','3','3','최영하',
      '한국어','','','상대평가Ⅰ',
      '','일반','전체(학부)','일반',
      '전주:공과대학 4호관 401-1','월 6,월 7,월 8,화 6,화 7,화 8,수 6,수 7,수 8,목 6,목 7,목 8,금 6,금 7,금 8','','50분',
      '강의계획서'
  ));
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kColumnLength / 2 * kBoxSize + kColumnLength,
            child: Row(
              children: [
                buildTimeColumn(),
                for (var i = 0; i < week.length; i++) ...buildDayColumn(i)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              // 각 행에 시간 표시
              int hour = 8 + (index ~/ 2); // 8부터 시작하여 1시간 간격으로 증가
              if (hour > 18) return const SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
              return SizedBox(
                height: kBoxSize,
                child: Center(
                  child: Text(hour.toString().padLeft(2, '0')), // 시간을 텍스트로 표시
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    late String textTemp;
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    week.elementAt(index),
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    // 19:00 이후의 빈칸을 삭제
                    int hour = index ~/ 2;
                    if (hour > 5) return SizedBox.shrink();
                    if (index ~/ 2 > 0 && index % 2 == 1){
                      textTemp = "캡스톤";
                    }
                    else {
                      textTemp = "";
                    }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: TextButton(
                        onPressed: (){
                          Logger().d('Pressed ${week.elementAt(index ~/ 2)} ${index ~/ 2}');
                        },
                        child: Text(
                          // (lectureList.firstWhereOrNull(
                          // (lecture) => lecture.properties["시간."] == '${week.elementAt(index ~/ 2)} ${index ~/ 2}'
                          // )?.properties["과목명"]) ?? ''
                          textTemp
                        )
                        ), // 빈칸 버튼
                      // child: ElevatedButton(
                      //   onPressed: () {
                      //     // 버튼이 눌렸을 때의 동작
                        // },
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: Colors.transparent, // 버튼 배경 색상 투명
                        //   shadowColor: Colors.transparent, // 그림자 색상 투명
                        //   elevation: 0, // 그림자 없애기
                        //   side: BorderSide.none, // 테두리 없애기
                        // ),
                        // child: Text(
                        // (lectureList.firstWhereOrNull(
                        //   (lecture) => lecture.properties["시간."] == '${week.elementAt(index ~/ 2)} ${index ~/ 2}'
                        //   )?.properties["과목명"]) ?? ''
                        // ), // 빈칸 버튼
                      // ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }
}
extension FirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}