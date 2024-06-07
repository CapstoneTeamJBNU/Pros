from database import get_courses

def recommend_courses(department, time, course_type):
    """
    사용자 조건에 맞는 강의 중 가까우면서 평점이 높은 상위 5개 강의를 추천합니다.

    Args:
        department: 학과 이름 (예: "컴퓨터공학과")
        time: 시간 (예: "월 1", "화 2")
        course_type: 이수 구분 (예: "교양", "일반선택")

    Returns:
        list: 추천 강의 목록 (상위 5개)
    """
    courses = get_courses()

    # 건물 위치 점수 딕셔너리
    building_scores = {
        '공과대학 5호관': 0.04,
        '공과대학 1호관': 0.02,
        '공과대학 9호관': 0.01
    }

    # 교양 과목 필터링
    if course_type == '교양':
        filtered_courses = [
            course
            for course in courses
            if time in course['time'] and course['type'] == '교양' and course.get('rating', None) is not None
        ]
    # 일반 선택 과목 필터링 (타 학과 전공 선택 과목 포함)
    elif course_type == '일반선택':
        filtered_courses = [
            course
            for course in courses
            if time in course['time'] and (course['type'] == '일반선택' or (course['type'] == '전공선택' and course['department'] != department)) and
               course.get('rating', None) is not None
        ]
    else:
        filtered_courses = []


    # 1번 개미: 건물 위치 기반 점수 부여
    def score_by_building(course):
        return building_scores.get(course['building'], 0)  # building_scores에 없는 건물은 0점 처리

    # 2번 개미: 평점 기반 점수 부여
    def score_by_rating(course):
        return float(course['rating'])

    # 각 강의에 점수 부여 및 합산
    scored_courses = []
    for course in filtered_courses:
        building_score = score_by_building(course)
        rating_score = score_by_rating(course)
        total_score = building_score + rating_score
        scored_courses.append((course, total_score))

    # 점수 기준 내림차순 정렬 후 상위 5개 추출
    sorted_courses = sorted(scored_courses, key=lambda x: x[1], reverse=True)[:5]

    return [course[0] for course in sorted_courses]  # 강의 정보만 반환

def filter_courses_by_time_and_building(time, building):
    """
    주어진 시간대와 건물에 해당하는 강의 목록을 필터링합니다.

    Args:
        time: 시간 (예: "월 1", "화 2")
        building: 건물 (예: "공과대학 3호관")

    Returns:
        list: 필터링된 강의 목록 (리스트)
    """
    courses = get_courses()

    filtered_courses = [
        course
        for course in courses  # courses.values() 대신 courses 사용
        if time in course['time'] and building in course.get('building', '')
    ]
    return filtered_courses
