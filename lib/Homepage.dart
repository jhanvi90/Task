import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/model/CommitsmodelClass.dart';

class home extends StatefulWidget {
  const home({Key key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<Data> Datalists=[];

  //checking for numeric value
  bool isNumeric(String s)
  {
    var expression=r"[[\]\\|=+)(*&^%0-9-]#";
    RegExp re = new RegExp(expression);
    var check=re.hasMatch(s);
    if(check==true)
    {
      return true;
    } else {
      return false;
    }
  }


//function to load data from json using model class
  Future<List<Data>> fetchData() async
  {
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/flutter/flutter/commits'),
      headers: {"content-type": "application/json", "charset": "utf-8",
      },
    );
    final jsonresponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final jsonresponse = json.decode(response.body);
      for(var i in jsonresponse)
        {
         setState(() {
           Datalists.add(Data.fromJson(i));
         });
        }
      return Datalists;
    } else {
      throw Exception('Failed to load request');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("List of Commits",style: TextStyle(color: Colors.black),),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return  ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                      //spliting commit data to get last value of commit to check it ends with number or not
                      var splitdata=Datalists[index].commit.message.split(' ');

                      //calling numeric check function
                      isNumeric(splitdata.last);

                      return Column(
                        children: [
                            Container(
                              //color changing depending on commits end value

                            color: isNumeric(splitdata.last)? Colors.yellow:Colors.white,
                            child:
                            ListTile(leading: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                            title: Text(Datalists[index].commit.message, style: TextStyle(fontSize: 14),))
                            ),

                           Divider(color: Colors.black,thickness: 2,)
                              ],
                            );
                    }
                );
            }  else {
            return Center(
            child: Center(
            child: CircularProgressIndicator()));
            }
      }),

      ),
    );
  }
}
