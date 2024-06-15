from aco_algorithm import ant_colony
from database import get_courses

# 건물 위치 점수 딕셔너리
building_scores = {
    '공과대학 5호관': 0.04,
    '공과대학 1호관': 0.02,
    '공과대학 9호관': 0.01
}

# 이수 체계별 점수 딕셔너리
curriculum_scores = {
	'교양':0.02,
	'일반선택':0.04,
	'전공선택':0.01,
}

# ...and a function to get distance between nodes...
def distance(start, end):
	x_distance = abs(start[0] - end[0])
	y_distance = abs(start[1] - end[1])
	
	# c = sqrt(a^2 + b^2)
	import math
	return math.sqrt(pow(x_distance, 2) + pow(y_distance, 2))

def calc_weight(course, args, distance):
	total = 0
	for i in args:
		total += i


if __name__ == "__main__":
	arguments = [building_scores, curriculum_scores]
	courses = get_courses()
	# 전체 데이터 포함 노드, 거리 계산 함수, 추가 인자
	colony = ant_colony(courses, calc_weight, distance)
	answer = colony.mainloop()