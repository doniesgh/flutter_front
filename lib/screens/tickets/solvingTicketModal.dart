import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SimpleHelloDialog extends StatelessWidget {
  final String ticketId;
  final TextEditingController solutionController = TextEditingController();

  SimpleHelloDialog({Key? key, required this.ticketId}) : super(key: key);

  Future<void> handleSolved(BuildContext context) async {
    final confirmationResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation de validation'),
          content: Text('Voulez-vous marquer ce ticket comme résolu ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmationResult == true) {
      if (solutionController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Oops...'),
              content: Text('Le champ ne doit pas être vide'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      try {
        final solvingData = {'solution': solutionController.text};
        final response = await http.put(
          Uri.parse('http://10.0.2.2:4000/api/ticket/solved/$ticketId'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(solvingData),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to mark ticket as solved');
        }

        final updatedTicket = json.decode(response.body);
        print(updatedTicket);

        Navigator.of(context).pop();
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Oops...'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Solving Ticket'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Solution:'),
          TextField(
            controller: solutionController,
            decoration: InputDecoration(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            handleSolved(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text('Submit'),
        ),
      ],
    );
  }
}
