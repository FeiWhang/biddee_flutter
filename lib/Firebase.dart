import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> logIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "logedin";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> register({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return "registered";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

class DatabaseService {
  final FirebaseDatabase _firebaseDB = FirebaseDatabase.instance;

  final User _user = FirebaseAuth.instance.currentUser;

  Future<String> addUser(
      {String firstName, String lastName, String email}) async {
    try {
      await _firebaseDB.reference().child('users').child(_user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
      return "addedNewUser";
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future<String> addMyItem({
    String title,
    String description,
    String startingPrice,
    String minPerBid,
    String imgDataUrl,
    String endAt,
  }) async {
    try {
      final DateTime dt = DateTime.now();
      final newItem = {
        'sellerID': _user.uid,
        'title': title,
        'startingPrice': int.parse(startingPrice),
        // current is starting at create
        'currentPrice': int.parse(startingPrice),
        'minPerBid': int.parse(minPerBid),
        'beginAt': dt.toIso8601String(),
        'endAt': endAt,
        'imgDataUrl': imgDataUrl,
        'description': description,
      };

      // get item id
      final itemID = _firebaseDB.reference().child('items').push().key;

      // add to items/
      await _firebaseDB.reference().child('items').child(itemID).set(newItem);

      // add itemID to myitems in users/
      final _usersRef = _firebaseDB.reference().child('users').child(_user.uid);
      await _usersRef.child('myItems').once().then((snapshot) {
        if (snapshot.value != null) {
          _usersRef.child('myItems').set(snapshot.value + [itemID]);
        } else {
          _usersRef.child('myItems').set([itemID]);
        }
      });

      return "addedMyItem";
    } catch (e) {
      print(e);
      return e.message;
    }
  }

  Future<List<Map>> fetchMyItems() async {
    try {
      // get itemIDs from users/
      var itemIDsSnapshot = await _firebaseDB
          .reference()
          .child('users')
          .child(_user.uid)
          .child('myItems')
          .once();
      var itemIDs = itemIDsSnapshot.value;

      // if no item return empty list
      if (itemIDs == null) {
        return [];
      }

      List<Map> myItems = [];

      // then for each item get
      for (var itemID in itemIDs) {
        var itemSnapshot =
            await _firebaseDB.reference().child('items').child(itemID).once();
        Map itemData = itemSnapshot.value;
        String endDate = itemData['endAt'];
        String dd = endDate.substring(8, 10);
        String mm = endDate.substring(5, 7);
        String yy = endDate.substring(0, 4);
        String hrs = endDate.substring(11, 13);
        String min = endDate.substring(14, 16);
        String endAt = dd + "/" + mm + "/" + yy + " at " + hrs + ":" + min;

        DateTime endDT = DateTime.parse(itemData['endAt']);
        DateTime now = DateTime.now();

        Map myItem = {
          'title': itemData['title'],
          'currentPrice': itemData['currentPrice'],
          'endAt': endAt,
          'status': endDT.isAfter(now),
          'imgDataUrl': itemData['imgDataUrl'].split(',')[1],
        };
        myItems.add(myItem);
      }
      return myItems;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
