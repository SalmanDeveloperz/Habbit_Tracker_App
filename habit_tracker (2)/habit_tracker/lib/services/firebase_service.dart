import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/habit.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  // Habits
  Future<void> addHabit(Habit habit) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .add(habit.toMap());
    }
  }

  Stream<List<Habit>> getHabits() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Habit.fromMap(doc.data(), doc.id))
          .toList());
    }
    return Stream.value([]);
  }

  Future<void> updateHabit(Habit habit) async {
    final user = _auth.currentUser;
    if (user != null && habit.id != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toMap());
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habitId)
          .delete();
    }
  }

  Future<List<Habit>> exportHabits() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .get();
      return snapshot.docs
          .map((doc) => Habit.fromMap(doc.data(), doc.id))
          .toList();
    }
    return [];
  }

  Future<void> importHabits(List<Habit> habits) async {
    final user = _auth.currentUser;
    if (user != null) {
      final batch = _firestore.batch();
      for (var habit in habits) {
        final ref = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('habits')
            .doc();
        batch.set(ref, habit.toMap());
      }
      await batch.commit();
    }
  }
}