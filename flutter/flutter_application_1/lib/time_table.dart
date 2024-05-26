import 'package:flutter/material.dart';

class TimeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('시간표 생성'),


          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(20), // 외부 여백 추가
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), // 테두리 추가
          ),
          child: ScheduleTable(),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatefulWidget {
  const ScheduleTable({Key? key}) : super(key: key);
  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  var week = {
    '월': {},
    '화': {},
    '수': {},
    '목': {},
    '금': {},
  };
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 55; // kBoxSize 변수의 값을 줄임
  double kButtonWidth = 163; // 버튼의 가로 크기를 조절할 수 있는 변수

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
              if (hour > 18) return SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
              return SizedBox(
                height: kBoxSize,
                child: Center(
                  child: Text('${hour.toString().padLeft(2, '0')}:00'), // 시간을 텍스트로 표시
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int dayIndex) {
    // 요일 이름 리스트
    const days = ['월', '화', '수', '목', '금'];
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
                    week.keys.elementAt(dayIndex),
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
                    int hour = 8 + (index ~/ 2);
                    if (hour > 18) return SizedBox.shrink();
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼이 눌렸을 때의 동작
                          int buttonNumber = (index ~/ 2) + 1;
                          print('Button ${days[dayIndex]}-$buttonNumber pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // 버튼 배경 색상 투명
                          shadowColor: Colors.transparent, // 그림자 색상 투명
                          elevation: 0, // 그림자 없애기
                          side: BorderSide.none, // 테두리 없애기
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('${days[dayIndex]}-${(index ~/ 2) + 1}'), // 버튼에 고유 번호 표시
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
