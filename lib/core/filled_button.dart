import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const FilledButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
