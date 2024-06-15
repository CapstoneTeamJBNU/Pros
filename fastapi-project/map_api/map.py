import requests
import pandas as pd
import numpy as np
import folium
from folium.plugins import MiniMap
import math

##카카오 API
## region에는 '성산일출봉 전기충전소' 검색명이 들어갈 것임
## page_num은 1~3이 입력될 건데, 한 페이지 당 검색목록이 최대 15개임.
## 만약 page_num이 4이상이 되면 3페이지랑 같은 15개의 결과 값을 가져옴. 그래서 1~3만 쓰는 것임
## 입력 예시 -->> headers = {"Authorization": "KakaoAK f221u3894o198123r9"}
## ['meta']['total_count']은 내가 '성산일출봉 전기충전소'를 검색했을 때, 나오는 총 결과 값. 
## ['meta']['total_count']이 45보다 크면 45개만 가져오게 됨


def elec_location(region,page_num):
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json'
    params = {'query': region,'page': page_num}
    headers = {"Authorization": "KakaoAK 89ccf41a53f3aafaea243be84dba62b8"}

    places = requests.get(url, params=params, headers=headers).json()['documents']
    total = requests.get(url, params=params, headers=headers).json()['meta']['total_count']
    if total > 45:
        print(total,'개 중 45개 데이터밖에 가져오지 못했습니다!')
    else :
        print('모든 데이터를 가져왔습니다!')
    return places

## 이 함수는 위 함수 결과 값(1 ~ 45개) 하나하나 분리해서 저장할 것임
## 1번 결과 값 안에는 1번 충전소 이름, 위도, 경도, 전화번호, 도로명 주소 등이 있는데 각각 배열에 저장
## 우리는 충전소 ID, 충전소 이름, 위도, 경도, 도로명주소, 사이트주소를 저장할 것임

def elec_info(places):
    X = []
    Y = []
    stores = []
    road_address = []
    place_url = []
    ID = []
    for place in places:
        X.append(float(place['x']))
        Y.append(float(place['y']))
        stores.append(place['place_name'])
        road_address.append(place['road_address_name'])
        place_url.append(place['place_url'])
        ID.append(place['id'])

    ar = np.array([ID,stores, X, Y, road_address,place_url]).T
    df = pd.DataFrame(ar, columns = ['ID','stores', 'X', 'Y','road_address','place_url'])
    return df

## 여러개으 키워드를 검색할 때 사용할 함수임
## location_name에는 ['성산일출봉 전기충전소, '한림공원 전기충전소', ... ,'모슬포 전기충전소']처럼 배열이 입력

def keywords(location_name):
    df = None
    for loca in location:
        for page in range(1,4):
            local_name = elec_location(loca, page)
            local_elec_info = elec_info(local_name)

            if df is None:
                df = local_elec_info
            elif local_elec_info is None:
                continue
            else:
                df = pd.concat([df, local_elec_info],join='outer', ignore_index = True)
    return df

##지도로 보여주기

def make_map(dfs):
    # 지도 생성하기
    m = folium.Map(location=[33.4935,126.6266],   # 기준좌표: 제주어딘가로 내가 대충 설정
                   zoom_start=12)

    # 미니맵 추가하기
    minimap = MiniMap() 
    m.add_child(minimap)

    # 마커 추가하기
    for i in range(len(dfs)):
        folium.Marker([df['Y'][i],df['X'][i]],
                  tooltip=dfs['stores'][i],
                  popup=dfs['place_url'][i],
                  ).add_to(m)
    return m

## 여기 두 개 키워드처럼 가까운 거리에 있는 키워드를 입력하면 
## 중복해서 전기충전소를 검색할 가능성이 아주 놓기 때문에
## drop_duplicates를 해주고 인덱스 리셋을 해준다

# location = ['성산일출봉 전기충전소', '광치기해수욕장 전기충전소']
# df = keywords(location)
# df = df.drop_duplicates(['ID'])
# df = df.reset_index()

# make_map(df)

def get_location(univ, inputs):
    import requests
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json'
    inputs = inputs.split(':')
    direction = ''
    if inputs[1].find('호관') != -1:
        direction += inputs[1].split('호관')[0] + '호관'
    else :
        direction = inputs[1].split(' ')[0]
    params = {'query': univ+inputs[0]+direction,'page': 1}
    headers = {"Authorization": "KakaoAK 89ccf41a53f3aafaea243be84dba62b8"}
    places = requests.get(url, params=params, headers=headers).json()['documents']
    total = requests.get(url, params=params, headers=headers).json()['meta']['total_count']
    x, y = places[0]["x"], places[0]["y"]  # x, y= 위도, 경도
    response = requests.get(
        "https://dapi.kakao.com/v2/local/geo/transcoord.json",
        params={"x": x, "y": y, "output_coord": "WTM"},
        headers={"Authorization": "KakaoAK 89ccf41a53f3aafaea243be84dba62b8"},
    ).json()["documents"][0]
    # x1, y1 = 위경도를 WTM으로 변환
    places[0]["x"],places[0]["y"] = response["x"], response["y"]
    # if total > 45:
    #     print(total,'개 중 45개 데이터밖에 가져오지 못했습니다!')
    #     for place in places:
    #         print(place['place_name'])
    # else :
    #     print('모든 데이터를 가져왔습니다!')
    #     for place in places:
    #         print(place['place_name'])
    return places

def __get_distance_result__(location1, location2):
    return math.sqrt((float(location1[0]['x'])-float(location2[0]['x'])) ** 2 + (float(location1[0]['y']) - float(location2[0]['y'])) ** 2)



univName = '전북대학교'
distance = __get_distance_result__(get_location(univName,'전주:공과대학 5호관 304'),get_location(univName,'전주:공과대학 1호관 304'))

print(distance)
print(f'예상 도보거리 : {math.ceil(distance/100)}분')