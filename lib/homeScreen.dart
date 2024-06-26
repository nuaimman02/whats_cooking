import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_cooking/SuccessSign.dart'; // Import SuccessSign widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController recipeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController stepsController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _showSuccess = false;

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
    Reference storageReference =
    FirebaseStorage.instance.ref().child('recipes/$fileName');
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
        'ratings' :[],
        'averageRating' : 0,
      }).then((_) {
        // Show success sign
        setState(() {
          _showSuccess = true;
        });

        // Clear the text fields and image path after adding the recipe
        setState(() {
          recipeNameController.clear();
          ingredientsController.clear();
          stepsController.clear();
          _image = null;
        });
      });
    }
  }

  void _dismissSuccessSign() {
    setState(() {
      _showSuccess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/whatscooking_logo.png',
              height: 80,
              width: 100,
            ),
            const SizedBox(width: 10),
            const Text("What's Cooking"),
          ],
        ),
      ),
      body: Stack(
        children: [
          RecipeCard(
            formKey: _formKey,
            recipeNameController: recipeNameController,
            ingredientsController: ingredientsController,
            stepsController: stepsController,
            image: _image,
            pickImage: _pickImage,
            addRecipe: addRecipe,
          ),
          if (_showSuccess)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                alignment: Alignment.center,
                child: SuccessSign(
                  message: 'Recipe added successfully!',
                  onDismiss: _dismissSuccessSign,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController recipeNameController;
  final TextEditingController ingredientsController;
  final TextEditingController stepsController;
  final File? image;
  final VoidCallback pickImage;
  final Function(String, String, String) addRecipe;

  RecipeCard({
    required this.formKey,
    required this.recipeNameController,
    required this.ingredientsController,
    required this.stepsController,
    required this.image,
    required this.pickImage,
    required this.addRecipe,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                    labelText: 'Steps',
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
                  onPressed: pickImage,
                  child: Text("Pick Image"),
                ),
                SizedBox(height: 16.0),
                image != null ? Image.file(image!) : Text('No image selected'),
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
