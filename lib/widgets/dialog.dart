import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:southern_money/setting/app_config.dart';
import 'package:southern_money/webapi/definitions/definitions_response.dart';
import 'package:southern_money/widgets/common_widget.dart';

import '../setting/ensure_initialized.dart' show getIt;

final appConfigService = getIt<AppConfigService>();

Future showInfoDialog({
  BuildContext? context, //this is no need anymore
  String title = "",
  String content = "",
  String button = "OK",
}) {
  return showDialog(
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(button),
          ),
        ],
      );
    },
  );
}

Future<bool?> showYesNoDialog({
  BuildContext? context, //no need
  String title = "",
  String content = "",
}) {
  return showDialog(
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
          ),
        ],
      );
    },
  );
}

class ContextWrapper {
  late BuildContext context;
}

Future showLoadingDialog({
  BuildContext? context, //no need
  String title = "Loading",
  required Future Function() func,
  String button = "Cancel",
  void Function()? onError,
}) {
  ContextWrapper contextWrapper = ContextWrapper();
  var future =
      Future.wait([func(), Future.delayed(const Duration(milliseconds: 100))])
          .then((v) async {
            if (contextWrapper.context.mounted) {
              Navigator.pop(contextWrapper.context);
            }
          })
          .onError((error, stackTrace) {
            //await Future.delayed(const Duration(microseconds: 5000));
            if (contextWrapper.context.mounted) {
              Navigator.pop(contextWrapper.context);
            }
            if (onError != null) {
              onError();
            }
          });
  var myCancelableFuture = CancelableOperation.fromFuture(future);

  return showDialog(
    barrierDismissible: false,
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      contextWrapper.context = context;
      return AlertDialog(
        title: Text(title),
        content: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              myCancelableFuture.cancel();
              Navigator.of(context).pop();
            },
            child: Text(button),
          ),
        ],
      );
    },
  );
}

Future showLoadingDialogWithErrorString({
  BuildContext? context, //no need
  String title = "Loading",
  required Future Function() func,
  String button = "Cancel",
  String onErrorTitle = "Error",
  String onErrorButton = "OK",
  String onErrorMessage = "error",
}) {
  bool isError = false;
  ContextWrapper contextWrapper = ContextWrapper();
  rebuildDialog() {
    if (contextWrapper.context.mounted) {
      (contextWrapper.context as Element).markNeedsBuild();
    }
  }

  var future = func()
      .then((v) async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (contextWrapper.context.mounted) {
          Navigator.pop(contextWrapper.context);
        }
      })
      .onError((error, stackTrace) {
        isError = true;
        rebuildDialog();
      });
  var myCancelableFuture = CancelableOperation.fromFuture(future);

  return showDialog(
    barrierDismissible: isError,
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      contextWrapper.context = context;
      return AlertDialog(
        title: Text(isError ? onErrorTitle : title),
        content: AnimatedSize(
          duration: Duration(milliseconds: appConfigService.animationTime),
          curve: Curves.easeOutQuart,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isError
                    ? Text(onErrorMessage)
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!isError) {
                myCancelableFuture.cancel();
              }
              Navigator.of(context).pop();
            },
            child: Text(isError ? onErrorButton : button),
          ),
        ],
      );
    },
  );
}

enum DialogState { conform, loading, success, error }

Future<bool?> apiRequestDialog<T>(
  Future<ApiResponse<T>> awaitable, {
  String? confirmMessage,
  void Function()? onSuccess,
}) {
  DialogState dialogState = DialogState.conform;
  ContextWrapper contextWrapper = ContextWrapper();
  rebuildDialog() {
    if (contextWrapper.context.mounted) {
      (contextWrapper.context as Element).markNeedsBuild();
    }
  }

  String errorMessage = "";
  String successMessage = "成功";
  late CancelableOperation myCancelableFuture;
  Future<dynamic> future() async {
    try {
      var response = await awaitable;
      if (response.success == false) {
        errorMessage = response.message ?? "错误";
        dialogState = DialogState.error;
        rebuildDialog();
      }
      if (response.success == true) {
        onSuccess?.call();
        if (!myCancelableFuture.isCanceled) {
          //change state
          dialogState = DialogState.success;
          rebuildDialog();
        }
      } else {
        errorMessage = response.message ?? "错误";
        dialogState = DialogState.error;
        rebuildDialog();
      }
      // 检查操作是否已被取消，如果已取消则不再更新状态
    } catch (e) {
      errorMessage = e.toString();
      dialogState = DialogState.error;
      rebuildDialog();
    }
  }

  void init() {
    myCancelableFuture = CancelableOperation.fromFuture(
      future(),
      onCancel: () {
        errorMessage = "用户取消";
        dialogState = DialogState.error;
        rebuildDialog();
      },
    );
  }

  if (confirmMessage == null) {
    dialogState = DialogState.loading;
    init();
  }

  return showDialog(
    barrierDismissible: false,
    context: logicRootContext,
    useRootNavigator: false,
    builder: (context) {
      contextWrapper.context = context;
      return AlertDialog(
        title: Text(switch (dialogState) {
          DialogState.conform => '确认？',
          DialogState.loading => 'Loading',
          DialogState.success => 'Success',
          DialogState.error => 'Error',
        }),
        content: AnimatedSize(
          duration: Duration(milliseconds: appConfigService.animationTime),
          curve: Curves.easeOutQuart,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                switch (dialogState) {
                  DialogState.conform => Text(confirmMessage!),
                  DialogState.loading => const CircularProgressIndicator(),
                  DialogState.success => Text(successMessage),
                  DialogState.error => Text(errorMessage),
                },
              ],
            ),
          ),
        ),
        actions: switch (dialogState) {
          DialogState.conform => [
            TextButton(
              onPressed: () {
                //forward to next state
                dialogState = DialogState.loading;
                init();
                rebuildDialog();
              },
              child: const Text('确认?'),
            ),
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
          ],
          DialogState.loading => [
            TextButton(
              onPressed: () {
                //cancel the loading
                myCancelableFuture.cancel();

                errorMessage = "用户取消";
                dialogState = DialogState.error;
                rebuildDialog();
              },
              child: const Text('取消'),
            ),
          ],
          DialogState.success => [
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop(true);
              },
              child: Text("OK"),
            ),
          ],
          DialogState.error => [
            TextButton(
              onPressed: () {
                //pop the dialog
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        },
      );
    },
  );
}

void popDialog(dynamic result) {
  Navigator.of(logicRootContext).pop(result);
}
