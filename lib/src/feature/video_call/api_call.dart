import 'dart:convert';

// import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
// final token = FlutterConfig.get('VIDEO_SDK');
final token = "00eb245ece37af104c663b1e17d3e8dde6b067f02a2aacc0a3a6e1c5acac8ed4";
// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}
