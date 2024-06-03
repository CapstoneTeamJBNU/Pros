import firebase_admin
from firebase_admin import credentials, firestore
import os

# Firebase 초기화 (서비스 계정 키 파일 경로 설정)
cred = credentials.Certificate(os.getcwd()+'/fastapi-project/capstonejbnuteam8-firebase-adminsdk-oyel5-b0dfcb4f59.json')  
firebase_admin.initialize_app(cred)

# Firestore 클라이언트 생성
db = firestore.client()

def get_courses():
    """
    Firestore에서 강의 목록을 가져오고 전처리하는 함수
    """
    courses_ref = db.collection('UNIV_LIST').document('JBNU').collection('OPEN_LECTURE_2024_0')
    docs = courses_ref.get()

    courses = {}
    for doc in docs:
        course_data = doc.to_dict()

        # 시간 정보 전처리
        time_str = course_data['시간']
        times = [time.split('-')[0] for time in time_str.split(',')]  # "월1-A" -> "월1"

        # 건물 정보 전처리
        building = course_data['강의실'].split(':')[1] if ':' in course_data['강의실'] else ''

        # 학년 정보 전처리 ("학과: 소프트웨어공 3" 형식)
        department_and_grade = course_data.get('학과', '')
        if department_and_grade and department_and_grade[-1].isdigit():
            grade = int(department_and_grade[-1])
            department = department_and_grade[:-2]  # 학과 이름 추출
        else:
            grade = None
            department = department_and_grade  # 학과 이름만 저장

        courses[doc.id] = {
            'course_name': course_data['과목명'],
            'time': times, # 요일별 수업시간
            'type': course_data['이수구분'], # 전공 필수, 전공 선택, 교양(교양 세분화 고려 필요), 일반 선택
            'department': department, # 학과명
            'building': building, # 강의실
            'grade': grade # 학년
        }

    return courses