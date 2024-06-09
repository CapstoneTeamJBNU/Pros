from threading import Thread

class ant_colony:
    class ant(Thread):
        def __init__(self, init_location, possible_locations, pheromone_map, distance_callback, alpha, beta, first_pass=False):
            """
            맵을 탐색하기 위해 개미를 초기화합니다.
            init_location -> 개미가 시작하는 맵의 위치를 나타냅니다.
            
            possible_locations -> 개미가 이동할 수 있는 가능한 노드의 목록입니다.
                내부적으로 사용될 때는 이미 방문한 노드를 제외한 가능한 위치의 목록을 제공합니다.
            
            pheromone_map -> 각 노드 간의 이동 경로에 대한 페로몬 값 맵입니다.
            
            distance_callback -> 두 노드 사이의 거리를 계산하는 함수입니다.
            
            alpha -> ACO 알고리즘에서 선택을 할 때 페로몬 양의 영향을 조절하는 매개변수입니다.
            
            beta -> ACO에서 다음 노드까지의 거리의 영향을 조절하는 매개변수입니다.
            
            first_pass -> 맵의 첫 번째 탐색인 경우, 아래 메서드에서 일부 단계를 다르게 수행합니다.
            
            route -> 개미가 이동한 노드의 레이블이 업데이트되는 리스트입니다.
            
            pheromone_trail -> 개미의 경로에 놓인 페로몬 양의 리스트로, route의 각 이동에 대응합니다.
            
            distance_traveled -> route의 단계를 따라 이동한 총 거리입니다.
            
            location -> 개미의 현재 위치를 나타냅니다.
            
            tour_complete -> 개미가 탐색을 완료했음을 나타내는 플래그입니다.
                get_route()와 get_distance_traveled()에서 사용됩니다.
            """
   
            Thread.__init__(self)
            
            self.init_location = init_location
            self.possible_locations = possible_locations            
            self.route = []
            self.distance_traveled = 0.0
            self.location = init_location
            self.pheromone_map = pheromone_map
            self.distance_callback = distance_callback
            self.alpha = alpha
            self.beta = beta
            self.first_pass = first_pass
            
            # 랜덤 워크를 수행하기 전에 시작 위치를 route에 추가합니다.
            self._update_route(init_location)
            
            self.tour_complete = False
            
        def run(self):
            """
            self.possible_location 이 빌 때까지 (개미가 모든 노드를 방문할 때까지)
                _pick_path()를 사용하여 다음 경로를 선택합니다.
                _traverse()를 사용하여,
                    _update_route() 새로운 경로를 표시합니다.
                    _update_distance_traveled() 순회후 새로운 거리를 기록합니다.
            개미들의 경로와 거리를 반환합니다. ant_colony에서 사용됩니다.
                페로몬 양을 업데이트합니다.
                가능한 최적 솔루션을 찾기 위해 이 개미의 최신 투어를 사용하여 새로운 가능한 최적 솔루션을 확인합니다.
            """
            while self.possible_locations:
                next = self._pick_path()
                self._traverse(self.location, next)
                
            self.tour_complete = True
        
        def _pick_path(self):
            """
            소스: https://en.wikipedia.org/wiki/Ant_colony_optimization_algorithms#Edge_selection
            ACO의 경로 선택 알고리즘을 구현합니다.
            현재 위치에서 가능한 각 이동의 매력도를 계산합니다.
            그런 다음 다음 경로를 선택합니다.
            """
            # 첫 번째 패스(페로몬이 없는 경우)에서는 다음 경로를 찾기 위해 choice()를 사용할 수 있습니다.
            if self.first_pass:
                import random
                return random.choice(self.possible_locations)
            
            attractiveness = dict()
            sum_total = 0.0
            # 각 가능한 위치에 대해, 그 매력도를 찾습니다. (페로몬 양) * 1/거리 [tau*eta, 알고리즘에서]
            # 다음 단계의 각 경로의 확률을 계산하기 위해 모든 매력도 양을 합산합니다.
            for possible_next_location in self.possible_locations:
                # 모든 계산을 float로 수행하십시오. 그렇지 않으면 정수 나눗셈을 얻을 수 있습니다.
                pheromone_amount = float(self.pheromone_map[self.location][possible_next_location])
                distance = float(self.distance_callback(self.location, possible_next_location))
                
                # 매력도 계산: tau^alpha * eta^beta
                attractiveness[possible_next_location] = pow(pheromone_amount, self.alpha)*pow(1/distance, self.beta)
                sum_total += attractiveness[possible_next_location]
            
            # 페로몬 양/거리에 대한 작은 값이 있을 수 있으므로, 이 값이 0과 같아지는 경우가 있습니다.
            
            # 드물게 발생하는 경우,
            if sum_total == 0.0:
                # 이 경우, 모든 0을 증가시켜서 시스템에서 지원하는 가장 작은 0이 아닌 값이 되도록 합니다.
                # 소스: http://stackoverflow.com/a/10426033/5343977
                def next_up(x):
                    import math
                    import struct
                    # NaNs 및 양의 무한대는 자체에 매핑됩니다.
                    if math.isnan(x) or (math.isinf(x) and x > 0):
                        return x

                    # 0.0 및 -0.0은 모두 가장 작은 +ve float로 매핑됩니다.
                    if x == 0.0:
                        x = 0.0

                    n = struct.unpack('<q', struct.pack('<d', x))[0]
                    
                    if n >= 0:
                        n += 1
                    else:
                        n -= 1
                    return struct.unpack('<d', struct.pack('<q', n))[0]
                    
                for key in attractiveness:
                    attractiveness[key] = next_up(attractiveness[key])
                sum_total = next_up(sum_total)
            
            # 누적 확률 동작, 참고: http://stackoverflow.com/a/3679747/5343977
            # 다음 경로를 무작위로 선택합니다.
            import random
            toss = random.random()
                    
            cummulative = 0
            for possible_next_location in attractiveness:
                weight = (attractiveness[possible_next_location] / sum_total)
                if toss <= weight + cummulative:
                    return possible_next_location
                cummulative += weight
        
        def _traverse(self, start, end):
            """
            _update_route()를 사용하여 새로운 노드를 표시합니다.
            _update_distance_traveled()를 사용하여 새로운 이동 거리를 기록합니다.
            self.location을 새 위치로 업데이트합니다.
            run()에서 호출됩니다.
            """
            self._update_route(end)
            self._update_distance_traveled(start, end)
            self.location = end
        
        def _update_route(self, new):
            """
            self.route에 새 노드를 추가합니다.
            self.possible_location에서 새 노드를 제거합니다.
            _traverse() 및 __init__()에서 호출됩니다.
            """
            self.route.append(new)
            self.possible_locations.remove(new)
            
        def _update_distance_traveled(self, start, end):
            """
            self.distance_callback을 사용하여 self.distance_traveled를 업데이트합니다.
            """
            self.distance_traveled += float(self.distance_callback(start, end))
    
        def get_route(self):
            if self.tour_complete:
                return self.route
            return None
            
        def get_distance_traveled(self):
            if self.tour_complete:
                return self.distance_traveled
            return None
        
    def __init__(self, nodes, distance_callback, start=None, ant_count=50, alpha=.5, beta=1.2,  pheromone_evaporation_coefficient=.40, pheromone_constant=1000.0, iterations=80):
        """
        알고리즘에 따라 최적 경로를 찾기 위해 여러 작업자 개미들이 지도를 탐색하는 개미 군집을 초기화합니다. (ACO [Ant Colony Optimization]에 따라)
        # 소스: https://en.wikipedia.org/wiki/Ant_colony_optimization_algorithms
        
        nodes -> 노드 ID를 distance_callback이 이해할 수 있는 값으로 매핑한 dict()입니다.
            distance_callback 호출 시 distance_matrix에 거리가 계산됩니다.
            
        distance_callback -> 좌표 쌍을 입력으로 받아 그 사이의 거리를 반환하는 함수입니다.
            get_distance() 호출 시 distance_matrix에 계산된 거리가 저장됩니다.
            
        start -> 설정된 경우, 모든 개미가 탐색을 시작하는 노드입니다.
            설정되지 않은 경우, nodes의 첫 번째 키로 가정됩니다.
        
        distance_matrix -> 노드 간 거리 값을 저장하는 행렬입니다.
            _get_distance() 호출 시 필요에 따라 값을 계산하여 저장합니다.
        
        pheromone_map -> 개미들이 탐색을 결정하는 데 사용하는 페로몬 값의 최종 행렬입니다.
            개미들의 탐색 도중 ant_updated_pheromone_map에서 페로몬 값을 추가하기 전에 페로몬이 먼저 감소합니다.
            (_update_pheromone_map 단계에서 pheromone_map에 추가됩니다.)
            
        ant_updated_pheromone_map -> 개미들이 놓는 페로몬 값을 저장하는 행렬입니다.
            각 탐색마다 초기화되며, 페로몬 감소 단계 이후 pheromone_map에 값을 추가합니다.
            
        alpha -> 개미가 선택을 할 때 페로몬 양의 영향을 제어하는 ACO 알고리즘의 매개변수입니다.
        
        beta -> 개미가 선택을 할 때 다음 노드까지의 거리의 영향을 제어하는 ACO 알고리즘의 매개변수입니다.
        
        pheromone_constant -> 지도에 페로몬을 놓을 때 사용되는 매개변수입니다. (ACO 알고리즘의 Q)
            _update_pheromone_map()에서 사용됩니다.
            
        pheromone_evaporation_coefficient -> 페로몬 맵에서 페로몬 값을 제거하는 데 사용되는 매개변수입니다. (ACO 알고리즘의 rho)
            _update_pheromone_map()에서 사용됩니다.
        
        ants -> 작업자 개미들을 저장하는 리스트입니다.
            ACO에 따라 지도를 탐색합니다.
            주요 속성:
                총 이동 거리
                경로
            
        first_pass -> 개미들의 첫 번째 탐색을 나타내는 플래그로, 고유한 동작을 트리거합니다.
        
        iterations -> 개미들이 지도를 탐색하는 횟수입니다.
        
        shortest_distance -> 개미 탐색 중 발견된 가장 짧은 거리입니다.
        
        shortest_path_seen -> 탐색 중 발견된 가장 짧은 경로입니다. (shortest_distance는 이 경로의 거리입니다.)
        """
        #nodes
        if type(nodes) is not dict:
            raise TypeError("nodes must be dict")
        
        if len(nodes) < 1:
            raise ValueError("there must be at least one node in dict nodes")
        
        # 내부 매핑 및 호출자에게 반환할 매핑을 생성합니다.
        self.id_to_key, self.nodes = self._init_nodes(nodes)
        # 거리 계산을 위한 행렬을 생성합니다.
        self.distance_matrix = self._init_matrix(len(nodes))
        # 마스터 페로몬 맵을 생성하여 경로에 따른 페로몬 양을 기록합니다.
        self.pheromone_map = self._init_matrix(len(nodes))
        # 개미들이 페로몬을 추가하기 전에 개미들이 페로몬을 추가할 행렬을 생성합니다.
        self.ant_updated_pheromone_map = self._init_matrix(len(nodes))
        
        # 거리 콜백
        if not callable(distance_callback):
            raise TypeError("distance_callback is not callable, should be method")
            
        self.distance_callback = distance_callback
        
        #start
        if start is None:
            self.start = 0
        else:
            self.start = None
            # 시작 노드 ID를 내부 ID로 초기화합니다.
            for key, value in self.id_to_key.items():
                if value == start:
                    self.start = key
            
            # 노드에서 키를 찾지 못한 경우 예외를 발생시킵니다.
            if self.start is None:
                raise KeyError("Key: " + str(start) + " not found in the nodes dict passed.")
            for key, value in self.id_to_key.items():
                if value == start:
                    self.start = key
            
            # 만약 nodes에 키를 찾지 못했다면 예외를 발생시킵니다.
            if self.start is None:
                raise KeyError("Key: " + str(start) + " not found in the nodes dict passed.")
        
        # 개미 수
        if type(ant_count) is not int:
            raise TypeError("ant_count must be int")
            
        if ant_count < 1:
            raise ValueError("ant_count must be >= 1")
        
        self.ant_count = ant_count
        
        # alpha
        if (type(alpha) is not int) and type(alpha) is not float:
            raise TypeError("alpha must be int or float")
        
        if alpha < 0:
            raise ValueError("alpha must be >= 0")
        
        self.alpha = float(alpha)
        
        # beta
        if (type(beta) is not int) and type(beta) is not float:
            raise TypeError("beta must be int or float")
            
        if beta < 1:
            raise ValueError("beta must be >= 1")
            
        self.beta = float(beta)
        
        # 페로몬 증발 계수
        if (type(pheromone_evaporation_coefficient) is not int) and type(pheromone_evaporation_coefficient) is not float:
            raise TypeError("pheromone_evaporation_coefficient must be int or float")
        
        self.pheromone_evaporation_coefficient = float(pheromone_evaporation_coefficient)
        
        # 페로몬 상수
        if (type(pheromone_constant) is not int) and type(pheromone_constant) is not float:
            raise TypeError("pheromone_constant must be int or float")
        
        self.pheromone_constant = float(pheromone_constant)
        
        # 순회 횟수
        if (type(iterations) is not int):
            raise TypeError("iterations must be int")
        
        if iterations < 0:
            raise ValueError("iterations must be >= 0")
            
        self.iterations = iterations
        
        # 다른 내부 변수 초기화
        self.first_pass = True
        self.ants = self._init_ants(self.start)
        self.shortest_distance = None
        self.shortest_path_seen = None
        
    def _get_distance(self, start, end):
        """
        노드간 거리를 계산하기 위해 distance_callback을 호출합니다.
        distance_matrix에 거리가 계산되지 않은 경우, 계산된 거리를 distance_matrix에 저장하고 반환합니다.
        만약 이미 거리가 호출된 경우, distance_matrix에서 값을 반환합니다.
        """
        if not self.distance_matrix[start][end]:
            distance = self.distance_callback(self.nodes[start], self.nodes[end])
            
            if (type(distance) is not int) and (type(distance) is not float):
                raise TypeError("distance_callback should return either int or float, saw: "+ str(type(distance)))
            
            self.distance_matrix[start][end] = float(distance)
            return distance
        return self.distance_matrix[start][end]
        
    def _init_nodes(self, nodes):
        """
        nodes에 전달된 키들과 대응하는 내부 ID 번호 (0 .. n)의 매핑을 생성합니다.
        id들을 nodes의 값들과 대응하는 매핑을 생성합니다.
        mainloop()에서 호출자가 기대하는 노드 이름으로 경로를 반환하기 위해 id_to_key를 사용합니다.
        """
        id_to_key = dict()
        id_to_values = dict()
        
        id = 0
        for key in sorted(nodes.keys()):
            id_to_key[id] = key
            id_to_values[id] = nodes[key]
            id += 1
            
        return id_to_key, id_to_values
        
    def _init_matrix(self, size, value=0.0):
        """
        size에 따라 NxN 행렬을 설정합니다. (여기서 n은 size입니다)
        self.distance_matrix와 self.pheromone_map을 제외하고 동일한 행렬을 필요로 합니다.
        초기화할 값을 제외하고 동일한 행렬을 필요로 합니다.
        """
        ret = []
        for row in range(size):
            ret.append([float(value) for x in range(size)])
        return ret
    
    def _init_ants(self, start):
        """
        첫 번째 패스에서:
            여러 개의 개미 객체를 생성합니다.
        이후 패스에서는 각각에 대해 __init__을 호출하여 재설정합니다.
        기본적으로 모든 개미는 첫 번째 노드인 0에서 시작합니다.
        문제 설명에 따라: https://www.codeeval.com/open_challenges/90/
        """
        # 첫 번째 패스에서 새로운 개미 할당
        if self.first_pass:
            return [self.ant(start, self.nodes.keys(), self.pheromone_map, self._get_distance,
                self.alpha, self.beta, first_pass=True) for x in range(self.ant_count)]
        # 다른 패스에서는 그냥 재설정
        for ant in self.ants:
            ant.__init__(start, self.nodes.keys(), self.pheromone_map, self._get_distance, self.alpha, self.beta)
    
    def _update_pheromone_map(self):
        """
        1)    ACO 알고리즘을 통해 self.pheromone_map의 값을 감소시켜 업데이트합니다.
        2)    모든 개미들의 ant_updated_pheromone_map에서 페로몬 값을 추가합니다.
        호출자:
            mainloop()
            (모든 개미가 탐색을 완료한 후)
        """
        # 언제나 정사각형 행렬
        for start in range(len(self.pheromone_map)):
            for end in range(len(self.pheromone_map)):
                # 이 위치의 페로몬 값을 감소시킵니다.
                # tau_xy <- (1-rho)*tau_xy    (ACO)
                self.pheromone_map[start][end] = (1-self.pheromone_evaporation_coefficient)*self.pheromone_map[start][end]
                
                # 그런 다음 각 개미가 이를 통과한 경우 해당 위치에 대한 모든 기여를 추가합니다
                #(ACO)
                #tau_xy <- tau_xy + delta tau_xy_k
                #    delta tau_xy_k = Q / L_k
                self.pheromone_map[start][end] += self.ant_updated_pheromone_map[start][end]
    
    def _populate_ant_updated_pheromone_map(self, ant):
        """
        주어진 개미에 대해 ACO에 따라 개미의 경로에 따라 ant_updated_pheromone_map에 페로몬 값을 채웁니다.
        호출자:
            mainloop()
            (_update_pheromone_map() 이전에)
        """
        route = ant.get_route()
        for i in range(len(route)-1):
            # 개미가 이동한 경로에 대한 페로몬을 찾습니다.
            current_pheromone_value = float(self.ant_updated_pheromone_map[route[i]][route[i+1]])
        
            # 경로의 해당 부분에 대한 페로몬을 업데이트합니다.
            #(ACO)
            #    delta tau_xy_k = Q / L_k
            new_pheromone_value = self.pheromone_constant/ant.get_distance_traveled()
            
            self.ant_updated_pheromone_map[route[i]][route[i+1]] = current_pheromone_value + new_pheromone_value
            self.ant_updated_pheromone_map[route[i+1]][route[i]] = current_pheromone_value + new_pheromone_value
        
    def mainloop(self):
        """
        작업자 개미들을 실행하고, 반환값을 수집하며 개미들로부터 페로몬 값을 업데이트하는 함수입니다.
            다음 함수들을 호출합니다:
            _update_pheromones()
            ant.run()
        시뮬레이션을 self.iterations 번 실행합니다.
        """
        
        for _ in range(self.iterations):
            # 개미들을 멀티스레드로 시작하고, 새로운 스레드에서 ant.run()을 호출합니다.
            for ant in self.ants:
                ant.start()
            
            #소스: http://stackoverflow.com/a/11968818/5343977
            # 개미들이 작업을 완료할 때까지 기다린 후, 공유 리소스를 수정하기 위해 진행합니다.
            for ant in self.ants:
                ant.join()
            
            for ant in self.ants:    
                # 이 개미의 경로에 따른 페로몬 기여를 ant_updated_pheromone_map에 업데이트합니다.
                self._populate_ant_updated_pheromone_map(ant)
                
                # 아직 경로를 보지 못했다면, 나중에 비교를 위해 채워넣습니다.
                if not self.shortest_distance:
                    self.shortest_distance = ant.get_distance_traveled()
                
                if not self.shortest_path_seen:
                    self.shortest_path_seen = ant.get_route()
                    
                # 더 짧은 경로를 발견하면 반환을 위해 저장합니다
                if ant.get_distance_traveled() < self.shortest_distance:
                    self.shortest_distance = ant.get_distance_traveled()
                    self.shortest_path_seen = ant.get_route()
            
            # 현재 페로몬 값들을 감소시키고 개미들이 탐색 중 발견한 모든 페로몬 값을 추가합니다 (ant_updated_pheromone_map에서 가져옴)
            self._update_pheromone_map()
            
            # 개미들의 첫 번째 패스 탐색을 완료했음을 나타내는 플래그
            if self.first_pass:
                self.first_pass = False
            
            # 다음 반복을 위해 모든 개미를 기본값으로 재설정합니다
            self._init_ants(self.start)
            
            # 다음 패스에서 개미들의 페로몬을 기록하기 위해 ant_updated_pheromone_map을 재설정합니다
            self.ant_updated_pheromone_map = self._init_matrix(len(self.nodes), value=0)
        
        # 최단 경로를 호출자의 노드 ID로 다시 변환합니다.
        ret = []
        for id in self.shortest_path_seen:
            ret.append(self.id_to_key[id])
        
        return ret