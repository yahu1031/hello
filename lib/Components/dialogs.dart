library dialogs;

export 'dialogs.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DialogAction { abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            body,
            style: GoogleFonts.notoSans(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => true,
        child: Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
