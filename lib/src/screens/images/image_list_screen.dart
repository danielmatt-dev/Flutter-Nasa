import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nasa_app/src/login/login_screen.dart';
import 'image_card.dart';

const String IMAGES_QUERY = """
  {
    allImages {
      id
      imgSrc
      roverName
      cameraName
      earthDate
      postedBy {
        username
      }
      votes {
        id
      }
    }
  }
""";

class ImageListScreen extends StatelessWidget {

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasa Images'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(document: gql(IMAGES_QUERY)),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          final List images = result.data?['allImages'];

          if (images.isEmpty) {
            return const Center(child: Text('No images found'));
          }

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ImageCard(image: images[index], refetch: refetch);
            },
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) async {
    await storage.delete(key: 'auth_token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }
}
