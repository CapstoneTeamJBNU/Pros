#import firebase_admin
#from firebase_admin import credentials, firestore
from test_data import mock_courses

# Firebase 초기화 (서비스 계정 키 파일 경로 설정)
#cred = credentials.Certificate('/Users/yosmac/Desktop/fastapi-project/capstonejbnuteam8-firebase-adminsdk-oyel5-b0dfcb4f59.json')  
#firebase_admin.initialize_app(cred)

# Firestore 클라이언트 생성
#db = firestore.client()

'''
def get_courses():
    """
    Firestore에서 강의 목록을 가져오고 전처리하는 함수

    Returns:
        dict: 전처리된 강의 정보 딕셔너리 (key: 강좌ID, value: 강좌 정보 딕셔너리)
    """
    try:
        courses_ref = db.collection('UNIV_LIST').document('JBNU').collection('OPEN_LECTURE_2024_0')
        docs = courses_ref.get()

        courses = {}
        for doc in docs:
            course_data = doc.to_dict()

            # 시간 정보 전처리
            time_str = course_data['시간']
            times = [time.split('-')[0] for time in time_str.split(',')]

            # 건물 정보 전처리 (단과대학 추출)
            building_str = course_data['강의실']
            split_building = building_str.split(':')
            if len(split_building) > 1:  # 분리된 리스트에 2개 이상의 요소가 있는 경우
                building = split_building[1].split()[0]
            else:
                building = building_str  # 콜론이 없는 경우 원래 문자열 사용

            # 학년 정보 전처리 ("학과: 소프트웨어공 3" 형식)
            department_and_grade = course_data.get('학과', '')
            if department_and_grade and department_and_grade[-1].isdigit():
                grade = int(department_and_grade[-1])
                department = department_and_grade[:-2]
            else:
                grade = None
                department = department_and_grade

            courses[doc.id] = {
                'course_name': course_data['과목명'],
                'time': times,
                'type': course_data['이수구분'],
                'department': department,
                'building': building,
                'grade': grade
            }

        return courses
    except Exception as e:
        print(f"Error fetching courses from Firestore: {e}")
        return {}  # 오류 발생 시 빈 딕셔너리 반환
        '''
def get_courses():
    """
    (임시) Mock 데이터를 반환하는 함수

    Returns:
        dict: 전처리된 강의 정보 딕셔너리 (key: 강좌ID, value: 강좌 정보 딕셔너리)
    """
    return mock_courses
