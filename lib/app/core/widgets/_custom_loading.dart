import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 100,
        width: 100,
        alignment: Alignment.center,
        child: LoadingAnimationWidget.twoRotatingArc(
          color: Theme.of(context).colorScheme.primary,
          size: 30,
        ),
      ),
    );
  }
}

void showCustomLoadingDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) => CustomDialog(),
    barrierDismissible: false,
  );
}
