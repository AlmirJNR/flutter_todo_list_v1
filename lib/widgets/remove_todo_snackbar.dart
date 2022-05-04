import 'package:flutter/material.dart';

class RemoveToDoSnackbarWidget {
  RemoveToDoSnackbarWidget(
    BuildContext context, {
    required String text,
    required void Function() onPressed,
  }) {
    _snackBar = SnackBar(
      content: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: onPressed,
      ),
    );
  }

  late final SnackBar _snackBar;

  SnackBar get snackBar => _snackBar;
}
