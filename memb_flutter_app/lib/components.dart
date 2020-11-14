import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:member_berries/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:member_berries/apicalls.dart';


class AppTextBox extends StatelessWidget {
  AppTextBox(this.text, this.etUsername);
  final String text;
  TextEditingController etUsername = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: etUsername,
      decoration: new InputDecoration(
        labelText: text,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide(color: Colors.white),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        if (val.length == 0) {
          return "Cannot be empty";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      style: new TextStyle(
        fontFamily: "Poppins",
      ),
    );
  }
}

class AppPwdBox extends StatelessWidget {
  AppPwdBox(this.text,this.etPassword);
  final String text;
  TextEditingController etPassword = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: etPassword,
      decoration: new InputDecoration(
        labelText: text,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(25.0),
          borderSide: new BorderSide( color: Colors.white),
        ),
        //fillColor: Colors.green
      ),
      validator: (val) {
        if (val.length == 0) {
          return "Cannot be empty";
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.text,
      obscureText: true,
      style: new TextStyle(
        fontFamily: "Poppins",
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton(this.text,this.action,this.labelIcon,this.butColor);
  final Color butColor;
  final String text;
  final Function action;
  final IconData labelIcon;
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(labelIcon, color: kTextStandardColor,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        side: BorderSide(color: Colors.white)
      ),
      color: butColor,
      splashColor: Colors.white,
      textColor: kTextStandardColor,
      focusColor: kBackgroundColor,
      label: Text(
        text,
      ),
      onPressed: action,
    );
  }
}

class SwipeFlipCards extends StatefulWidget {
  SwipeFlipCards(this.words,{Key key, this.title}) : super(key: key);
  final String title;
  final List<Map> words;
  var user = '';
  var cardColor = Colors.blueGrey[200];
  final api = new ApiCalls();
  final storage = new FlutterSecureStorage();
  // final Function leftResult,rightResult;
  @override
  _SwipeFlipCardsState createState() => _SwipeFlipCardsState();
}

class _SwipeFlipCardsState extends State<SwipeFlipCards>
    with SingleTickerProviderStateMixin {
  CardController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  //Use this to trigger swap.

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: TinderSwapCard(
          orientation: AmassOrientation.TOP,
          totalNum: widget.words.length,
          stackNum: 3,
          swipeEdge: 4.0,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.width * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.width * 0.8,
          cardBuilder: (context, index) => FlipCard(
            direction: FlipDirection.HORIZONTAL,
            key: Key('flip$index'),
            speed: 1000,
            onFlipDone: (status) {
              // print(widget.words);
              print(status);
            },
            front: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: widget.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${widget.words[index]['key']}', style: Theme.of(context).textTheme.headline5),
                  Text('Tap to flip back to meaning.',
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ),
            back: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: widget.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("${widget.words[index]['key']}", style: Theme.of(context).textTheme.headline5),
                  Divider(),
                  Text('Definition: ${widget.words[index]['meta'][0]['meanings'][0]['definitions'][0]['definition']}',style: Theme.of(context).textTheme.bodyText1),
                  Divider(),
                  Text('Examples: ${widget.words[index]['meta'][0]['meanings'][0]['definitions'][0]['example']}',style: Theme.of(context).textTheme.bodyText1),
                  Divider(),
                  Text('Synonyms: ${widget.words[index]['meta'][0]['meanings'][0]['definitions'][0]['synonyms']}',style: Theme.of(context).textTheme.bodyText1),
                  // Text('Click here to hide details',
                  //     style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ),
          ),
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {

              setState(() {
                widget.cardColor = Colors.redAccent[100];
              });
              //Card is LEFT swiping
            } else if (align.x > 0) {

              setState(() {
                widget.cardColor = Colors.green[500];
              });
              //Card is RIGHT swiping
            }
          },
          swipeCompleteCallback:
              (CardSwipeOrientation orientation, int index) async {
            setState(() {
                widget.cardColor = Colors.blueGrey[200];
            });
            String user = await widget.storage.read(key: 'u_id');
            if (orientation == CardSwipeOrientation.LEFT){
              Map data = {
                "key": widget.words[index]['key'],
                "user": user,
                "remConf": false
              };
              widget.api.postCall(data, 'post/reinforcement');
            }
            if (orientation == CardSwipeOrientation.RIGHT){
              Map data = {
                "key": widget.words[index]['key'],
                "user": user,
                "remConf": true
              };
              widget.api.postCall(data, 'post/reinforcement');
            }
            /// Get orientation & index of swiped card!
          },
        ),
      ),
    );
  }
}