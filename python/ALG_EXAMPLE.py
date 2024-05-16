import numpy as np

from ACO_ALG import AntColony

#강의는 6개
#페로몬의 증발 속도는 빠르게?
#거리를 적용하는건 담은인원이 많은곳으로 가는것을 선호한다는 의미
#최적 대상을 과목코드로 두고, 최적의 수강순서를 찾는것이 목적
distances = np.array([[np.inf, 2, 2, 5, 7],# 1기준 2:2, 3:2, 4:5, 5:7
                      [2, np.inf, 4, 8, 2],# 2기준 1:2, 3:4, 4:8, 5:2
                      [2, 4, np.inf, 1, 3],# 3기준 1:2, 2:4, 4:1, 5:3
                      [5, 8, 1, np.inf, 2],# 4기준 1:5, 2:8, 3:1, 5:2
                      [7, 2, 3, 2, np.inf]# 5기준 1:7, 2:2, 3:3, 4:2
                      ])

ant_colony = AntColony(distances, 1, 1, 100, 0.95, alpha=1, beta=1)
shortest_path = ant_colony.run()
print ("shorted_path: {}".format(shortest_path))

