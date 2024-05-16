import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage>{
  List<TextEditingController> txtCtrl = List.generate(3, (index) => TextEditingController());
  @override
  void dispose(){
    for (TextEditingController ctrl in txtCtrl){ctrl.dispose();}
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    var emailAddress = TextField(
    obscureText: false,
    controller: txtCtrl[0],
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      labelText: '이메일',
      ),
      );
  var password = TextField(
      obscureText: true,
      controller: txtCtrl[1],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
        ),
        );
  var pwRecheck = TextField(
      obscureText: true,
      controller: txtCtrl[2],
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호 재입력',
        )
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입')
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: emailAddress,
                      ),
                  ElevatedButton(
                    onPressed: (){

                    },
                    child: const Text('인증번호 발송')
                    ),
                ],
              ),
              const Spacer(),
              password,
              const Spacer(),
              pwRecheck,
              const Spacer(
                flex: 10,
                ),
              ElevatedButton(
                    onPressed: () async{
                      try {
                        var pw = txtCtrl[1].text == txtCtrl[2].text ? txtCtrl[1].text : null;
                        if( pw == null || txtCtrl[0].text == null){
                            txtCtrl[2].text = '비밀번호 불일치! 다시 입력해주세요.';
                        }
                        else {
                          print(txtCtrl[0].text+" pw : "+txtCtrl[1].text);
                          final UserCredential credential = 
                          await _auth.createUserWithEmailAndPassword(
                            email: 'hiyd120@gmail.com',
                            password: 'rltn12',
                            );
                            print(credential.user!.email);
                            print(credential.user!.uid);
                          Navigator.pop(context);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') { print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') { print('The account already exists for that email.');
                        } else{print(e);}
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('제출')
                    ),
            ],
          ),
          ),
      );
  }
}