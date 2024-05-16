import random as rn
import numpy as np
from numpy.random import choice as np_choice

class AntColony(object):

    def __init__(self, distances, n_ants, n_best, n_iterations, decay, alpha=1, beta=1):
        """
        인자:
            distances (2D numpy.array): 거리의 2D 배열. 대각선은 np.inf로 가정됩니다.
            n_ants (int): 반복마다 실행되는 개미의 수
            n_best (int): 페로몬을 남기는 최상위 개미의 수
            n_iterations (int): 반복 횟수
            decay (float): 페로몬의 감소율. 페로몬 값에 decay를 곱합니다. 예를 들어, 0.95는 감소율이고, 0.5는 훨씬 빠른 감소율을 의미합니다.
            alpha (int 또는 float): 페로몬의 지수, 높은 alpha는 페로몬에 더 큰 가중치를 부여합니다. 기본값은 1입니다.
            beta (int 또는 float): 거리의 지수, 높은 beta는 거리에 더 큰 가중치를 부여합니다. 기본값은 1입니다.

        예시:
            ant_colony = AntColony(german_distances, 100, 20, 2000, 0.95, alpha=1, beta=2)
        """
        self.distances  = distances
        self.pheromone = np.ones(self.distances.shape) / len(distances)
        self.all_inds = range(len(distances))
        self.n_ants = n_ants
        self.n_best = n_best
        self.n_iterations = n_iterations
        self.decay = decay
        self.alpha = alpha
        self.beta = beta

        """
        최적경로 탐색, 회차 반복만큼 경로 사이즈 수축
        """
    def run(self):
        shortest_path = None
        all_time_shortest_path = ("placeholder", np.inf)
        for i in range(self.n_iterations):
            all_paths = self.gen_all_paths()
            self.spread_pheronome(all_paths, self.n_best, shortest_path=shortest_path)
            shortest_path = min(all_paths, key=lambda x: x[1])
            print (shortest_path)
            if shortest_path[1] < all_time_shortest_path[1]:
                all_time_shortest_path = shortest_path            
            self.pheromone = self.pheromone * self.decay            
        return all_time_shortest_path

    """
    최상위 개미의 경로에 대해 페로몬을 확산
    """
    def spread_pheronome(self, all_paths, n_best, shortest_path):
        sorted_paths = sorted(all_paths, key=lambda x: x[1])
        for path, dist in sorted_paths[:n_best]:
            for move in path:
                self.pheromone[move] += 1.0 / self.distances[move]

    """
    경로 거리 생산
    """
    def gen_path_dist(self, path):
        total_dist = 0
        for ele in path:
            total_dist += self.distances[ele]
        return total_dist

    """
    모든 경로 생성
    """
    def gen_all_paths(self):
        all_paths = []
        for i in range(self.n_ants):
            path = self.gen_path(0)
            all_paths.append((path, self.gen_path_dist(path)))
        return all_paths

    """
    경로 생성
    """
    def gen_path(self, start):
        path = []
        visited = set()
        visited.add(start)
        prev = start
        for i in range(len(self.distances) - 1):
            move = self.pick_move(self.pheromone[prev], self.distances[prev], visited)
            path.append((prev, move))
            prev = move
            visited.add(move)
        path.append((prev, start)) # going back to where we started    
        return path

    """
    경로 선택
    """
    def pick_move(self, pheromone, dist, visited):
        pheromone = np.copy(pheromone)
        pheromone[list(visited)] = 0

        row = pheromone ** self.alpha * (( 1.0 / dist) ** self.beta)

        norm_row = row / row.sum()
        move = np_choice(self.all_inds, 1, p=norm_row)[0]
        return move


