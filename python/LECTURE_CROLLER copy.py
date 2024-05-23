from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
import openpyxl
import logging
import custom_firestore
import time
import os
import glob

EXL_PATH = './python/EXCEL/'
TABLE_ATTR = 'textContent'
BOX_ATTR = 'value'
DOWNLOAD_GAGE_ATTR = 'outerText'
SEASON = ['계절학기(동기)','2학기','계절학기(하기)','1학기']

class croller:
    """
    과목 코드 크롤링 로직 예상안
    1. 접속
    2. 조회
    3. 강의 계획서 버튼 나올떄까지 횡스크롤
        3-1. 초기 24개 클릭 사이클 이후 한칸씩 종스크롤
             0~24 요소 번갈아 가면서 동적 갱신됨
             2개씩 가려짐
    4. 클릭
        4-1. 없을 시 다음 요소로 재귀
    5. 강의계획서 나오면 과목코드 추출 및 엑셀 삽입(파이어베이스 과목 코드 필드에 삽입)
        5-1. 과목코드 공란시 공란 그대로 입력
    6. 강의계획서 닫기
    7. 3으로 재귀
        7-1. 최종 과목명 도달시 종료
    """
    def __init__(self):
        # 다운로드 경로 설정
        chrome_options = Options()
        # 사람처럼 보이게 하는 옵션들
        chrome_options.add_argument("disable-gpu")  # 가속 사용 x
        chrome_options.add_argument("lang=ko_KR")  # 가짜 플러그인 탑재
        chrome_options.add_argument(
            'user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36')  # user-agent 이름 설정

        chrome_options.add_argument("--disable-popup-blocking")
        chrome_options.add_argument("--disable-extensions")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_experimental_option("prefs", {
            "download.default_directory": os.path.abspath(EXL_PATH),
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True
        })

        # self.db = custom_firestore.Firestore()
        self.driver = webdriver.Chrome(chrome_options)
        #최대 20초 동안 대기
        self.wait = WebDriverWait(self.driver, 20)
        #사이트 접속
        self.driver.get('http://all.jbnu.ac.kr/jbnu/sugang/sbjt/sbjt.html')
        #화면 사이즈 조정
        # self.driver.fullscreen_window()
        #키입력 할당 포커싱
        self.action = ActionChains(self.driver)

    def search(self):
        seach = self.wait.until(EC.presence_of_element_located((
            By.CSS_SELECTOR,
            '#mainframe_childframe_form_divSearch_btnSearchTextBoxElement > div')))
        self.action.move_to_element(seach).click().perform()
        self.wait.until(EC.invisibility_of_element_located(
            (By.CSS_SELECTOR,'#mainframe_waitwindowImageElement > img')))
        time.sleep(2)
        
    def decrease_year(self):
        self.wait.until(EC.presence_of_element_located((
            By.CSS_SELECTOR,'#mainframe_childframe_form_divSearch_spnYy_spindownbuttonAlignImageElement'))).click()
    
    def decrease_month(self, init = False):
        season = self.wait.until(EC.presence_of_element_located((
            By.CSS_SELECTOR,'#mainframe_childframe_form_divSearch_cboShtm')))
        season_val = self.wait.until(
            EC.presence_of_element_located((
                By.CSS_SELECTOR, '#mainframe_childframe_form_divSearch_cboShtm_comboedit_input')))
        
        #계절 동기 - 2학기 = -1, 2학기 - 계절 하기 = -1, 계절 하기 - 1학기 = -1, 1학기 - 계절 동기 = 3
        if init:
            self.action.move_to_element(season).click()
            while season_val.get_property(BOX_ATTR) != SEASON[0]:
                self.action.move_to_element(season).send_keys(Keys.ARROW_DOWN).perform()
            self.action.move_to_element(season).send_keys(Keys.ENTER).perform()
        else:
            #학기 변경
            if season_val.get_property(BOX_ATTR) == SEASON[3]:
                self.decrease_year()
                for i in range(3):
                    self.action.move_to_element(season).click().send_keys(Keys.ARROW_DOWN).perform()
                    self.action.move_to_element(season).send_keys(Keys.ENTER).perform()
                    time.sleep(0.4)
            else:
                self.action.move_to_element(season).click().send_keys(Keys.ARROW_UP).perform()
                self.action.move_to_element(season).send_keys(Keys.ENTER).perform()
                time.sleep(0.3)

        self.search()

    def get_exl(self):
        '''
        # 엑셀 다운로드
        과정 :
            1. 엑셀 다운로드 버튼 클릭
            2. 다운로드 진행 상태 확인
            3. 다운로드 완료 후 파일명과 생성시간 반환
    
        오류 처리 :
                1.

        기술 문제 :
                1.

        @return file_name_and_time_lst : 파일명과 생성시간을 반환
        '''
        self.driver.find_element(
            By.CSS_SELECTOR,
            '#mainframe_childframe_form_btnExcelDownTextBoxElement > div').click()
        time.sleep(0.2)
        gage = self.driver.find_element(By.CSS_SELECTOR, '#mainframe_childframe_form__exportBar')
        
        while gage.get_property(DOWNLOAD_GAGE_ATTR) != '':
            time.sleep(0.1)
        file_name_and_time_lst = []
        
        time.sleep(3)

        while glob.glob(f"{EXL_PATH}/*.crdownload"):
            time.sleep(1)  # 1초마다 확인
        
        # 해당 경로에 있는 파일들의 생성시간을 함께 리스트로 넣어줌.
        for f_name in glob.glob(f"{EXL_PATH}/*.xlsx"):
            written_time = os.path.getctime(f"{f_name}")
            file_name_and_time_lst.append((f_name, written_time))
        # 생성시간 역순으로 정렬하고, 
        sorted_file_lst = sorted(file_name_and_time_lst, key=lambda x: x[1], reverse=True)
        return sorted_file_lst[0]

    def get_syllabus(self, file_name, year, season):
        '''
        # 엑셀 내 과목코드 삽입
        과정 :
            1. 엑셀 읽어오기
            2. 엑셀 내 과목코드 삽입
            3. 엑셀 저장
    
        오류 처리 :
                1.

        기술 문제 :
                1. 강의 계획서 접근까지의 과정
                2. 강의 계획서 버튼 인덱스의 동적구성으로 인한 루프문 구현 난해
                3. 강의 계획서가 제출되지 않은 과목 처리
                4. openpyxl 에서 zip파일 에러 발생
    
        @param file_name : 엑셀 파일명 @param year : 년도 @param season : 계절
        @return None
    '''
        def sylla_h_size_control():
            idx = 0
            tag_elem_CSS = '#mainframe_childframe_form_grdLessSubjtExcel_head_gridrow_-1_cell_-1_'
            try:
                while idx < 25:
                    self.driver.execute_script(
                        'arguments[0].scrollWidth = 23',self.driver.find_element(By.CSS_SELECTOR, f'{tag_elem_CSS}{idx}'))
                    time.sleep(0.1)
                    idx+=1
            except Exception as e:
                logging.error(e)

        def syllaScanV():
            lecture_amount = int(self.driver.find_element(
                By.CSS_SELECTOR,
                '#mainframe_childframe_form_divResultCnt_staTotCntTextBoxElement > div > span > b'
                ).get_attribute(TABLE_ATTR))
            for i in range(len(lecture_amount)):
                syllabus_btn = self.driver.find_elements(
                    By.CSS_SELECTOR,
                    ''
                    )
                pass

        #엑셀 읽어오기
        ss = openpyxl.load_workbook(file_name)

        #printing the sheet names
        ss_sheet = ss['Sheet1']
        ss_sheet.title = f'OPEN_LECTURE_{year}_{3-season}'
        ss.save(file_name)

        # sylla_h_size_control()
        time.sleep(20)
        # syllaScanV()

        

    '''
    # 메인 크롤링
    과정 :
        1. 년도 및 학기 설정
        2. 엑셀 다운로드
        3. 엑셀 내 과목코드 삽입
        4. 엑셀 파이어베이스 전송
    
    오류 처리 :
            1.

    기술 문제 :
            1. 
    '''
    def crolling(self):
        try:
            targ_year = 9999
            
            self.decrease_month(True)
            while targ_year > 2004:# next_year:
                targ_year = int(self.wait.until(EC.presence_of_element_located(
                (By.CSS_SELECTOR,'#mainframe_childframe_form_divSearch_spnYy_spinedit_input'))
                ).get_property(BOX_ATTR))
                for targ_month in range(len(SEASON)):
                    if not self.driver.find_elements(
                        By.CSS_SELECTOR, '#mainframe_childframe_form_grdLessSubjtExcel_body_gridrow_0_cell_0_0'
                        ):
                        pass
                    else:
                        # 가장 최근 파일을 넣어준다.
                        recent_file = self.get_exl()
                        
                        #recent_file_name = recent_file[0]
                        #print(f'{targ_year}년 {SEASON[targ_month]} 학기 엑셀 = {recent_file_name}')

                        ''' 엑셀 내 과목코드 삽입 과정 '''
                        self.get_syllabus(recent_file[0], targ_year, targ_month)

                        ''' 엑셀 파이어베이스 전송 과정 '''
                        ''
                    self.decrease_month()

        except Exception as e:
            print(e)
        
        self.driver.quit()

    def firstInit(self):
        #iframe으로 전환(아직 미구현)
        #iframe = wait.until(EC.presence_of_element_located((By.TAG_NAME, Const.CSS_TAGNAME('IFRAME'))))
        #self.driver.switch_to.frame(iframe)
        pass

if __name__ == '__main__':
    data = croller()
    data.crolling()

