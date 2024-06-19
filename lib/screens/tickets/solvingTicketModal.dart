import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todo/screens/FieldsTickets/qrCodeScreenFin.dart';

class SimpleHelloDialog extends StatelessWidget {
  final String ticketId;
  final String token;
  final TextEditingController solutionController = TextEditingController();
  final url = dotenv.env['URL'];
  final port = dotenv.env['PORT'];
  SimpleHelloDialog({Key? key, required this.ticketId, required this.token})
      : super(key: key);
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
                //  var widget;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScannerScreenFin(
                      ticketId: ticketId,
                      token: token,
                    ),
                  ),
                );
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
          Uri.parse('$url:$port/api/ticket/solved/$ticketId'),
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
       print('Received token: ${widget.token}');
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
