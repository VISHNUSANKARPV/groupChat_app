import 'package:firebase_auth/firebase_auth.dart';
import 'package:groopie/helper/helper_function.dart';
import 'package:groopie/service/database_services.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

   //Login Account 

  Future loginUser( String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
       
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGNUP account

  Future registerUser(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        await DatabaseService(uid: user.uid).savingUSerData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");

      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
