from fastapi import FastAPI
from database import get_courses
from course_recommendation import recommend_courses
from course_recommendation import filter_courses_by_time_and_building

app = FastAPI()

@app.get("/")
def read_root():
    """
    API 루트 엔드포인트

    Returns:
        dict: 환영 메시지
    """
    return {"message": "Welcome to the Course Recommendation API!"}

@app.get("/courses")
def read_courses():
    """
    모든 강의 목록을 반환합니다.

    Returns:
        list: 강좌 정보 딕셔너리의 리스트
    """
    courses = get_courses()
    return courses

# (선택 사항) 특정 학과의 모든 강의 목록을 반환하는 엔드포인트 추가
@app.get("/courses/{department}")
def read_department_courses(department: str):
    """
    특정 학과의 강의 목록을 반환합니다.

    Args:
        department: 학과 이름

    Returns:
        dict:
            - courses: 해당 학과의 강의 목록 (리스트)
    """
    courses = get_courses()
    department_courses = [course for course in courses if course.get('department') == department]
    return {"courses": department_courses}


@app.get("/courses/{department}/{grade}/{course_type}")
def read_filtered_courses(department: str, grade: int, course_type: str):
    """
    학과, 학년, 이수 구분에 따라 필터링된 강의 목록을 반환합니다.

    Args:
        department: 학과 이름 (예: "컴퓨터공학과")
        grade: 학년 (예: 1, 2, 3, 4)
        course_type: 이수 구분 (예: "전공선택", "교양", "일반선택")

    Returns:
        dict:
            - filtered_courses: 필터링된 강의 목록 (리스트)
    """

    courses = get_courses()

    filtered_courses = [
        course
        for course in courses
        if course.get('department', '') == department and
           course.get('grade', None) == grade and
           course.get('type', '') == course_type
    ]

    return {"filtered_courses": filtered_courses}

@app.get("/courses/{time}/{building}")
def read_filtered_courses_by_time_building(time: str, building: str):
    """
    시간대와 건물에 따라 필터링된 강의 목록을 반환합니다.

    Args:
        time: 시간 (예: "월 1", "화 2")
        building: 건물 (예: "공과대학 3호관")

    Returns:
        dict:
            - filtered_courses: 필터링된 강의 목록 (리스트)
    """
    filtered_courses = filter_courses_by_time_and_building(time, building)
    return {"filtered_courses": filtered_courses}

@app.get("/recommend_courses/{department}/{time}/{course_type}")
def read_recommended_courses(department: str, time: str, course_type: str):
    """
    주어진 학과, 시간, 이수 구분에 대해 대체 가능한 강의를 추천합니다.

    Args:
        department: 학과 이름 (예: "컴퓨터공학과")
        time: 시간 (예: "월 1", "화 2")
        course_type: 이수 구분 (예: "교양", "일반선택")

    Returns:
        dict:
            - alternative_courses: 대체 가능한 강의 목록 (리스트)
    """
    alternative_courses = recommend_courses(department, time, course_type)
    return {"alternative_courses": alternative_courses}
