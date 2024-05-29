from fastapi import FastAPI
from database import get_courses
from course_recommendation import recommend_alternative_courses

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
        dict: 강의 목록 (key: 강좌ID, value: 강좌 정보 딕셔너리)
    """
    courses = get_courses()
    return {"courses": courses}

@app.get("/recommend_courses/{department}/{grade}/{time}/{course_type}")
def read_recommended_courses(department: str, grade: int, time: str, course_type: str):
    """
    주어진 학과, 학년, 시간, 이수 구분에 대해 대체 가능한 강의를 추천합니다.

    Args:
        department: 학과 이름 (예: "컴퓨터공학과")
        grade: 학년 (예: 1, 2, 3, 4)
        time: 시간 (예: "월1", "화2")
        course_type: 이수 구분 (예: "전공선택", "교양", "일반선택")

    Returns:
        dict:
            - alternative_courses: 대체 가능한 강의 ID 목록 (리스트)
            - courses: 전체 강의 목록 (딕셔너리)
    """
    courses = get_courses()
    alternative_course_ids = recommend_alternative_courses(department, grade, time, course_type)
    alternative_courses = [courses[course_id] for course_id in alternative_course_ids]
    return {"alternative_courses": alternative_courses, "courses": courses}


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
    department_courses = [course for course in courses.values() if course.get('department') == department]
    return {"courses": department_courses}
