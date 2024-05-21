//틀 만들기
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

import 'lecture.dart';

class ScheduleTable extends StatefulWidget{
  const ScheduleTable({super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();

}

class ScheduleTableState extends State{
  
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  
  late List<Lecture> lectureList;

  String targ = '';
  
ScheduleTableState(){
  lectureList = [];
  lectureList.add(Lecture('소프트웨어공학캡스톤프로젝트', '수 7-A,수 7-B,수 8-A,수 8-B,수 9-A,수 9-B,수 10-A,수 10-B', '김순태', '전주:공과대학 5호관 507'));
}

  var kColumnLength = 30;
  double kFirstColumnHeight = 20;
  double kBoxSize = 52;

  @override
  void dispose(){
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Flexible(
              child: SizedBox(
                height: kColumnLength / 2 * kBoxSize + kColumnLength,
                child: Row(children: [
                  buildTimeColumn(),
                  for(var i = 0; i < week.length; i++)...buildDayColumn(i)
                ],
                )
              )
              )
            ],
          )
          )
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
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 8}')),
            );
          },
        ),
      ],
    ),
  );
}


List<Widget> buildDayColumn(int index) {
  int dayIdx = index;
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
                  week.elementAt(dayIdx),
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
                  targ = '${week.elementAt(dayIdx)} ${index ~/ 2}${index % 2 == 0 ? '-A' : '-B'}';
                  // 인덱스 확인용 구문
                  // Logger().d('targ : $targ');
                  
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                    ),
                    child: Center(
                      child: lectureList.contains(Lecture(
                      '',
                      targ,
                      '',
                      '',
                      ))
                      ? Text(lectureList.firstWhere((lecture) => lecture.timeSlot == targ).title)
                      : Text(index.toString()),
                    )
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