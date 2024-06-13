import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageService {
  final url = 'https://flash-asset-417215.uc.r.appspot.com/graphql/';

  Future<List<dynamic>> fetchImages() async {
    final body = jsonEncode({
      'query': '''
        query {
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
      '''
    });

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data']['allImages'] ?? [];
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to load images');
    }
  }

  Future<void> voteForImage(int imgId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    if (authToken == null) {
      throw Exception('No auth token found');
    }

    final body = jsonEncode({
      'query': '''
        mutation CreateVote(\$imgId: Int!) {
          createVote(imgId: \$imgId) {
            img {
              id
              votes {
                id
              }
            }
          }
        }
      ''',
      'variables': {
        'imgId': imgId,
      },
    });

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'JWT $authToken',
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Vote Data: ${jsonResponse['data']}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to vote for image');
    }
  }

  Future<void> createImage(String imgSrc, String roverName, String cameraName, String earthDate) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    if (authToken == null) {
      throw Exception('No auth token found');
    }

    final body = jsonEncode({
      'query': '''
        mutation CreateImage(\$imgSrc: String!, \$roverName: String!, \$cameraName: String!, \$earthDate: Date!) {
          createImage(
            imgSrc: \$imgSrc,
            roverName: \$roverName,
            cameraName: \$cameraName,
            earthDate: \$earthDate
          ) {
            id
            imgUrl
            roverName
            cameraName
            earthDate
          }
        }
      ''',
      'variables': {
        'imgSrc': imgSrc,
        'roverName': roverName,
        'cameraName': cameraName,
        'earthDate': earthDate,
      },
    });

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'JWT $authToken',
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Create Image Data: ${jsonResponse['data']}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error message: ${response.body}');
      throw Exception('Failed to create image');
    }
  }
}
