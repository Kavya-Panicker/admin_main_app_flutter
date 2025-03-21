// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthService {
//   static Future<bool> login(String email, String password) async {
//     final response = await http.post(
//       Uri.parse("YOUR_BACKEND_API/login"),
//       body: jsonEncode({"email": email, "password": password}),
//       headers: {"Content-Type": "application/json"},
//     );

//     if (response.statusCode == 200) {
//       return true; // Login success
//     } else {
//       return false; // Login failed
//     }
//   }
// }
