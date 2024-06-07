#import firebase_admin
#from firebase_admin import credentials, firestore
from test_data import mock_courses

# Firebase 초기화 (서비스 계정 키 파일 경로 설정)
#cred = credentials.Certificate('/Users/yosmac/Desktop/fastapi-project/capstonejbnuteam8-firebase-adminsdk-oyel5-b0dfcb4f59.json')  
#firebase_admin.initialize_app(cred)

# Firestore 클라이언트 생성
#db = firestore.client()

def get_courses():
    """
    Mock 데이터를 반환하는 함수

    Returns:
        list: 강좌 정보 딕셔너리의 리스트
    """
    return mock_courses
