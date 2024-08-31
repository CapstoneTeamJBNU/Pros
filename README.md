# RecommendTimeTable(RTT,Syllas)
## 대학교 개설강좌 데이터를 활용한 맞춤 시간표 추천시스템
![시연 영상](https://github.com/user-attachments/assets/b557bdfd-4a9c-4e1f-a393-ffe4a7a4275b)

<details>
  <summary>사용 개발전략</summary>
  <ul>
    <li>스크럼 기반 애자일 방법론 사용<br>프로젝트 기간: 10주<br>스프린트 주기: 2주</li>
    <li>스프린트 별 주요 산출물<br>스프린트 1: 유스케이스 명세, 다이어그램, Business Model 등 각종 문서작업<br>스프린트 2: 피그마를 통한 UI 개발 및 Flutter 코드 구현<br>스프린트 3: 강의 데이터수집, 파이어베이스 연동 및 사용자인증 구현<br>스프린트 4: 점수기반 강의 추천 알고리즘 구현<br>스프린트 5: 기본 시간표 기능 구현</li>
  </ul>
</details>

#### WBS
<details>
  <summary>WBS 펼치기</summary>
  <p><img src="https://github.com/user-attachments/assets/2f81ef35-11cf-43a4-859a-163a2c306c10" alt="image" width="600"></p>
</details>

#### LRC
<details>
  <summary>LRC 펼치기</summary>
  <p><img src="https://github.com/user-attachments/assets/65b513fd-b31e-4135-85cc-1846c326b59d" alt="image" width="600"></p>
</details>

#### Business Process Model(BPM)
<details>
  <summary>BPM 펼치기</summary>
  <p><img src="https://github.com/user-attachments/assets/f090690b-0107-4b77-ae94-690d96526939" alt="image" width="600"></p>
</details>

#### Business Object Model(BOM)
<details>
  <summary>BOM 펼치기</summary>
  <p><img src="https://github.com/user-attachments/assets/035529fc-6c72-4675-ae79-e0624d1f7885" alt="image" width="600"></p>
</details>

#### Usecase Diagram
<details>
  <summary>Usecase Diagram 펼치기</summary>
  <p><img src="https://github.com/user-attachments/assets/abd13098-54f1-4983-99e0-c9f818bd85d4" alt="image" width="600"></p>
</details>

#### System Architecture
![image](https://github.com/user-attachments/assets/43acd7db-d3f8-4746-81ff-76f41febcb22)
<details>
  <summary>시스템 아키텍쳐 설명</summary>
  <ul>
    <li>전북대학교 개설강좌 페이지에서 액셀파일을 크롤링하여 강의 데이터를 Firestore에 수집하고 FastAPI를 통해 점수기반 추천 알고리즘을 사용하여 Flutter UI로 반환한다.</li>
  </ul>
</details>

#### Flutter 디렉토리 설정
![image](https://github.com/user-attachments/assets/438833a8-59c6-450a-9150-87aa6c686ade)
<details>
  <summary>각 디렉토리별 역할</summary>
  <ul>
    <li>Models: 모델 위한 설계(Data I/O)</li>
    <li>Screens: UI 화면 관리</li>
    <li>Controller: API호출 처리, 로직처리</li>
    <li>Constant: 상수 값, style 등 관리</li>
  </ul>
</details>

#### FastAPI 디렉토리 설정
![image](https://github.com/user-attachments/assets/6a515d7d-f5c2-41f9-83b6-be2ee20e535d)
<details>
  <summary>각 디렉토리별 역할</summary>
  <ul>
    <li>config_secret: key, DB정보 등 보안성을 위한 파일</li>
    <li>apis : API 버전별로 관리</li>
    <li>db : firestore/mock 데이터 관리</li>
    <li>Schemas: 스키마 관리(Swagger 문서 자동화)</li>
    <li>config : 설정 적용을 위한 디렉토리</li>
    <li>Static: static 파일관리</li>
    <li>Templates: http 파일 관리</li>
    <li>Migration: db migration 버전관리</li>
  </ul>
</details>

#### 점수 기반 강의 추천 알고리즘
<details>
  <summary>점수 기반 강의 추천 알고리즘 작동에 대한 설명</summary>
  <ul>
    <li>1. 데이터 수집 및 전처리: Firebase Firestore 데이터베이스에 저장된 강의 정보를 가져와서 시간, 건물, 학과, 학년, 이수 구분 등의 정보를 추출하고 정제합니다.</li>
    <li>2. 강의 필터링: 사용자의 입력(학과, 시간대, 이수 구분)에 따라 추천 대상 강의를 필터링합니다.</li>
    <li>3. 점수 부여: 각 강의에 대해 항목별로 점수를 부여합니다.    
     <br>- 3.1 건물 위치 점수: 사용자가 입력한 현재 건물과의 거리를 기반으로 점수를 부여합니다. 
     <br>- 3.2 강의 평점 점수: 에브리타임에 저장된 강의 평점을 그대로 점수로 사용합니다.
     <br>- 3.3 사용자 관심주제 점수: 회원가입 시 입력받은 관심주제들을 순위를 매겨 점수를 부여합니다.
     <br>- 3.4 이미 수강한 강의 점수: 사용자가 이미 수강한 강의들은 제외합니다.
     <br>- 3.5 선수 과목 점수: 타과 전공선택에서 필수 선수 과목을 들어야 청강할 수 있는 강의들은 제외합니다.</li>
    <li>4. 점수 합산 및 정렬: 각 강의의 건물 위치 점수와 평점 점수를 합산하고, 합산 점수 기준으로 내림차순 정렬합니다.</li>
    <li>5. 추천 결과 반환: 점수가 가장 높은 강의를 반환하여 사용자가 선택한 시간 셀에 삽입합니다.</li>    
  </ul>
</details>

### 논문 경진대회 수상
<details>
  <summary>상장</summary>
  <p><img src="https://github.com/user-attachments/assets/ec3ceda0-475d-47e2-9fa9-380907573e4d" alt="논문 금상" width="600"></p>
</details>

### 전북대학교 LMS에 아이디어 차용
<details>
  <summary>전북대 LMS 좌측 "수강신청 도우미" 서비스탭</summary>
  <p><img src="https://github.com/user-attachments/assets/cee84367-764a-4cdf-83ab-df5fc30b6142" alt="LMS" width="750"></p>
</details>
