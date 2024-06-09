from aco_algorithm import ant_colony

# given some nodes, and some locations...
test_nodes = {0: (0, 7), 1: (3, 9), 2: (12, 4), 3: (14, 11), 4: (8, 11),
              5: (15, 6), 6: (6, 15), 7: (15, 9), 8: (12, 10), 9: (10, 7)}

# ...and a function to get distance between nodes...
def distance(start, end):
	x_distance = abs(start[0] - end[0])
	y_distance = abs(start[1] - end[1])
	
	# c = sqrt(a^2 + b^2)
	import math
	return math.sqrt(pow(x_distance, 2) + pow(y_distance, 2))

# 개미 군집을 만듦.
# 어차피 거리를 전단계에서 계산하므로, 거리 대신 가중치 결과를 반환하는 것도 가능하지 않을까?
colony = ant_colony(test_nodes, distance)

# 아래 구문을 통해 최적 경로를 찾을 수 있음
answer = colony.mainloop()