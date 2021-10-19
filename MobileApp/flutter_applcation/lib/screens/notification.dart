import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/Modes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  String _outputText = '';
  bool _requireConsent = true;
  String _debugLabelString = "";
  bool _enableConsentButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initOnesignal();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initOnesignal() async {
    await OneSignal.shared.setAppId("b146c005-8195-4098-ac19-0e79fd7b7ae2");

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // ignore: unnecessary_brace_in_string_interps
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Details"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (_) => SwitchScreen(value: ''));
                Navigator.pushReplacement(context, route);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Text(
          _debugLabelString,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
