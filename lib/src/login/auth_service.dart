import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/*
class AuthService {
  final GraphQLClient client;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthService({required this.client});

  final String loginMutation = """
  mutation LoginMutation(\$username: String!, \$password: String!) {
    tokenAuth(
      username: \$username, 
      password: \$password
    ) {
      token
    }
  }
  """;

  final String signupMutation = """
  mutation SignupMutation(
    \$email: String!
    \$password: String!
    \$username: String!
  ) {
    createUser(
      email: \$email
      password: \$password
      username: \$username
    ) {
      user {
        id
      }
    }
  }
  """;

  Future<String?> login(String username, String password) async {
    final options = MutationOptions(
      document: gql(loginMutation),
      variables: {
        'username': username,
        'password': password,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await client.mutate(options).timeout(const Duration(seconds: 10));

    if (result.hasException) {
      print("Login failed: ${result.exception.toString()}");
      throw Exception(result.exception.toString());
    } else {
      final token = result.data?['tokenAuth']['token'];
      if (token != null) {
        await storage.write(key: 'auth_token', value: token);
        return token;
      } else {
        throw Exception("No token received from server");
      }
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> signup(String email, String password, String username) async {
    final options = MutationOptions(
      document: gql(signupMutation),
      variables: {
        'email': email,
        'password': password,
        'username': username,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await client.mutate(options).timeout(const Duration(seconds: 10));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
  }
}
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final url = 'https://flash-asset-417215.uc.r.appspot.com/graphql/';


  Future<void> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      'query': '''
        mutation LoginMutation(\$username: String!, \$password: String!) {
          tokenAuth(
            username: \$username,
            password: \$password
          ) {
            token
          }
        }
      ''',
      'variables': {
        'username': username,
        'password': password,
      },
    });

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['data']['tokenAuth']['token'];
      if (token != null) {
        await prefs.setString('auth_token', token);
        print('Login successful: $token');
      } else {
        print('No token received from server');
        throw Exception('No token received from server');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Login failed');
    }
  }

  Future<void> signup(String email, String password, String username) async {
    final prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      'query': '''
        mutation SignupMutation(\$email: String!, \$password: String!, \$username: String!) {
          createUser(
            email: \$email,
            password: \$password,
            username: \$username
          ) {
            user {
              id
            }
          }
        }
      ''',
      'variables': {
        'email': email,
        'password': password,
        'username': username,
      },
    });

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['data']['createUser']['user']['id'];
      if (userId != null) {
        print('Signup successful: User ID $userId');
      } else {
        print('No user ID received from server');
        throw Exception('No user ID received from server');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Signup failed');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
