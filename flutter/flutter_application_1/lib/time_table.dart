import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/lecture_analysis.dart';
import 'package:logger/web.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_application_1/firestore_lecture_listview.dart';
import 'lecture.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({super.key});
  @override
  Widget build(BuildContext context) {
    void showDialogAddMajor() {
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
                      showDialogAddMajor();
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
          child: const ScheduleTable(),
        ),
      ),
    );
  }
}


class ScheduleTable extends StatefulWidget {
  const ScheduleTable({super.key});
  @override
  ScheduleTableState createState() => ScheduleTableState();
}

class ScheduleTableState extends State<ScheduleTable> {
  final List<String> week = ['월', '화', '수', '목', '금', '토', '일'];
  late Map<String, dynamic> lectureColor;

  var kColumnLength = 22;
  var maxTime = 11;
  var maxDay = 5;
  var logger = Logger();

  double kFirstColumnHeight = 20;
  double kBoxSize = 55; // kBoxSize 변수의 값을 줄임
  double kButtonWidth = 163; // 버튼의 가로 크기를 조절할 수 있는 변수
  /* 스터브들 */
  late final DocumentReference basketRef;

  late List<Lecture> lectureList;

  Future<void> initLectureList() async {
    try{
      const String defaultDirectory = 'UNIV_LIST';
      const String accountCollection = 'ACCOUNT_INFO';
      const String accountId = '3naGNQCcm3SVumZY2HTe';
      const String docTag = '2024_0';
      const String lectureBasket = 'LECTURE_BASKET';
      const String identifier = 'JBNU';
      const String lectureCollection = 'OPEN_LECTURE_2024_0';
      basketRef = FirebaseFirestore.instance.collection(accountCollection)
      .doc(accountId)
      .collection(lectureBasket)
      .doc(docTag);
      DocumentSnapshot basket = await basketRef.get();
      List<String?>? documentData = (basket.data() as Map<String, dynamic>?)?.keys.toList().cast<String>();
      lectureList = [];
      for (int i = 0; i < documentData!.length; i++) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(defaultDirectory)
          .doc(identifier)
          .collection(lectureCollection)
          .doc(documentData[i])
          .get();
        Lecture lecture = Lecture.fromFirestore(doc);
        // List<String> schedule = lecture.properties["시간"]!.split(',');
        // maxTime = int.parse(lecture.properties["시간"]!.split('-')[0].split(' ')[1]) > maxTime ? int.parse(lecture.properties["시간"]!) : maxTime;
        // maxDay = week.indexOf(lecture.properties["시간"].last!.split(" ")[0]) > maxDay ? week.indexOf(lecture.properties["시간"]!.split(" ")[0]) : maxDay;
        lectureList.add(lecture);
        logger.i('${lecture.lectureId} ${lecture.properties["과목명"]} ${lecture.properties["시간"]}');
      }
    } catch (e) {
      logger.e(e);
    }
    RandomColor randomColor = RandomColor();
    lectureColor =
    {
      for (Lecture lecture in lectureList)
        lecture.lectureId : randomColor.randomColor(
          colorHue: ColorHue.multiple(colorHues: [ColorHue.blue, ColorHue.green, ColorHue.purple]))
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initLectureList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 로딩 중일 때 표시할 위젯
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // 오류가 발생했을 때 표시할 위젯
        } else {
          // for (var i = 0; i < lectureList.length; i++) {
          //   String day = week.sublist(3, week.length).where(
          //       (day) => lectureList[i].properties["시간"]!.contains(day)
          //     ).last.split(" ")[0];
          //   maxDay = week.indexOf(day);
          // }
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
                      // 목요일까지가 최소, 금요일부터는 강의 리스트에 있을 시 표시
                      for (var i = 0; i < maxDay; i++) ...buildDayColumn(i)
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
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            maxTime*2 + 1,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              // 각 행에 시간 표시
              int hour = 8 + (index ~/ 2); // 8부터 시작하여 1시간 간격으로 증가
              // if (만약 과목 리스트에 8과 17시 이상이 없으면) return const SizedBox.shrink(); // 18:00 이후에는 빈 공간을 반환
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
                    // if (index ~/ 2 > 18) {
                      // return const SizedBox.shrink();
                    // } else{
                      // 과목 시간대 중복일 시, 충돌 이벤트 처리 필수 - 여기 수준에서 진행될 것인지, 강의 변경 화면에서 진행할 것인지에 대한 논의
                      // lectureList.firstWhereOrNull((element) => element.properties["시간"]!.contains('$date ${index ~/ 2}'));
                    // }
                    return SizedBox(
                      height: kBoxSize,
                      width: kButtonWidth, // 버튼의 가로 크기를 kButtonWidth로 설정
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color:
                          // 추후 -A -B 사용시 1, 10 구분 오류 필요
                            // lectureList.any((element)=>element.properties["시간"]!.contains('$date ${index ~/ 2}'))
                            lectureList.any(
                              (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}'))
                            ? lectureColor[
                              lectureList.firstWhere(
                                (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}')).lectureId
                            ]// 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                            : Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed: (){
                            lectureList.any(
                              (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}')
                                )
                            ? showDialogExist(
                              lectureList.firstWhere(
                                (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}'))
                                )
                            : showDialogNotExist();
                          },
                          child : Text(
                            lectureList.any(
                              (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}')
                                )
                            ? '${
                              lectureList.firstWhere(
                                (element)=>element.properties["시간"]!.replaceAll(
                                RegExp(r'-[AB]'),'').split(",").contains('$date ${index ~/ 2}'))
                                .properties["과목명"]}'//\n ${
                                //   lectureList.firstWhere((element) => element.properties[
                                // "시간"]!.contains('$date ${index ~/ 2}')).properties["담당교수"]
                                // }' // 값이 매칭될 때의 텍스트 // 값이 매칭될 때의 텍스트
                            : '' // 값이 매칭되지 않을 때의 텍스트
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
  void showDialogExist(Lecture lecture){
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
                  // Remove the 'capital' field from the document
                  final updates = <String, dynamic>{
                    lecture.id : FieldValue.delete(),
                  };
                  basketRef.update(updates);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                child: const Text("삭제"),
              ),
            ),
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
  void showDialogNotExist(){
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
                    minimumSize: MaterialStateProperty.all<Size>(const Size(0, 0)
                    ),
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
                          showNormalLectureList();
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
void showNormalLectureList(){
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
