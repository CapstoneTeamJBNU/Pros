//틀 만들기
import 'package:flutter/material.dart';

class ScheduleTable extends StatefulWidget{
  const ScheduleTable({super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();

}

class ScheduleTableState extends State{
  var week = {
    '월' : {},
    '화' : {},
    '수' : {},
    '목' : {},
    '금' : {},
    '토' : {},
    '일' : {}
    };
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
                  week.keys.elementAt(index),
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
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
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