import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_widget.dart';

Future popupContent(
  Widget child,
  double width, {
  double? height,
  BuildContext? context,
  bool useFragment = true,
  bool adaptiveHeight = false,
}) {
  final widget = SizedBox(
    width: width,
    height: height,
    child: useFragment ? Fragment(child: child) : child,
  );
  final context0 = context ?? logicRootContext;
  return showDialog(
    context: context0,
    barrierDismissible: true,
    useRootNavigator: false,
    builder: (builder) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            widget,
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context0).pop(),
              ),
            ),
          ],
        ),
      );
    },
  );
}

enum ScreenSizeType { landscape, bigPortrait, smallPortrait }

ScreenSizeType getScreenSizeType(MediaQueryData mediaQuery) {
  var width = mediaQuery.size.width;
  final height = mediaQuery.size.height;
  bool isLandscape = mediaQuery.orientation == Orientation.landscape;
  if (isLandscape) {
    return ScreenSizeType.landscape;
  }
  bool isBigScreen = (width > 500 && height > 500);
  if (isBigScreen) {
    return ScreenSizeType.bigPortrait;
  }
  return ScreenSizeType.smallPortrait;
}

void popupOrNavigate(
  BuildContext context,
  Widget page, {
  bool adaptiveHeight = false,
  bool useFragment = true,
}) {
  var mediaQuery = MediaQuery.of(context);
  var width = mediaQuery.size.width;
  final height = mediaQuery.size.height;
  final screenSizeType = getScreenSizeType(mediaQuery);
  if (screenSizeType == ScreenSizeType.landscape) {
    popupContent(
      page,
      width / 2,
      useFragment: useFragment,
      adaptiveHeight: adaptiveHeight,
    );
  } else if (screenSizeType == ScreenSizeType.bigPortrait) {
    popupContent(
      page,
      width * 2 / 3,
      height: height * 2 / 3,
      useFragment: useFragment,
      adaptiveHeight: adaptiveHeight,
    );
  } else {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (builder) {
          return page;
        },
      ),
    );
  }
}

class Fragment extends StatelessWidget {
  final Widget child;
  final String root;

  const Fragment({required this.child, this.root = "/", super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: root,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        builder = (context) => child;
        return MaterialPageRoute(builder: builder);
      },
    );
  }
}
