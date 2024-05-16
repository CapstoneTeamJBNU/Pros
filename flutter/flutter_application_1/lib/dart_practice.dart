void some(List<String> arguments) {

  //변수 선언 실습
  var name = 'John';//var = 자동으로 타입 지정해줌
  //name = 1; //타입이 다르기 때문에 에러 발생
  int age = 25; //int = 정수형

  //Dynamic variable 실습
  dynamic something;//dynamic = 타입을 지정하지 않음
  something = 12;
  something = 'hello';//타입 다양화 가능

  //Null Safety 실습
  String notNull = 'Hello';
  String? nullable;
  notNull.length;
  nullable?.length;//null safety ~ ?. operator를 통해 null check를 할 수 있다.

  //final 선언 실습
  final tag = 'jbnu';//final = 한번만 할당 가능. 수정 불가.

  //late 변수 실습
  late var lateVar;//late = 나중에 할당 가능, final & var에 선언 가능. 초기 데이터 할당하지 않아도 됌.
  //ex) API에서 값을 받아 할당할 때 효과적임.
  //lateVar = 'late variable';
  //ex) 값 할당전 사례
  //print(lateVar);//컴파일 에러 발생

  //constant variables 실습
  const myname = 'gisu';//final과 유사하지만, 컴파일 시간에 상수로 평가됌.
  //const apiKey = fetchApi();//함수 통해 초기화 불가능. 컴파일러는 함수의 결과를 알 수 없음. 즉, 값을 알고 있을때 const 사용 권장.
  //final apiKey = fetchApi();//final로 선언하면 함수의 결과를 알 수 있음.
  
  //기초 데이터 타입 실습
  String str = 'h';
  int number = 1;
  bool isTrue = true;
  double tax = 1.99;
  num x = 1; // num = int, double의 부모 클래스.
  num y = 2.5;

  //List 실습
  var giveMeFive = true;
  var list = [1,2,3];
  List<int> list2 = [
    1,
    2,
    3,
    if(giveMeFive) 5,//collection if 기능. 조건식 참일때 추가. same as ~ if문 아래의 코드인 list2.add(5);
    //해당 기능은 유저 로그인 따라 네이게이션 바 UI 구성을 변경할 수 있음. 매우 유용함!
    ];//둘다 선언 가능. & ,마무리시 Dart Pad에서는 라인 수직 정리 해줌.

  //String Interpolation 실습
  var name2 = 'joonHo';
  var myage = 25;
  var friend = 'gisu\'s friend is $name2, fuck!';//변수를 문자열에 삽입 가능. $변수명 으로 레퍼런스.
  var subscrib = 'gisu is now $myage, after two years he will be ${myage+2}';//중괄호로 연산식 삽입도 가능

  //collection for 실습
  var letsCount = 'lets count number 1 to 3 by twice!';
  var countNumber = [1,2,3,for(var numbers in list)'again!, $numbers'];//기존 구문에 add메소드로 일일이 for loop 걸어서 하는거 축약

  //Maps 실습 var ~ Map<type, type> 오토 매칭
  var player = {
    'name' : name,
    'age' : myage,
  };
  Map<List<int>, bool> checksum ={
    [1,2,3,] : true, //이렇게 할당도 가능함
  };

  //Set 실습 Set<type>
  var setTest = {1,2,3,};//유니크한 요소들만 받음. 중복을 허용하지 않는다는 말.
  //반대로 리스트는 중복 요소 허용합니다.

}

//function 실습
void knock(){
  print("knock knock!");
}
String greet(String name){
  return 'Hello! my name is $name';
}
String bye(String name)=> 'Bye~ $name, see ya!';//fat arrow syntax -> 다이렉트 반환

//named parameters 실습
void kick(num power, num angle, num speed){

}
void kick2({num power=0, num angle=0, num speed=0}){//매개변수 명명기법은 매개변수의 디폴트값이 주어지거나,
  
}
void kick3({required num power, required num angle, required num speed}){//이렇게 required를 붙여 필수 입력으로 요구 가능.
  //이러한 사유는 널 세이프티를 위함.
}
void play(){
  kick(3,4,5);//기본적인 형태
  kick2(power: 4.3, angle: 45.2, speed: 30);//네임 태깅 -> 순서 상관 없음.
}

//optional positional parameters 실습
void kick4(num power, num angle, [num? speed = 10.0]){} //이러면 파라미터 speed 전달 안해도 정상 작동 가능.

//QQ Operator 실습
String capitalize(String? name) => name?.toUpperCase() ?? 'Null';//널 세이프티 연산자. name이 널이면 'Null' 반환. 삼항연산자와 유사.
void nullAware(){
  String? isNull;
  isNull ??= 'Yes';// ??= ~ 널이면 할당
}

//typedef 실습
typedef ListOfInt = List<int>;//type alias 자료형 별명 지정
typedef UserInfo = Map<String, int>;
ListOfInt reverseList(ListOfInt list) => list.reversed.toList();//자료형의 축약형으로 사용 가능.
void sayHello(UserInfo player){
  print('Hello, ${player['name']}');
}

//class chapter 1 실습
class Castle{
  late final name;//var 대신 final쓰면 읽기 전용으로.
  late var width;
  late var height;

  // Castle(){//생성자
  //   this.name = 'namhansanseong';//late로 선언했기 때문에 생성자에서 초기화 가능.
  //   this.width = 500;//인스턴스 변수 할당, 매개변수로 객체화시 값 지정도 가능함.
  //   this.height = 20;
  // }
  Castle(this.name, this.width, this.height);//생성자 축약형
  void practice(){//클래스 내부 함수
    var name = 'bookhansung';
    print('There is a castle named $name');//보통 이렇게 사용가능하나,
    print('There is a castle named ${this.name}');//this를 통해 클래스 내부 변수에 접근 가능.
    //Dart에서는 this 사용을 별로 권장하진 않는다. 그러나 위와 같이 쉐도잉이 일어날 때 사용 가능함.
    //그러나 쉐도잉 상황을 피하는게 나음.
  }
}
void pract(){
  //var myCastle = Castle();
  var myCastle = Castle('namhansanseong', 500, 20);//생성자로 객체화 및 매개변수로 속성 초기화
  print(myCastle.name);
  myCastle.practice();
}