from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import custom_firestore
import time
import Pros.python.removed.EXEL_MANAGER as exl

EXL_PATH = 'demo-repository-1/python/EXCEL'

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
        chrome_options.add_argument("--disable-popup-blocking")
        chrome_options.add_argument("--disable-extensions")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_experimental_option("prefs", {
            "download.default_directory": EXL_PATH
        })

        self.db = custom_firestore.Firestore()
        self.driver = webdriver.Chrome(chrome_options)
        # self.exl = exl.EXEL_MANAGER()

    def firstInit(self):
        #사이트 접속
        self.driver.get('http://all.jbnu.ac.kr/jbnu/sugang/sbjt/sbjt.html')
        #최대 20초 동안 대기
        wait = WebDriverWait(self.driver, 20)
        #화면 사이즈 조정
        self.driver.fullscreen_window()
        #self.driver.execute_script(self.exl.get_JAVASCRIPT(WINDOW_RESIZE))
        #조회 창 클릭
        wait.until(EC.presence_of_element_located((
            By.CSS_SELECTOR,
            '#mainframe_childframe_form_divSearch_btnSearchTextBoxElement > div'))).click()
        wait.until(EC.invisibility_of_element_located(
            (By.CSS_SELECTOR,'#mainframe_waitwindowImageElement > img')))
        self.driver.find_elements(
            By.CSS_SELECTOR,
            '#mainframe_childframe_form_btnExcelDownTextBoxElement > div').pop().click()
        time.sleep(10)

        #iframe으로 전환(아직 미구현)
        #iframe = wait.until(EC.presence_of_element_located((By.TAG_NAME, Const.CSS_TAGNAME('IFRAME'))))
        #self.driver.switch_to.frame(iframe)

        #self.colling()

    def selectorFinder(self, css_sel):
        return self.driver.find_elements(By.CSS_SELECTOR, self.exl.read_exl(css_sel)) if (isMultiple == True) else {
            self.driver.find_element(By.CSS_SELECTOR, self.exl.get_CSS_SEL(css_sel))}

    def syllaScanH(self):
        #스크롤 횡이동 버튼 할당 및 실행
        self.selectorFinder(INNER_RSCROLL_BTN).pop().click()

    def syllaScanV(self):
        #스크롤 종이동 버튼 할당 및 실행
        self.selectorFinder(INNER_DSCROLL_BTN).pop().click()

    def colling(self):
        try:
            self.firstInit()
            #강의계획서 나올때까지
            while True:
                try:
                    self.syllaScanH()
                    
                    if self.selectorFinder(FIRST_ELEM_BOX).is_displayed():
                        break
                except Exception as no_such_element:
                    continue
            #0~23, 초기 22,23은 가려짐, 보통 2개씩 가려지고 횡스크롤 이동시 은닉 엘리멘트 갱신됨. 은닉 요소는 밑으로 들어감.
    
        except Exception as e:
            print(e)
        time.sleep(10)
        self.driver.quit()

if __name__ == '__main__':
    data = croller()
    data.firstInit()

