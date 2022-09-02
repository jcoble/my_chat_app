import 'package:flutter/material.dart';
import 'package:my_chat_app/src/utils/constants.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, this.isLoading = false, this.onPressed}) : super(key: key);
  final String text;
  final bool isLoading;
  VoidCallback? onPressed => onPressed;
  @override
  @override
  // ignore: non_constant_identifier_names
  Future<Widget> build(BuildContext context, Function() FutureButton, ) async {
    return SizedBox(
      height: Sizes.p48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
