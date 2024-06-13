import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../images/image_service.dart';

class NewImageScreen extends StatefulWidget {
  @override
  _NewImageScreenState createState() => _NewImageScreenState();
}

class _NewImageScreenState extends State<NewImageScreen> {
  final TextEditingController _imgSrcController = TextEditingController();
  final TextEditingController _roverNameController = TextEditingController();
  final TextEditingController _cameraNameController = TextEditingController();
  final TextEditingController _earthDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _createImage() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final imageService = ImageService();

      try {
        final DateTime earthDate = DateTime.parse(_earthDateController.text);
        final String formattedDate = DateFormat('yyyy-MM-dd').format(earthDate);
        await imageService.createImage(
          _imgSrcController.text,
          _roverNameController.text,
          _cameraNameController.text,
          formattedDate,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image created successfully!')),
        );
        // Opcional: Limpiar los campos después de crear la imagen
        _imgSrcController.clear();
        _roverNameController.clear();
        _cameraNameController.clear();
        _earthDateController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create image: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Image')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _imgSrcController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roverNameController,
                decoration: InputDecoration(labelText: 'Rover Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a rover name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cameraNameController,
                decoration: InputDecoration(labelText: 'Camera Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a camera name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _earthDateController,
                decoration: InputDecoration(labelText: 'Earth Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an earth date';
                  }
                  try {
                    DateTime.parse(value);
                  } catch (e) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _createImage,
                child: Text('Create Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
