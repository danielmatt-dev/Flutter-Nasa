import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nasa_app/src/login/login_screen.dart';
import 'package:nasa_app/src/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final HttpLink httpLink = HttpLink('https://flash-asset-417215.uc.r.appspot.com/graphql/');

  final AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      return 'JWT ${prefs.getString('token')}';
    },
  );

  final Link link = authLink.concat(httpLink);

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;

  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        theme: AppTheme().getLightTheme(context),
      ),
    );
  }
}
