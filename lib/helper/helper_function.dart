// display error message to user
import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.error, size: 50),
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
