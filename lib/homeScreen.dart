import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_cooking/RecipeCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              height: 80,
              width: 100,
            ),
            const SizedBox(width: 10),
            const Text("What's Cooking"),
          ],
        ),
      ),
      body: RecipeCard(),
    );
  }
}

class RecipeCard extends StatefulWidget {
  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController recipeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child('recipes/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }


  Future<void> addRecipe(String name, String ingredients, String steps) async {
    // Check if the form is valid
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, proceed to add the recipe
      final CollectionReference recipes =
          FirebaseFirestore.instance.collection('recipes');

      // Generate a unique ID for the recipe
      String recipeId = DateTime.now().millisecondsSinceEpoch.toString();

      String? imageUrl;

      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      // Add the recipe details to Firestore
      await recipes.add({
        'id': recipeId, // Include a unique ID for the recipe
        'name': name,
        'ingredients': ingredients,
        'steps': steps,
        'imageUrl': imageUrl,
      }).then((_) {
        // Navigate to RecipeScreen after adding the recipe
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RecipeScreen(), // Pass the recipeId to RecipeScreen
          ),
        );

        // Clear the text fields and image path after adding the recipe
        setState(() {
          recipeNameController.clear();
          ingredientsController.clear();
          stepsController.clear();
          _image = null;
        });
      });

      // Continue with the rest of your code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: recipeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your recipe name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your recipe Ingredients';
                    }
                    return null;
                  },
                  maxLines: 5,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: stepsController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Recipe';
                    }
                    return null;
                  },
                  maxLines: 5,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick Image"),
                ),
                SizedBox(height: 16.0),
                _image != null
                    ? Image.file(_image!)
                    : Text('No image selected'),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    addRecipe(
                      recipeNameController.text,
                      ingredientsController.text,
                      stepsController.text,
                    );
                  },
                  child: Text("Add Recipe"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
