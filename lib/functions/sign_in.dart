import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ritoku_app/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final databaseReference = FirebaseAuth.instance;
String name;
String email;
String imageUrl;
String usertemp;
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  usertemp = user.displayName;
  //notes.add(new Note("noteDesc", "noteName", 0, 0));
  //start new shit
  final snapShot = await Firestore.instance
  .collection('users')
  .document('$email')
  .get();

if (snapShot == null || !snapShot.exists) {
  print("$email doesnt exists");
  createRecord();
}else{
  print("$email exists");
}

  return 'signInWithGoogle succeeded: $user';
}

Future<String>  signOutGoogle() async{
  await googleSignIn.signOut();
  notes.clear();
  countHours = 0; 
  countMinutes = 0; 
  countRank = 0; 
  countStreak = 0;
  return "User Sign Out";
}

void createRecord() async {
  await Firestore.instance.collection("users")
      .document("$email")
      .setData({
        'hours': 0,
        'minutes': 0,
        'rank': 0,
        'streak': 0,
        'notecount' : 0
      });
}
