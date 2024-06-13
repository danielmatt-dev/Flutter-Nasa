import 'package:flutter/material.dart';
import 'package:nasa_app/src/screens/images/image_service.dart';

class ImageCard extends StatefulWidget {
  final dynamic image;
  final VoidCallback? refetch;

  ImageCard({required this.image, this.refetch});

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _isVoted = false;
  int _voteCount = 0;

  @override
  void initState() {
    super.initState();
    _isVoted = widget.image['votes'].isNotEmpty;
    _voteCount = widget.image['votes'].length;
  }

  Future<void> _voteForImage() async {
    final imageService = ImageService();

    try {
      int imgId = int.parse(widget.image['id']); // Convertir el id a int
      await imageService.voteForImage(imgId);
      setState(() {
        _isVoted = true;
        _voteCount += 1;  // Incrementa el contador de votos
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Voto creado!')),
      );
      if (widget.refetch != null) {
        widget.refetch!();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to vote: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: 200, // Ajusta la altura de la imagen según sea necesario
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(widget.image['imgSrc']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${widget.image['id']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Posted by: ${widget.image['postedBy']['username']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _voteForImage,
                      icon: Icon(
                        _isVoted ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      label: Text('Votar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.surface,
                      ),
                    ),
                    Text(
                      '$_voteCount',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
