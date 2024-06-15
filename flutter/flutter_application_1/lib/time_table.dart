import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/lecture_analysis.dart';
import 'package:logger/web.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_application_1/firestore_lecture_listview.dart';

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
          actions: <Widget>[
            Container(
              width: 240, // Increased width to accommodate the button and text field
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Spacer(), // 왼쪽 여백을 추가하여 버튼을 중간으로 밀어냄

                  TextButton(
                    onPressed: () {
                      showDialogAddMajor(context);
                      // + 버튼 클릭 시 다이얼로그 출력
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.grey,
                      // 내부 간격을 없애기 위해 zero로 설정
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.black), // 아이콘 추가
                        SizedBox(width: 0.1), // 아이콘과 텍스트 사이 간격 조정
                        Text('전공',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // 텍스트 추가
                      ],
                    ),
                  ),

                  Spacer(), // 오른쪽 여백을 추가하여 검색 필드와의 간격 유지
                ],
              ),
            ),

            SizedBox(
              width: 240, // Fixed width for the search TextField
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey,
                  hintText: '검색',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                onChanged: (value) {
                  // 검색 로직 추가
                },
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: ScheduleTable(account),
        ),
      ),
    );
  }
}


class ScheduleTable extends StatefulWidget {
  final Account account;
  const ScheduleTable(this.account, {super.key});

  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 55;
  double kButtonWidth = 163;

  late List<Lecture> lectureList;

  Future<void> initLectureList() async {
    List<Lecture> result = [];

    const String defaultDirectory = 'UNIV_LIST';
    const String accountCollection = 'ACCOUNT_INFO';
    const String accountId = '3naGNQCcm3SVumZY2HTe';
    const String docTag = '2024_0';
    const String lectureBasket = 'LECTURE_BASKET';
    const String identifier = 'JBNU';
    const String lectureCollection = 'OPEN_LECTURE_2024_0';

    var logger = Logger();
    try {
      DocumentSnapshot basketQuery = await FirebaseFirestore.instance.collection(accountCollection)
          .doc(accountId)
          .collection(lectureBasket)
          .doc(docTag)
          .get();
      List<String?>? documentData = (basketQuery.data() as Map<String, dynamic>?)?.values.toList().cast<String>();

      for (int i = 0; i < documentData!.length; i++) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(defaultDirectory)
            .doc(identifier)
            .collection(lectureCollection)
            .doc(documentData[i])
            .get();
        result.add(Lecture.fromFirestore(doc));
        // logger.i('${result[i].lectureId} ${result[i].properties["과목명"]} ${result[i].properties["시간"]}');
      }
    } catch (e) {
      logger.e(e);
    }
    lectureList = result;
  }

  @override
  void initState() {
    super.initState();
    // initLectureList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 강의명-색상 매핑 딕셔너리 (전역 변수로 선언)
    final Map<String, Color> courseColors = {};

    Color getCourseColor(String courseName) {
      if (!courseColors.containsKey(courseName)) {
        courseColors[courseName] = RandomColor().randomColor(
            colorHue: ColorHue.multiple(colorHues: [ColorHue.blue, ColorHue.green, ColorHue.purple])
        );
      }
      return courseColors[courseName]!;
    }

    return FutureBuilder(
      future: initLectureList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중일 때 표시할 위젯
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 오류가 발생했을 때 표시할 위젯
        } else {
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
      },
    );
  }

  Expanded buildTimeColumn() {

    /* 테스트용 로컬 데이터 */
    // lectureList = [
    //     Lecture(
    //   '교양','50','50','50',
    //   '공개','','공업수학','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','월 6-A,월 6-B,월 7-A,월 7-B,수 8-A,수 8-B','','50분',
    //   '강의계획서'
    // ),
    // Lecture(
    //   '교양','50','50','50',
    //   '공개','','(KNU10)한옥개론','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','월 1-A,월 1-B,월 2-A,월 2-B,수 7-A,수 7-B','','50분',
    //   '강의계획서'
    // ),
    // Lecture(
    //   '교양','50','50','50',
    //   '공개','','캡스톤디자인','2',
    //   '1','3','3','최영하',
    //   '한국어','','','상대평가Ⅰ',
    //   '','일반','전체(학부)','일반',
    //   '전주:공과대학 4호관 401-1','화 6-A, 화 6-B, 화 7-A,화 7-B, 목 7-A,목 7-B','','50분',
    //   '강의계획서'
    //   ),
    // ];

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
              // if (hour > 18) return const SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
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
    RandomColor randomColor = RandomColor();

    // 강의명-색상 매핑 딕셔너리
    final Map<String, Color> courseColors = {};

    Color getCourseColor(String courseName) {
      if (!courseColors.containsKey(courseName)) {
        courseColors[courseName] = randomColor.randomColor(
            colorHue: ColorHue.multiple(colorHues: [ColorHue.blue, ColorHue.green, ColorHue.purple])
        );
      }
      return courseColors[courseName]!;
    }

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
                    if (index ~/ 2 > 18) {
                      return const SizedBox.shrink();
                    } else {
                      // 강의 시간대 중복 처리
                      lectureDate = List.generate(
                        lectureList.length,
                            (i) => {
                          lectureList[i].properties["과목명"]: (lectureList[i].properties["시간"]?.split(',') ?? [])
                              .map((time) => time.split('-').first)
                              .toList()
                        },
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                              ? getCourseColor(lectureDate.firstWhere(
                                  (element) => element.values.first.contains('$date ${index ~/ 2}')).keys.first)
                              : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: () {
                            lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                                ? showDialogExist(context)
                                : showDialogNotExist(context);
                          },
                          child: Text(
                            lectureDate.any((element) => element.values.first.contains('$date ${index ~/ 2}'))
                                ? '${lectureDate.firstWhere(
                                    (element) => element.values.first.contains('$date ${index ~/ 2}')).keys.first}'
                                : '', // 값이 매칭되지 않을 때의 텍스트
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // 두꺼운 글씨체
                              color: Colors.white, // 흰색 글씨
                            ),
                          ),
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
void showDialogExist(context){
  showDialog(
      context: context,
      barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return AlertDialog(
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  child: TextButton(
                      onPressed: () {
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                      ),
                      child: const Text("삭제")
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 10)),
                Align(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); //창 닫기
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                      ),
                      child: const Text("X")
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7, // 화면 너비의 70%
                  height: MediaQuery.of(context).size.height * 0.7, // 화면 높이의 70%
                  child: const PieChart(),
                ),
                const SizedBox(
                    child:Text('강의 평가 내용 수록용\n임시 영역')
                )
              ],
            ),
          ],
        );
      }
      )
  );
}

void showDialogNotExist(context){
  showDialog(
      context: context,
      barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); //창 닫기
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                      minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)),
                    ),
                    child: const Text("X")
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text("과목 없는 곳"),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text("교양"),
                    ),
                    const SizedBox(width: 20),
                    OutlinedButton(
                      onPressed: () {
                        showNormalLectureList(context);
                      },
                      child: const Text("일선"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      )
  );
}

void showDialogAddMajor(context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 바깥 영역 터치 시 닫지 않음
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 창 닫기
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(0, 0)),
                ),
                child: const Text("X"),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text("전공과목 추가하기"),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("전필"),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text("전선"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
void showNormalLectureList(context){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return const AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: LectureList(),
          ),
        );
      })
  );
}

void showLiberalArtLectureList(){

}
