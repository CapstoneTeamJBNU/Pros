commit 7c8d4326f4a3c0bff68fecc5cac1369627c32911
Author: Donny_kor <gisu0314@gmail.com>
Date:   Fri Jun 7 20:13:52 2024 +0900

    manual data drive

diff --git a/.DS_Store b/.DS_Store
index 161d1d8..fc55cf2 100644
Binary files a/.DS_Store and b/.DS_Store differ
diff --git a/fastapi-project/course_input.txt b/fastapi-project/course_input.txt
new file mode 100644
index 0000000..e69de29
diff --git a/fastapi-project/course_recommendation_copy.py b/fastapi-project/course_recommendation_copy.py
index 910c06c..bc74112 100644
--- a/fastapi-project/course_recommendation_copy.py
+++ b/fastapi-project/course_recommendation_copy.py
@@ -6,6 +6,10 @@ num_ants = 10
 evaporation_rate = 0.5
 max_iterations = 100
 
+INPUT = 'course_input.txt'
+import sys
+sys.stdin = open(INPUT, "r")
+
 def recommend_alternative_courses_weight(department, grade, time, course_type):
     # Firestore에서 전처리된 강의 정보 가져오기
     courses = get_courses()
@@ -76,3 +80,18 @@ def recommend_alternative_courses_weight(department, grade, time, course_type):
     alternative_courses = [course_id for course_id in pheromone if pheromone[course_id] > 1.0]
     sorted_courses = sorted(alternative_courses, key=lambda course_id: pheromone[course_id], reverse=True)
     return sorted_courses[:3]
+
+
+if __name__ == '__main__':
+    # 선과목 입력
+    predecision = ['공업수학', '이산수학']
+
+    # 학과, 학년, 시간대, 이수 구분 입력
+    department = input()
+    grade = int(input())
+    time = input()
+    course_type = input()
+    # 가중치 조절
+    
+    result = recommend_alternative_courses_weight(department, grade, time, course_type)
+    print(result)
\ No newline at end of file
diff --git a/flutter/flutter_application_1/lib/time_table.dart b/flutter/flutter_application_1/lib/time_table.dart
index d7d9d1e..097cfc4 100644
--- a/flutter/flutter_application_1/lib/time_table.dart
+++ b/flutter/flutter_application_1/lib/time_table.dart
@@ -133,38 +133,6 @@ class ScheduleTableState extends State<ScheduleTable> {
   }
 
   Expanded buildTimeColumn() {
-
-    /* 테스트용 로컬 데이터 */
-    // lectureList = [
-    //     Lecture(
-    //   '교양','50','50','50',
-    //   '공개','','공업수학','2',
-    //   '1','3','3','최영하',
-    //   '한국어','','','상대평가Ⅰ',
-    //   '','일반','전체(학부)','일반',
-    //   '전주:공과대학 4호관 401-1','월 6-A,월 6-B,월 7-A,월 7-B,수 8-A,수 8-B','','50분',
-    //   '강의계획서'
-    // ),
-    // Lecture(
-    //   '교양','50','50','50',
-    //   '공개','','(KNU10)한옥개론','2',
-    //   '1','3','3','최영하',
-    //   '한국어','','','상대평가Ⅰ',
-    //   '','일반','전체(학부)','일반',
-    //   '전주:공과대학 4호관 401-1','월 1-A,월 1-B,월 2-A,월 2-B,수 7-A,수 7-B','','50분',
-    //   '강의계획서'
-    // ),
-    // Lecture(
-    //   '교양','50','50','50',
-    //   '공개','','캡스톤디자인','2',
-    //   '1','3','3','최영하',
-    //   '한국어','','','상대평가Ⅰ',
-    //   '','일반','전체(학부)','일반',
-    //   '전주:공과대학 4호관 401-1','화 6-A, 화 6-B, 화 7-A,화 7-B, 목 7-A,목 7-B','','50분',
-    //   '강의계획서'
-    // ),
-    // ];
-
     return Expanded(
       child: Column(
         children: [
diff --git "a/python/EXCEL/~$\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx" "b/python/EXCEL/~$\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx"
new file mode 100644
index 0000000..c522604
Binary files /dev/null and "b/python/EXCEL/~$\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx" differ
diff --git "a/python/EXCEL/\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx" "b/python/EXCEL/\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx"
index 04e0099..93fdaab 100644
Binary files "a/python/EXCEL/\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx" and "b/python/EXCEL/\352\260\234\354\204\244\352\265\220\352\263\274\353\252\251\353\252\251\353\241\235_1716796657845.xlsx" differ
diff --git a/python/manual_input.py b/python/manual_input.py
new file mode 100644
index 0000000..81e05c0
--- /dev/null
+++ b/python/manual_input.py
@@ -0,0 +1,20 @@
+import pandas as pd
+import firebase_admin
+from firebase_admin import credentials
+from firebase_admin import firestore
+
+# Initialize Firebase Admin SDK
+cred = credentials.Certificate('./fastapi-project/capstonejbnuteam8-firebase-adminsdk-oyel5-b0dfcb4f59.json')
+firebase_admin.initialize_app(cred)
+
+# Read the Excel file
+df = pd.read_excel('./python/EXCEL/개설교과목목록_1716796657845.xlsx', sheet_name='OPEN_LECTURE_2024_0')
+
+# Get the Firestore client
+db = firestore.client()
+    
+# Add the data to Firestore
+for index, row in df.iterrows():
+    doc_data = row.fillna("").to_dict()
+    key = doc_data.pop('해시')
+    db.collection('UNIV_LIST').document('JBNU').collection('OPEN_LECTURE_2024_0').document(key).set(doc_data)
\ No newline at end of file
