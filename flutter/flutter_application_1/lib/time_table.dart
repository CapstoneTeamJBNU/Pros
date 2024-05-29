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
    // 해당 생성자 지점에서 계정 강의 리스트에 대한 동기화 요청 작성 필요
    // 입력 요소 = 파이어베이스 도큐멘트 스타일
    lectureList.add(Lecture(
      '교양','50','50','50',
      '공개','','공업수학','2',
      '1','3','3','최영하',
      '한국어','','','상대평가Ⅰ',
      '','일반','전체(학부)','일반',
      '전주:공과대학 4호관 401-1','월 6-A,월 6-B,월 7-A,월 7-B,수 8-A,수 8-B','','50분',
      '강의계획서'
    )
    );
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
    late List lectureDate = [];
    late String date;
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
                    // 요일 인자
                    date = week.elementAt(index),
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
                    if (index ~/ 2 > 18) return SizedBox.shrink();
                    else{
                      // 과목 시간대 중복일 시, 충돌 이벤트 처리 필수 - 여기 수준에서 진행될 것인지, 강의 변경 화면에서 진행할 것인지에 대한 논의
                      // 리스트의 전역변수화? 아니면 별도의 스테이지가 있어야 하는가?
                      lectureDate = List.generate(lectureList.length, (i) => {
                        lectureList[i].properties["과목명"] : (
                          lectureList[i].properties["시간."]?.split(',') ?? []
                          ).map((time) => time.split('-').first).toList()
                        }
                        );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: TextButton(
                        onPressed: (){
                          // 해당 부분에서 사용자 상호작용에 대한 처리 작성 필요
                          Logger().d('Pressed ${date} ${index ~/ 2}');
                        },
                        child : Text(
                          lectureDate.any((element) => element.values.first.contains('${date} ${index ~/ 2}'))
                          ? '${lectureDate.firstWhere((element) => element.values.first.contains('${date} ${index ~/ 2}')
                          ).keys.first}' // 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                          : '' // 값이 매칭되지 않을 때의 텍스트
                        ),
                      ),
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