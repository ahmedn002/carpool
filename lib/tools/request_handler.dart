import 'package:flutter/material.dart';
import 'package:milestoneone/tools/response_wrapper.dart';

import '../view/widgets/dialog/error_dialog.dart';
import '../view/widgets/dialog/loading_dialog.dart';
import '../view/widgets/dialog/success_dialog.dart';

class RequestHandler {
  static Future<T?> handleRequest<T>({
    required BuildContext context,
    required Future<FirebaseResponseWrapper<T>> Function() service,
    Function()? onSuccess,
    Function()? onError,
    String loadingTitle = 'Loading...',
    String loadingMessage = 'Please wait while we process your request.',
    String successTitle = 'Success.',
    String successMessage = 'Your request has been processed successfully.',
    bool enableSuccessDialog = true,
    bool retry = false,
    int retryThreshold = 3,
    bool redirect = false,
    int redirectDelay = 3,
    Function()? redirection,
  }) async {
    int retryCount = 0;
    bool hasError = false;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: LoadingDialog(title: loadingTitle, message: loadingMessage),
      ),
    );

    do {
      try {
        final FirebaseResponseWrapper<T> result = await service();
        if (!result.hasError) {
          if (context.mounted) {
            Navigator.pop(context);
            if (enableSuccessDialog && !redirect) {
              showDialog(
                context: context,
                builder: (_) => SuccessDialog(title: successTitle, message: successMessage),
              );
            } else if (enableSuccessDialog && redirect) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => WillPopScope(
                  onWillPop: () async => false,
                  child: SuccessDialog(
                    title: successTitle,
                    message: 'You will be redirected shortly.',
                    enableLoader: true,
                  ),
                ),
              );
              Future.delayed(Duration(seconds: redirectDelay), () {
                Navigator.pop(context);
                redirection?.call();
                if (onSuccess != null) onSuccess();
              });
            }
          }
          if (onSuccess != null && !redirect) {
            onSuccess();
          }
          return result.data;
        } else {
          hasError = true;
          errorMessage = result.message;
        }

        break;
      } catch (error) {
        hasError = true;
      }
      retryCount++;
    } while (retry && retryCount < retryThreshold);

    if (hasError) {
      if (onError != null) {
        onError();
      }
      if (context.mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(title: 'Error!', message: errorMessage ?? 'An error occurred while processing your request.'),
        );
      }
    }

    return null;
  }
}
