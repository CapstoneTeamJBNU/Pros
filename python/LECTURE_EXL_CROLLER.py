from datetime import datetime
import time
import os

from selenium import webdriver
from selenium.webdriver import ActionChains

from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait
DOWNLOAD_PATH = './demo-repository-1/python/EXCEL'
KEYS = {
    'URL' : 'https://all.jbnu.ac.kr/jbnu/sugang/sbjt/sbjt.html',
    'SEARCH' : '#mainframe_childframe_form_divSearch_btnSearchTextBoxElement > div',
    'EXL' : '#mainframe_childframe_form_btnExcelDownTextBoxElement > div',
    'TABLE' : '#mainframe_childframe_form_grdLessSubjtExcel_bodyTextBoxElement > div',
    'SEARCHING' : '#mainframe_waitwindowImageElement > img',
    'FIRST_ELEM' : '#mainframe_childframe_form_grdLessSubjtExcel_body_gridrow_0GridAreaContainerElement',
    'MONTH' : '#mainframe_childframe_form_divSearch_cboShtm_comboedit_input',
    'YEAR' : '#mainframe_childframe_form_divSearch_spnYy_spinedit_input',
    'RSCRL' : '#mainframe_childframe_form_grdLessSubjtExcel_hscrollbar_incbuttonAlignImageElement',
    'DSCRL' : '#mainframe_childframe_form_grdLessSubjtExcel_vscrollbar_incbuttonAlignImageElement',
}
TABLE_ATTR = 'innerText'
BOX_ATTR = 'value'
SEASON = ['계절학기(동기)','2학기','계절학기(하기)','1학기']



class croll:
    def __init__(self):
        self.driver = webdriver

        self.options = webdriver.ChromeOptions()
        # 사람처럼 보이게 하는 옵션들
        self.options.add_argument("disable-gpu")  # 가속 사용 x
        self.options.add_argument("lang=ko_KR")  # 가짜 플러그인 탑재
        # 백그라운드 실행 - 클릭 인터셉트 이슈
        # self.options.add_argument("headless")
        self.options.add_argument(
            'user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36')  # user-agent 이름 설정
        self.options.add_experimental_option("prefs", {
            "download.default_directory": os.path.abspath(DOWNLOAD_PATH),
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True
        })
        print(os.path.abspath(DOWNLOAD_PATH))
        self.driver = webdriver.Chrome(self.options)
        self.driver.implicitly_wait(10)

        # 화면 사이즈 조정
        self.driver.fullscreen_window()

    def download_exl(self):
        self.driver.get(KEYS.get('URL'))
        cnt = 0
        wait = WebDriverWait(self.driver, 10)
        searchBtn = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, KEYS.get('SEARCH'))))
        searchBtn.click()
        while(wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, KEYS.get('FIRST_ELEM'))))==None):
            time.sleep(1)

        self.driver.find_element(By.CSS_SELECTOR, KEYS.get('EXL')).click()
        while cnt<2:
            if self.driver.find_element(By.CSS_SELECTOR, KEYS.get('TABLE')).get_property(TABLE_ATTR) == '조회된 데이터가 없습니다.':
                if cnt == 2:
                    self.driver.close()
                    exit(1)
                cnt += 1
            
            for season in SEASON:
                month = Select(self.driver.find_element(By.CSS_SELECTOR, KEYS.get('MONTH')))
                month.select_by_value(season)
                searchBtn.click()
            year = self.driver.find_element(By.CSS_SELECTOR, KEYS.get('YEAR'))
            yr_box = Select(year)
            yr_box.select_by_value(year.get_attribute(BOX_ATTR)-1)
            searchBtn.click()
        time.sleep(20)
        self.driver.quit()

    def syllaScanH(self):
        #스크롤 횡이동 버튼 할당 및 실행
        self.driver.find_element(By.CSS_SELECTOR, KEYS.get('RSCRL')).click()

    def syllaScanV(self):
        #스크롤 종이동 버튼 할당 및 실행
        self.driver.find_element(By.CSS_SELECTOR, KEYS.get('DSCRL')).click()

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
    tmp = croll()
    tmp.download_exl()