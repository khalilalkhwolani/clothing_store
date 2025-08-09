import 'package:bcrypt/bcrypt.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/DB/database_helper.dart';
import 'package:myprojectshop/model/user_model.dart';
import 'package:myprojectshop/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // الحالة الحالية للمستخدم
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  int? get currentUserId => currentUser.value?.id;
  String? get userRole =>
      currentUser.value?.role; // اجلب الدور من بيانات المستخدم
  bool get isAdmin => userRole == 'admin';
  String? get username => currentUser.value?.username;
  String? get email => currentUser.value?.email;

  AuthController();

  void clearError() {
    errorMessage.value = '';
  }

  // Future<void> loadUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getInt('current_user_id');
  //   if (userId != null) {
  //     final userMap = await _dbHelper.getUserById(userId);
  //     if (userMap != null) {
  //       currentUser.value = UserModel.fromMap(userMap);
  //       isLoggedIn.value = true;
  //     }
  //   }}
  // }
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id'); // ✅ نفس المفتاح

    if (userId == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    print('Fetched user with ID: $userId');

    final userMap = await _dbHelper.getUserById(userId);

    print('User Map: $userMap');

    if (userMap == null) {
      print('User not found in database');
      return;
    }

    currentUser.value = UserModel.fromMap(userMap);
    print('User loaded: ${currentUser.value}');
    print('User name: ${currentUser.value?.username}');
    print('User email: ${currentUser.value?.email}');
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      isLoading.value = true;
      clearError();

      if (username.length < 3) {
        errorMessage.value = 'Username must be at least 3 characters long.';
        return false;
      }
      // if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      //   errorMessage.value = 'Username can only contain letters, numbers, and underscores.';
      //   return false;
      // }

      if (!GetUtils.isEmail(email)) {
        errorMessage.value = 'Please enter a valid email address.';
        return false;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters long.';
        return false;
      }

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        errorMessage.value = 'All fields are required';
        return false;
      }

      if (!GetUtils.isEmail(email)) {
        errorMessage.value = 'Invalid email format';
        return false;
      }

      final existingUserByUsername = await _dbHelper.getUserByUsername(
        username,
      );
      if (existingUserByUsername != null) {
        errorMessage.value = 'Username already exists';
        return false;
      }

      final existingUserByEmail = await _dbHelper.getUserByEmail(email);
      if (existingUserByEmail != null) {
        errorMessage.value = 'Email is already in use';
        return false;
      }

      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      final userData = {
        'username': username,
        'email': email,
        'password': hashedPassword,
        'role': role,
      };

      final userId = await _dbHelper.insertUser(userData);

      if (userId > 0) {
        final user = await _dbHelper.getUserById(userId);
        if (user != null) {
          currentUser.value = UserModel.fromMap(user);
          isLoggedIn.value = true;
          await saveCurrentUserId(userId);
          return true;
        }
      } else {
        errorMessage.value = 'Registration failed. Please try again.';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
    // Ensure a return value in case all other paths are skipped

    print('Registering user: $username, $email');
    return false;
  }

  Future<void> insertAdminIfNeeded() async {
    try {
      final db = await _dbHelper.database;

      final existingAdmin = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: ['admin'],
      );

      if (existingAdmin.isEmpty) {
        final hashedPassword = BCrypt.hashpw('123123', BCrypt.gensalt());

        await db.insert('users', {
          'username': 'admin',
          'email': 'aaaaa@Example.com',
          'password': hashedPassword,
          'role': 'admin',
        });
        print("Admin user inserted.");
      } else {
        print("Admin already exists.");
      }
    } catch (e) {
      print("Error inserting admin: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    insertAdminIfNeeded();
    fetchAllUsers();
  }

  // Fetch all users from the database
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final List<Map<String, dynamic>> userMaps = await _dbHelper.getAllUsers();
      return userMaps.map((data) => UserModel.fromMap(data)).toList();
    } catch (e) {
      print("Error fetching users: $e");
      Get.snackbar('Error', 'Failed to load users: $e');
      return [];
    }
  }

  Future<bool> loginUser({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      clearError();

      if (usernameOrEmail.isEmpty || password.isEmpty) {
        errorMessage.value = 'Username/Email and password are required.';
        return false;
      }

      final bool isEmail = GetUtils.isEmail(usernameOrEmail);

      Map<String, dynamic>? userMap;

      if (isEmail) {
        userMap = await _dbHelper.getUserByEmail(usernameOrEmail);
      } else {
        userMap = await _dbHelper.getUserByUsername(usernameOrEmail);
      }

      if (userMap == null) {
        errorMessage.value = 'No account found with these credentials.';
        return false;
      }

      // final bool passwordMatches = BCrypt.checkpw(
      //   password,
      //   userMap['password'],
      // );
      // if (!passwordMatches) {
      //   errorMessage.value = 'Incorrect password';
      //   return false;
      // }
      if (!BCrypt.checkpw(password, userMap['password'])) {
        errorMessage.value = 'Incorrect password. Please try again.';
        return false;
      }

      final user = UserModel.fromMap(userMap);
      currentUser.value = user;
      isLoggedIn.value = true;

      await saveCurrentUserId(user.id!);
      return true;
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveCurrentUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);
    // final userId = prefs.getInt('current_user_id'); // ✅ المفتاح الصحيح
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    currentUser.value = null;
    Get.offAll(LoginScreen());
    isLoggedIn.value = false;
  }
}
