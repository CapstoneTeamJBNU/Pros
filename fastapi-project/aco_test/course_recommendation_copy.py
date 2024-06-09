from database import get_courses

"""
    가정 :
        1. 가중치 초기값은 자동으로 n분의 1로 분배
        2. 사용자가 시간표 생성시 가중치 조율 가능
        3. 사용자가 지정 강의 삽입 가능
        4. 사용자가 강의 범위 지정 가능
        5. 사용자 데이터는 초기에 입력됨

    흐름 :
        1. 사용자가 가입할 때 정보를 입력함
        2. 시스템은 초기 시간표 생성을 수행함
        3. 사용자가 내 시간표 보기를 선택하면 시간표 결과를 보여줌
        4. 생성된 강의 목록중 일부를 누르면 해당 강의의 상세 정보와 가중치 합산을 보여줌
        # 단, 결과값은 가중치 적용 이전의 점수계를 반환
        5. 이후 사용자가 해당 강의 시간표와 가중치를 조절하고, 추가적으로 추천을 요청할 수 있음
"""


def recommend_courses(department, time, course_type):
    courses = get_courses()
    # 건물 위치 점수 딕셔너리
    building_scores = {
        '공과대학 5호관': 0.04,
        '공과대학 1호관': 0.02,
        '공과대학 9호관': 0.01
    }

    # 필터링 조건 리스트
    conditions = []

    # 필터링 함수
    def filtering(args, conditions):
        pass

    # 건물 위치 기반 점수 부여
    def score_by_building(course):
        return building_scores.get(course['building'], 0)  # building_scores에 없는 건물은 0점 처리

    # 평점 기반 점수 부여
    def score_by_rating(course):
        return float(course['rating'])
    
    # 가중치 비율 설정 및 가중치 계산
    weight_args = []
    ratios = []

    # 가중치에 들어가는 요소 순번은 항상 지켜져야 하며, 타입도 float이나 int로 통일해야 함
    def set_weight_ratio(ratio):
        ratios.append(ratio)

    def calc_weight(args, ratios):
        weight = 0
        for arg, ratio in args, ratios:
            weight += arg * ratio
        return weight
    

    # 강의 순회 - 각 개미들 관점에서 순회한 강의는 지역적으로 제외해야 함
    # 그러나, copy형태로 수행하기에는 기하급수적으로 데이터가 늘어나는 기술적 문제
    # 차라리 한 배열에서 각 개미가 순회했던 과목들에 대한 history를 이용하는건?
    # history는 과목을 넣기보단 해당 과목의 인덱스 번호를 저장하는 방식이 좋을 것 같음
    def travel_courses(courses):
        pass
    
    # 페로몬 갱신에 대한 이해 필요
    # 동일하게 강의 크기와 동일한 배열 생성해 페로몬을 저장하고, 각 개미가 지나간 경로에 대해 페로몬을 갱신
    def pheromone_update():
        pass

    # 강의 조합 생성 사이클
    # 한 사이클의 분기 조건 - 강의 최대갯수를 채우면 중지
    # 전체 사이클의 분기 조건 - 충분한 수행으로 어떤 수에 수렴하게 될 때 중지
    def test_cycle():
        pass

    # 강의 총점, 강의 평점, 강의 코멘트 긍정률 비교
    def compare_rates():
        pass

    # 이후 추가할 내용들...
    def some():
        pass

    pass