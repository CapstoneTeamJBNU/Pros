'''
import random
from database import get_courses

# 개미 수, 페로몬 증발률, 최대 반복 횟수 등 파라미터 설정
num_ants = 10
evaporation_rate = 0.5
max_iterations = 100

# 단과대학 간 거리 정보
building_distances = {
    ('공과대학', '공과대학'): 0,
    ('공과대학', '인문대학'): 9,
    ('공과대학', '상과대학'): 8,
    ('공과대학', '사회과학대학'): 10,
    ('공과대학', '예술대학'): 10,
    ('공과대학', '농업생명과학대학'): 3,
    ('공과대학', '자연과학대학'): 2,
    ('공과대학', '진수당'): 5,
    ('공과대학', '인문사회관'): 10,
    ('공과대학', '치과대학'): 15,
    ('공과대학', '생활과학대학'): 10
}

def recommend_alternative_courses(department, grade, time, course_type, current_building):
    courses = get_courses()

    # 현재 건물의 단과대학 추출
    current_college = current_building.split()[0]

    # 강의 필터링 (시간, 이수 구분, 학과 - 전공 선택 과목인 경우에만)
    filtered_courses = {
        course_id: course_data
        for course_id, course_data in courses.items()
        if time in course_data['time'] and course_data['type'] == course_type and
           (course_type != '전공선택' or (course_data.get('department', '') == department and
                                        course_data.get('grade', None) == grade))
    }

    # 페로몬 초기값 설정
    pheromone = {course_id: 1.0 for course_id in filtered_courses}

    # 개미 이동 함수 (단과대학 거리 고려)
    def move_ant(ant, time):
        available_courses = [
            course_id
            for course_id in filtered_courses
            if time in filtered_courses[course_id]['time']
        ]

        # 페로몬 농도와 단과대학 거리를 고려하여 다음 강의 선택
        probabilities = [
            pheromone[course_id] * (1 / (building_distances.get((current_college, filtered_courses[course_id]['building']), 1) + 1))
            for course_id in available_courses
        ]
        total_probability = sum(probabilities)
        if total_probability == 0:
            return []
        probabilities = [p / total_probability for p in probabilities]
        next_course_id = random.choices(available_courses, weights=probabilities)[0]
        ant.append(next_course_id)

    # 페로몬 업데이트 함수
    def update_pheromone(ants):
        for course_id in pheromone:
            pheromone[course_id] *= evaporation_rate
        for ant in ants:
            for course_id in ant:
                pheromone[course_id] += 1 / len(ant)

    # 메인 루프
    for iteration in range(max_iterations):
        ants = [[] for _ in range(num_ants)]
        for ant in ants:
            move_ant(ant, time)
        update_pheromone(ants)

    # 추천 결과 반환 (페로몬 농도 상위 3개 강의)
    alternative_courses = [course_id for course_id in pheromone if pheromone[course_id] > 1.0]
    sorted_courses = sorted(alternative_courses, key=lambda course_id: pheromone[course_id], reverse=True)
    return sorted_courses[:3]
'''
from database import get_courses

def filter_courses_by_time_and_building(time, building):
    """
    주어진 시간대와 건물에 해당하는 강의 목록을 필터링합니다.

    Args:
        time: 시간 (예: "월1", "화2")
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
