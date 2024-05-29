FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
/** 
 * 다음 상황이 발생하면 이벤트가 실행됩니다.
 *  1. 리스너가 등록된 직후
 *  2. 사용자가 로그인한 경우
 *  3. 현재 사용자가 로그아웃한 경우
 * */
