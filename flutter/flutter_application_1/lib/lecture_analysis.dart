import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:graphic/graphic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PolarCoord Example')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: PieChart(),
          ),
        ),
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  const PieChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 예제 데이터
    final data = [
      {'category': '거리점수', 'value': 3},
      {'category': '이수구분별', 'value': 3},
      {'category': '강의평점', 'value': 2.84},
      {'category': '강의긍정도', 'value': 2.67},
    ];
    return graphic.Chart(
      data: data,
      variables: {
        'category': graphic.Variable(
          accessor: (Map map) => map['category'] as String,
        ),
        'value': graphic.Variable(
          accessor: (Map map) => map['value'] as num,
          scale: graphic.LinearScale(
            min: 0,
            max: 3,
            tickCount: 1,
          )
          ,
        ),
      },
      coord: graphic.PolarCoord(),
      marks: [
        graphic.IntervalMark(
          size: graphic.SizeEncode(
            variable: 'value',
            values: [0,3],
          ),
          color: graphic.ColorEncode(
            variable: 'category',
            values: Defaults.colors10,
          ),
          label: graphic.LabelEncode(
            encoder: (tuple) => Label(
              '${tuple['category']} ${tuple['value']}',
            ),
        )
        ),
      ],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
    );
  }
}