import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QrScannerScreenFin extends StatefulWidget {
  final String ticketId;
  final String token; // Ajoutez ce paramètre pour passer le token
  final url = dotenv.env['URL'];
  final port = dotenv.env['PORT'];

  QrScannerScreenFin({required this.ticketId, required this.token});

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreenFin> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned Code: ${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Evite les multiples déclenchements
      setState(() {
        isProcessing = true;
        result = scanData;
      });
      if (result != null) {
        controller.pauseCamera();
        try {
          final response = await http.put(
            Uri.parse(
                '${widget.url}:${widget.port}/api/ticket/solvedScan/${widget.ticketId}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.token}'
            },
          );

          if (response.statusCode != 200) {
            throw Exception('Failed to mark ticket as solved');
          }

          // Log pour vérifier le token
          print('Token: ${widget.token}');

          // Naviguer vers l'écran principal en passant le token
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                token: widget.token, // Utiliser le token passé au widget
                email: '',
              ),
            ),
          );
        } catch (error) {
          print('Error: $error');
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
        } finally {
          setState(() {
            isProcessing = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
