import 'package:google_gemini/google_gemini.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_config/flutter_config.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../utils/strings_english.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  // final apiKey = ;
  // final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  bool loading = false;
  List textChat = [];
  List textWithImageChat = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final gemini = GoogleGemini(
    apiKey: "AIzaSyDuA8sp0QyDkKLr4caOXekIkGkicDCLKiU",
  );

  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat24by7),
      ),
       body: Column(
         children: [
           Expanded(
             child: ListView.builder(
               controller: _controller,
               itemCount: textChat.length,
               padding: const EdgeInsets.only(bottom: 20),
               itemBuilder: (context, index) {
                 return ListTile(
                   isThreeLine: true,
                   leading: CircleAvatar(
                     child: Text(textChat[index]["role"].substring(0, 1)),
                   ),
                   title: Text(textChat[index]["role"]),
                   subtitle: Text(textChat[index]["text"]),
                 );
               },
             ),
           ),
           Container(
             alignment: Alignment.bottomRight,
             margin: const EdgeInsets.all(20),
             padding: const EdgeInsets.symmetric(horizontal: 15.0),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10.0),
               border: Border.all(color: Colors.grey),
             ),
             child: Row(
               children: [
                 Expanded(
                   child: TextField(
                     controller: _textController,
                     decoration: InputDecoration(
                       hintText: typeAMessage,
                       border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10.0),
                           borderSide: BorderSide.none),
                       fillColor: Colors.transparent,
                     ),
                     maxLines: null,
                     keyboardType: TextInputType.multiline,
                   ),
                 ),
                 IconButton(
                   icon: loading
                       ? const CircularProgressIndicator()
                       : const Icon(Icons.send),
                   onPressed: () {
                     fromText(query: _textController.text);
                   },
                 ),
               ],
             ),
           )
         ],
       ),
    );
  }
}
