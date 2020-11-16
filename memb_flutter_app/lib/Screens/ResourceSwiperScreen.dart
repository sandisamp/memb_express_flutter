import 'package:flutter/material.dart';
import 'package:member_berries/apicalls.dart';
import 'package:member_berries/constants.dart';
import 'package:member_berries/components.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';


class ResourceSwiper extends StatefulWidget {
  @override
  _ResourceSwiperState createState() => _ResourceSwiperState();
}

class _ResourceSwiperState extends State<ResourceSwiper> {
  final api = new ApiCalls();
  final storage = new FlutterSecureStorage();
  List<Map> place;
  Future loadResources() async {
    place = [];
    String uId = await storage.read(key: 'u_id');
    Map response = await api.getCall(uId, 'get/resources');
    if ( response['statusCode']  == 200 ){
        response['body'].forEach((element) => {
          place.add(element),
          place.shuffle()
        });
    }
    return place;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   loadResources();
  // }
  void meaningAlertDialog(BuildContext context, var data){
    showDialog(context: context,builder: (context){
      return AlertDialog(
          title: Text("${data[0]['word']}", style: Theme.of(context).textTheme.headline3),
          content: Column(
            children: [
              Expanded(flex: 7,child: Text("Definition: ${data[0]['meanings'][0]['definitions'][0]['definition']}",style: Theme.of(context).textTheme.headline5)),
              Divider(),
              Expanded(flex: 2,child: Text("Examples: ${data[0]['meanings'][0]['definitions'][0]['example']}",style: Theme.of(context).textTheme.bodyText1)),
              Divider(),
              Expanded(flex: 1,child: Text("Synonyms: ${data[0]['meanings'][0]['definitions'][0]['synonyms']}",style: Theme.of(context).textTheme.bodyText1))
            ],
          ),
      );
    });
  }
  TextEditingController newResourceController = TextEditingController();
  void createAlertDialog(BuildContext context){
    showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("New resource"),
        content: TextField(
          controller: newResourceController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Add'),
            color: Colors.blueAccent,
            onPressed: () async{
                String newRes = newResourceController.text.toString();
                // print(newRes);
                String uId = await storage.read(key: 'u_id');
                Map data = {"user": uId, "key": newRes};
                Map response = await api.postCall(data, 'post/vocab');
                if (response['statusCode'] == 200){
                  Toast.show("Success!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                }else{
                  Toast.show("${response['body']}", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                }
                Navigator.pop(context);
                setState(() {
                  place = place;
                });
                print(response['body']);
                meaningAlertDialog(context, response['body']);
              },
          )
        ],
      );
    });
  }

  // swipeRightAction(){
  //   data = {
  //     widget.words[index]['key']
  //   };
  // }
  // swipeLeftAction(){
  //   print("na munna");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // await loadResources();
          setState(() {
            place = place;
          });
        },
        child: Stack(
          children: <Widget>[
            ListView(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  builder: (context, projectSnap){
                    if (projectSnap.connectionState == ConnectionState.none &&
                        projectSnap.hasData == null) {
                      return Container(
                        // child: SpinKitRotatingCircle(
                        //   color: Colors.white,
                        //   size: 50.0,
                        );
                    }
                    return Expanded(
                      flex: 6,
                      child: Container(
                        color: kBackgroundColor,
                        margin: EdgeInsets.all(20),
                        child: SwipeFlipCards(place),
                      ),
                    );
                  },
                  future: loadResources(),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Container(
                //     color: kBackgroundColor,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Container(
                //             margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                //             child: ActionButton("Forgot!",swipeLeftAction,Icons.add_alert,Colors.red),
                //         ),
                //         Container(
                //             margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20.0),
                //             child: ActionButton("Remember :)",swipeRightAction,Icons.lightbulb_outline,Colors.green),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 4,
                  child: Center(
                    // margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 100.0),
                    child: FloatingActionButton.extended(
                      onPressed: () => {
                        createAlertDialog(context)
                      },
                      label: Text('Add new Word'),
                      icon: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}




