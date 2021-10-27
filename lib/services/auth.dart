import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasktodo_app/exceptions/auth_exception_handler.dart';
import 'package:tasktodo_app/model/exception_data.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthResultStatus _status = AuthResultStatus.undefined;

  Stream<User?> get user => auth.authStateChanges();

  // create Account...................
  Future<AuthResultStatus> createAccount({required String email, required String password}) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        _status = AuthResultStatus.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        _status = AuthResultStatus.emailAlreadyExists;
      }
    } 
    catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // sign In Method........................
  Future<AuthResultStatus> signIn({required String email, required String password}) async {
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        _status = AuthResultStatus.userNotFound;
      } else if (e.code == 'wrong-password') {
        _status = AuthResultStatus.wrongPassword;
      }
    }
    
    catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // sign Out Method..............................
  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } 
    catch (e) {
      rethrow;
    }
  }

}