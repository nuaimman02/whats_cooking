import 'package:flutter/material.dart';

class SuccessSign extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  SuccessSign({required this.message, required this.onDismiss});

  @override
  _SuccessSignState createState() => _SuccessSignState();
}

class _SuccessSignState extends State<SuccessSign> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _isVisible = true;

    // Hide the success sign after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        widget.onDismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Center(
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 10),
            Text(
              widget.message,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    )
        : SizedBox.shrink();
  }
}
