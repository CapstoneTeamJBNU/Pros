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
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일',

                ),
              ),
              const Spacer(),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '비밀번호',

                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  // try {
                  //   var emailAddress = 'hiyd125@jbnu.ac.kr';
                  //   var password = 'rltn12';
                  //   final credential = await FirebaseAuth.instance
                  //   .signInWithEmailAndPassword(
                  //     email: emailAddress,
                  //     password: password
                  //   );
                  //   } on FirebaseAuthException catch (e) {
                  //     if (e.code == 'user-not-found') {
                  //       print('No user found for that email.');
                  //       } else if (e.code == 'wrong-password') {
                  //         print('Wrong password provided for that user.');
                  //         }
                  //         }
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
                            MaterialPageRoute(builder: (context) => RegisterPage()),
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