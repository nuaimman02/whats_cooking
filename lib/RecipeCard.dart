import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/whatscooking_logo.png',
              height: 40,
              width: 50,
            ),
            const SizedBox(width: 10),
            const Text("What's Cooking"),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Recipe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RecipeGrid(searchValue: searchValue),
          ),
        ],
      ),
    );
  }
}

class RecipeGrid extends StatelessWidget {
  final String searchValue;

  RecipeGrid({required this.searchValue});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("recipes").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No recipes found.'));
        }

        List<QueryDocumentSnapshot> recipeList = snapshot.data!.docs;

        // Filter the recipes based on the search value
        if (searchValue.isNotEmpty) {
          recipeList = recipeList.where((doc) {
            String name = doc['name'].toString().toLowerCase();
            return name.contains(searchValue.toLowerCase());
          }).toList();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: recipeList.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipeList[index]);
          },
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final QueryDocumentSnapshot recipe;

  RecipeCard(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetails(recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: recipe['imageUrl'] != null
                  ? Image.network(
                recipe['imageUrl'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/recipe.png',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe["name"],
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Icon(Icons.star_half, color: Colors.yellow, size: 16),
                      Icon(Icons.star_border, color: Colors.yellow, size: 16),
                      SizedBox(width: 4.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeDetails extends StatelessWidget {
  final QueryDocumentSnapshot recipe;

  RecipeDetails(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/whatscooking_logo.png',
              height: 40,
              width: 50,
            ),
            const SizedBox(width: 10),
            const Text("What's Cooking"),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: recipe['imageUrl'] != null
                        ? Image.network(
                      recipe['imageUrl'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/recipe2.jpg',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    recipe["name"],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "INGREDIENTS",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      recipe["ingredients"],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "RECIPE",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      recipe["steps"],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
