import 'package:flutter/material.dart';
import 'package:flutter_application_1/register_page.dart';
import 'package:flutter_application_1/choice_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State{
  final TextEditingController _emailController = TextEditingController(); //입력되는 값을 제어
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // 해당 클래스가 사라질떄
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('환영합니다!')
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              // 별도의 위젯화 필수
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일',

                ),
              ),
              const Spacer(),
              // 별도의 위젯화 필수
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',

                ),
              ),
              const Spacer(),
              // 로그인 버튼 위젯화
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChoicePage()),
                  );
                  try {
                    // 사용자 인포 스터브
                    var emailAddress = 'hiyd125@jbnu.ac.kr';
                    var password = 'rltn12';
                    // 계정 로그인 시도 메소드
                    final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: emailAddress,
                      password: password
                    );
                    } on FirebaseAuthException catch (e) {
                    // 오류 핸들링 로직
                    if (e.code == 'user-not-found' ||e.code == 'wrong-password') {
                      showDialog(
                        context: context,
                        builder: ((context){
                          return AlertDialog(
                            actions: <Widget>[
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); //창 닫기
                                  },
                                child: Text("확인"),
                              ),
                            ),
                          ],
                        );
                        })
                        );
                      print('Wrong infomation please re-check your inputs');
                      }
                    else{
                      print('오류 코드 : '+e.code);
                    }
                  }
                },
                child: const Text('로그인'),
                ),
              const Spacer(
                flex: 10,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                  '아직 회원이 아니신가요?',
                  style:
                  TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                    ),
                    ),
                  ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                      child: const Text('회원가입')
                    ),
                ],
              ),
            ],
          ),
        )
      );
  }
}