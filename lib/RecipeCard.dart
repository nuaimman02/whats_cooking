import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String searchValue = "";
  String sortOrder = "none";
  bool searchByIngredient = false;

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sort by Rating:"),
                DropdownButton<String>(
                  value: sortOrder,
                  items: [
                    DropdownMenuItem(
                      value: "none",
                      child: Text("None"),
                    ),
                    DropdownMenuItem(
                      value: "high_to_low",
                      child: Text("High to Low"),
                    ),
                    DropdownMenuItem(
                      value: "low_to_high",
                      child: Text("Low to High"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortOrder = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: searchByIngredient,
                onChanged: (bool? value) {
                  setState(() {
                    searchByIngredient = value!;
                  });
                },
              ),
              Text('Search by Ingredient'),
            ],
          ),
          Expanded(
            child: RecipeGrid(
              searchValue: searchValue,
              sortOrder: sortOrder,
              searchByIngredient: searchByIngredient,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeGrid extends StatelessWidget {
  final String searchValue;
  final String sortOrder;
  final bool searchByIngredient;

  RecipeGrid({
    required this.searchValue,
    required this.sortOrder,
    required this.searchByIngredient,
  });

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

        // Filter the recipes based on the search value and search by ingredient flag
        if (searchValue.isNotEmpty) {
          recipeList = recipeList.where((doc) {
            String name = doc['name'].toString().toLowerCase();
            String ingredients = doc['ingredients'].toString().toLowerCase();
            return searchByIngredient
                ? ingredients.contains(searchValue.toLowerCase())
                : name.contains(searchValue.toLowerCase());
          }).toList();
        }

        // Sort the recipes based on the selected sort order
        if (sortOrder != "none") {
          recipeList.sort((a, b) {
            double ratingA = a['averageRating']?.toDouble() ?? 0.0;
            double ratingB = b['averageRating']?.toDouble() ?? 0.0;
            return sortOrder == "high_to_low"
                ? ratingB.compareTo(ratingA)
                : ratingA.compareTo(ratingB);
          });
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
    double averageRating = recipe['averageRating']?.toDouble() ?? 0.0;

    return Card(
      margin: EdgeInsets.all(8.0),
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
            Flexible(
              flex: 2,
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
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe["name"],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < averageRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
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
                      width: 300,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/recipe2.jpg',
                      height: 250,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    recipe["name"],
                    style: TextStyle(
                      fontSize: 28.0,
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
                        fontFamily: 'Nunito',
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
                        fontFamily: 'Nunito',
                        height: 1.5,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 16.0),
                  RatingWidget(recipe),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingWidget extends StatefulWidget {
  final QueryDocumentSnapshot recipe;

  RatingWidget(this.recipe);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currentRating = 0;

  Future<void> _submitRating() async {
    if (_currentRating > 0) {
      try {
        final recipeRef = FirebaseFirestore.instance.collection('recipes').doc(widget.recipe.id);
        final recipeSnapshot = await recipeRef.get();

        if (!recipeSnapshot.exists) {
          throw Exception('Recipe document does not exist');
        }

        final recipeData = recipeSnapshot.data();
        if (recipeData == null) {
          throw Exception('Recipe data is null');
        }

        List<int> ratings = recipeData['ratings'] != null
            ? List<int>.from(recipeData['ratings'])
            : [];
        ratings.add(_currentRating);

        double averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

        await recipeRef.update({
          'ratings': ratings,
          'averageRating': averageRating,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rating submitted successfully!')));

        setState(() {
          _currentRating = 0;
        });
      } catch (e) {
        print('Error submitting rating: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit rating. Please try again.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a rating before submitting.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _currentRating ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
              onPressed: () {
                setState(() {
                  _currentRating = index + 1;
                });
              },
            );
          }),
        ),
        ElevatedButton(
          onPressed: _submitRating,
          child: Text('Submit Rating'),
        ),
      ],
    );
  }
}
