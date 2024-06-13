import 'package:graphql_flutter/graphql_flutter.dart';

class ImageService {
  final GraphQLClient client;

  ImageService({required this.client});

  final String feedQuery = """
  query {
    allImages {
      id
      imgSrc
      roverName
      cameraName
      earthDate
      postedBy {
        id
        username
      }
      votes {
        id
      }
    }
  }
  """;

  final String voteMutation = """
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
  """;

  final String createImageMutation = """
  mutation CreateImage(
    \$imgSrc: String!,
    \$roverName: String!,
    \$cameraName: String!,
    \$earthDate: Date!
  ) {
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
  """;

  Future<List<dynamic>> fetchImages() async {
    final options = QueryOptions(
      document: gql(feedQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    try {
      final result = await client.query(options).timeout(const Duration(seconds: 10));
      if (result.hasException) {
        print('GraphQL Exception: ${result.exception.toString()}');
        throw Exception(result.exception.toString());
      } else {
        print('GraphQL Data: ${result.data}');
        return result.data?['allImages'] ?? [];
      }
    } catch (e) {
      print('Failed to load images: $e');
      throw Exception('Failed to load images: $e');
    }
  }

  Future<void> voteForImage(int imgId) async {
    final options = MutationOptions(
      document: gql(voteMutation),
      variables: {
        'imgId': imgId,
      },
    );

    try {
      final result = await client.mutate(options).timeout(const Duration(seconds: 10));
      if (result.hasException) {
        print('Exception: ${result.exception.toString()}');
        throw Exception(result.exception.toString());
      } else {
        print('Vote Data: ${result.data}');
      }
    } catch (e) {
      print('Failed to vote for image: $e');
      throw Exception('Failed to vote for image: $e');
    }
  }

  Future<void> createImage(String imgSrc, String roverName, String cameraName, String earthDate) async {
    final options = MutationOptions(
      document: gql(createImageMutation),
      variables: {
        'imgSrc': imgSrc,
        'roverName': roverName,
        'cameraName': cameraName,
        'earthDate': earthDate,
      },
    );

    try {
      final result = await client.mutate(options).timeout(const Duration(seconds: 10));
      if (result.hasException) {
        print('Exception: ${result.exception.toString()}');
        throw Exception(result.exception.toString());
      } else {
        print('Create Image Data: ${result.data}');
      }
    } catch (e) {
      print('Failed to create image: $e');
      throw Exception('Failed to create image: $e');
    }
  }
}
