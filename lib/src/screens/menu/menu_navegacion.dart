import 'package:flutter/material.dart';
import 'package:nasa_app/src/screens/images/image_list_screen.dart';
import 'package:nasa_app/src/screens/images/new_image.dart';

// <>
class MenuNavegacion extends StatefulWidget {
  const MenuNavegacion({super.key});

  @override
  MenuNavegacionState createState() => MenuNavegacionState();
}

class MenuNavegacionState extends State<MenuNavegacion> {
  int index = 0;

  final pantallas = [
    ImageListScreen(),
    NewImageScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: pantallas[index],
      bottomNavigationBar: NavigationBar(
        height: altura * 0.08,
        selectedIndex: index,
        animationDuration: const Duration(seconds: 2),
        onDestinationSelected: (index) => setState(() => this.index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.image_outlined),
            selectedIcon: Icon(Icons.image),
            label: 'Imágenes',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_a_photo_outlined),
            selectedIcon: Icon(Icons.add_a_photo),
            label: 'Nueva imagen',
          ),
        ],
      ),
    );
  }
}
