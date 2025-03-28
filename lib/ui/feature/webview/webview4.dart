/*
https://pub.dev/packages/webview_flutter
*/
import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Webview4Page extends StatefulWidget {
  @override
  _Webview4PageState createState() => _Webview4PageState();
}

class _Webview4PageState extends State<Webview4Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late WebViewController _controller;
  bool _loading = true;

  final String htmlString = '''
<html>
<head>
    <title>Webview from HTML String</title>
</head>
<body>
<div>This webview is loaded from HTML String</div>
<div><strong>This text is strong</strong></div>
<div><i>This text is italic</i></div>
<div style="color:red; font-size:20px;">This text is styling with inline css</div>
<div>
    <ol>
        <li>
            List 1
            <ul>
                <li>Sub List 1.1</li>
                <li>Sub List 1.2</li>
                <li>Sub List 1.3</li>
            </ul>
        </li>
        <li>List 2</li>
        <li>List 3</li>
        <li>List 4</li>
        <li>List 5</li>
    </ol>
</div>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _loading = false;
            });
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..loadHtmlString(htmlString);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar(),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          (_loading)?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}
