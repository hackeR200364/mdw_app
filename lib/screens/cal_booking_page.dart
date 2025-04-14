import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalBookingPage extends StatefulWidget {
  const CalBookingPage({super.key});

  @override
  State<CalBookingPage> createState() => _CalBookingPageState();
}

class _CalBookingPageState extends State<CalBookingPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_buildCalHtml());
  }

  String _buildCalHtml() {
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Cal Booking</title>
    <script type="text/javascript">
      (function (C, A, L) {
        let p = function (a, ar) { a.q.push(ar); };
        let d = C.document;
        C.Cal = C.Cal || function () {
          let cal = C.Cal;
          let ar = arguments;
          if (!cal.loaded) {
            cal.ns = {};
            cal.q = cal.q || [];
            let s = d.createElement("script");
            s.src = A;
            d.head.appendChild(s);
            cal.loaded = true;
          }
          if (ar[0] === L) {
            const api = function () { p(api, arguments); };
            const namespace = ar[1];
            api.q = api.q || [];
            if (typeof namespace === "string") {
              cal.ns[namespace] = cal.ns[namespace] || api;
              p(cal.ns[namespace], ar);
              p(cal, ["initNamespace", namespace]);
            } else p(cal, ar);
            return;
          }
          p(cal, ar);
        };
      })(window, "https://app.cal.com/embed/embed.js", "init");

      Cal("init", "session", { origin: "https://cal.com" });
      Cal.ns.session("ui", {
        theme: "dark",
        layout: "month_view",
        hideEventTypeDetails: false
      });
    </script>
  </head>
  <body style="background-color: #121212; color: white;">
    <div 
      data-cal-link="mdwtherapy/session" 
      data-cal-namespace="session" 
      data-cal-config='{"layout":"month_view","theme":"dark"}'
      style="cursor:pointer; font-size: 20px; padding: 20px; background-color: #1e1e1e; border-radius: 8px; text-align: center;"
    >
      👉 Book a Session with MDW Therapy
    </div>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book a Session")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
