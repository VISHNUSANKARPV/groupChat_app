import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys

  static String userLoginKey = "USERLOGINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data to sharedp

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
     return await sf.setBool(userLoginKey, isUserLoggedIn );
  }

    static Future<bool> saveUserNameSF(String userName)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
     return await sf.setString(userNameKey,  userName);
  }

    static Future<bool> saveUserEmailSF(String email)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
     return await sf.setString(userEmailKey, email );
  }

  //getting the data from sharedp

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoginKey);
  }

    static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

    static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
