import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models.dart';

class FirebaseService {
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Save user profile to Firestore
  static Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection('user_profiles').doc(profile.email).set({
        'name': profile.name,
        'email': profile.email,
        'dateOfBirth': profile.dateOfBirth.toIso8601String(),
        'mobileNumber': profile.mobileNumber,
        'registrationDate': profile.registrationDate.toIso8601String(),
        'age': profile.age,
        'isAdult': profile.isAdult,
      });
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  // Save quiz answers to Firestore
  static Future<void> saveQuizAnswers(
      String userEmail, List<UserAnswer> answers) async {
    try {
      final batch = _firestore.batch();

      for (UserAnswer answer in answers) {
        final docRef = _firestore
            .collection('quiz_responses')
            .doc(userEmail)
            .collection('answers')
            .doc(answer.questionId);

        batch.set(docRef, {
          'questionId': answer.questionId,
          'selectedOptionIndex': answer.selectedOptionIndex,
          'timestamp': answer.timestamp.toIso8601String(),
        });
      }

      await batch.commit();
    } catch (e) {
      print('Error saving quiz answers: $e');
    }
  }

  // Save quiz completion status
  static Future<void> saveQuizCompletion(
      String userEmail, int totalQuestions, int answeredQuestions) async {
    try {
      await _firestore.collection('quiz_completions').doc(userEmail).set({
        'userEmail': userEmail,
        'totalQuestions': totalQuestions,
        'answeredQuestions': answeredQuestions,
        'completionDate': DateTime.now().toIso8601String(),
        'isCompleted': answeredQuestions >= totalQuestions,
      });
    } catch (e) {
      print('Error saving quiz completion: $e');
    }
  }

  // Get user profile from Firestore
  static Future<Map<String, dynamic>?> getUserProfile(String email) async {
    try {
      final doc = await _firestore.collection('user_profiles').doc(email).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Get quiz answers from Firestore
  static Future<List<Map<String, dynamic>>> getQuizAnswers(
      String userEmail) async {
    try {
      final snapshot = await _firestore
          .collection('quiz_responses')
          .doc(userEmail)
          .collection('answers')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting quiz answers: $e');
      return [];
    }
  }

  // Get all user profiles (for admin)
  static Future<List<Map<String, dynamic>>> getAllUserProfiles() async {
    try {
      final snapshot = await _firestore.collection('user_profiles').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting all user profiles: $e');
      return [];
    }
  }

  // Get quiz statistics
  static Future<Map<String, dynamic>> getQuizStatistics() async {
    try {
      final completionsSnapshot =
          await _firestore.collection('quiz_completions').get();
      final profilesSnapshot =
          await _firestore.collection('user_profiles').get();

      int totalUsers = profilesSnapshot.docs.length;
      int completedQuizzes = completionsSnapshot.docs
          .where((doc) => doc.data()['isCompleted'] == true)
          .length;

      return {
        'totalUsers': totalUsers,
        'completedQuizzes': completedQuizzes,
        'completionRate': totalUsers > 0
            ? (completedQuizzes / totalUsers * 100).toStringAsFixed(1)
            : '0',
      };
    } catch (e) {
      print('Error getting quiz statistics: $e');
      return {
        'totalUsers': 0,
        'completedQuizzes': 0,
        'completionRate': '0',
      };
    }
  }
}
