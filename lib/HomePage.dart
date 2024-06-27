import 'package:flutter/material.dart';
import 'package:whats_cooking/RecipeCard.dart';
import 'HomeScreen.dart'; // Import your HomeScreen

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _showLogoutConfirmation(context);
          },
        ),
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/whatscooking_logo.png',
              height: screenHeight * 0.1,
              width: screenWidth * 0.25,
            ),
            const SizedBox(width: 10),
            const Text("What's Cooking"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to our What\'s Cooking App',
              style: TextStyle(
                fontSize: screenHeight * 0.03, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              'assets/images.jpg',
              height: screenHeight * 0.4,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildButton(
              context,
              'Explore Our Recipes',
              RecipeScreen(),
              screenHeight,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildButton(
              context,
              'Add Your Recipe',
              HomeScreen(),
              screenHeight,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create buttons
  Widget _buildButton(BuildContext context, String text, Widget destination, double screenHeight) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: screenHeight * 0.025),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Perform the logout (pop the current screen)
              },
            ),
          ],
        );
      },
    );
  }
}
