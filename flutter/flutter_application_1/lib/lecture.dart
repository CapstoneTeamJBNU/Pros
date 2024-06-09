import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  Map<String, String> properties = {
    "이수구분": '',
    "수강인원": '',
    "허용인원": '',
    "수강정원": '',
    "공개여부": '',
    "비공개사유": '',
    "과목명": '',
    "분반": '',
    "학점": '',
    "시간": '',
    "담당교수": '',
    "강의언어(Language)": '',
    "교양영역구분": '',
    "교양영역상세구분": '',
    "SW교양": '',
    "상대/절대평가구분": '',
    "수업운영방향": '',
    "인증구분": '',
    "수강대상": '',
    "설강여부": '',
    "강의실": '',
    "시간.": '',
    "학과": '',
    "수업시간": '',
    "강의계획서": '',
  };
  late String lectureId;

  Lecture({String classification="", String assignedNum="", String allowedNum="", String totalNum="",
  String visibility="", String invisibleReason="", String title="", String roomNum="",
  String score="", String totalTime="", String professor="", String language="",
  String classificLiberal="", String specificClassificLiberal="", String swLiberal="", String relativeAbsolute="",
  String lectureDirection="", String certCategory="", String lectureTarget="", String roomOffered="",
  String lectureRoom="", String dayTime="", String lectureMajor="", String lectureTime="",
  String lectureCode=""}
  ) {
    properties["이수구분"] = classification;
    properties["수강인원"] = assignedNum;
    properties["허용인원"] = allowedNum;
    properties["수강정원"] = totalNum;
    properties["공개여부"] = visibility;
    properties["비공개사유"] = invisibleReason;
    properties["과목명"] = title;
    properties["분반"] = roomNum;
    properties["학점"] = score;
    properties["시간"] = totalTime;
    properties["담당교수"] = professor;
    properties["강의언어(Language)"] = language;
    properties["교양영역구분"] = classificLiberal;
    properties["교양영역상세구분"] = specificClassificLiberal;
    properties["SW교양"] = swLiberal;
    properties["상대/절대평가구분"] = relativeAbsolute;
    properties["수업운영방향"] = lectureDirection;
    properties["인증구분"] = certCategory;
    properties["수강대상"] = lectureTarget;
    properties["설강여부"] = roomOffered;
    properties["강의실"] = lectureRoom;
    properties["시간."] = dayTime;
    properties["학과"] = lectureMajor;
    properties["수업시간"] = lectureTime;
    properties["강의계획서"] = lectureCode;
  }
  factory Lecture.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Lecture lecture = Lecture();
    lecture.id = doc.id;
    lecture.properties = data.map((key, value) => MapEntry(key, value.toString()));
    return lecture;
  }
  
  set id(String id) {}
}