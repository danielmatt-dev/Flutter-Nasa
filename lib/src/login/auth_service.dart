import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
