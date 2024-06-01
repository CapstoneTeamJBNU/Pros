import random
from database import get_courses

# 개미 수, 페로몬 증발률, 최대 반복 횟수 등 파라미터 설정
num_ants = 10
evaporation_rate = 0.5
max_iterations = 100

def recommend_alternative_courses(department, grade, time, course_type):
    # Firestore에서 전처리된 강의 정보 가져오기
    courses = get_courses()

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

    # 개미 이동 함수 (시간대가 겹치는 강의만 선택, 건물 선호도는 제외)
    def move_ant(ant, time):
        available_courses = [
            course_id
            for course_id in filtered_courses
            if time in filtered_courses[course_id]['time']
        ]

        # 페로몬 농도를 고려하여 다음 강의 선택
        probabilities = [pheromone[course_id] for course_id in available_courses]
        total_probability = sum(probabilities)
        if total_probability == 0:  # 선택 가능한 강의가 없을 경우 빈 리스트 반환
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
