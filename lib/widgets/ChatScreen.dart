import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/cupertino.dart'; 
import './ChatMessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => new ChatScreenState();
}


// Chat Screen State
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendly Chat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
      body: new Container(
        decoration: Theme.of(context).platform == TargetPlatform.iOS ?
        new BoxDecoration(
          border: new Border(
            top: new BorderSide(color: Colors.grey[200])
          )
        ) : null,
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: _chatList()
            ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ) //new
    );
  }


  //Chat List Widget
  Widget _chatList() {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) => _messages[index],
      itemCount: _messages.length,
    );
  }


  //Text Input Field and send button
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS ?
              new CupertinoButton(
                child: new Text("Send"),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
              ) :
              new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                     
      _isComposing = false;                                          
    });   
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds:300),
        vsync: this,
      ),
    );
    setState(() {
          _messages.insert(0, message);
    });
    message.animationController.forward();
  }


  @override
  void dispose() {                                               
    for (ChatMessage message in _messages)                           
      message.animationController.dispose();                         
    super.dispose();                                                 
  }  
}