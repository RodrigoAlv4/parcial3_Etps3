import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcial3_etps3/models/Gif.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:parcial3_etps3/json/nombres.dart';

void main() {
  runApp(Parcial3());
}

class Parcial3 extends StatefulWidget{
  @override 
  _Parcial3State createState() => _Parcial3State();
}
class _Parcial3State extends State<Parcial3>{
  

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    List<Gif> gifs = [];
    
    if(response.statusCode ==200){
      String body = utf8.decode(response.bodyBytes);
      
      final jsonData = jsonDecode(body);

      for(var item in jsonData["data"]){
        gifs.add(
          Gif(item["email"],item["first_name"],item["last_name"],item["avatar"])
        ); 
      }
      return gifs;
    }else{
      throw Exception("Fallo la conexion");
    }
  }
  late final Future<List<Gif>> _listadoGifs = _getGifs();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listadoGifs;
    
  }

  @override 
  Widget build(BuildContext context){
      return MaterialApp(
        title: "Parcial 3",
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 17, 48, 25),
            elevation: 10,
            title: Padding(padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Parcial 3", style: TextStyle(fontSize: 20, color: Color.fromARGB(214, 216, 137, 64), fontWeight:  FontWeight.bold),
                ),
                Icon(Icons.nature_people_rounded, color: Color.fromARGB(214, 216, 137, 64),)
              ],
            ),),
          ),
          body:   FutureBuilder(
            future: _listadoGifs,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return GridView.count(
                  crossAxisCount: 2,
                  children: _listGifs(snapshot.data),
                          
                ); 
              }else if(snapshot.hasError){
                print(snapshot.error);
                return Text("error");
              }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
        ),
      );
  }

  Widget participantes(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Integrantes",
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: List.generate(Integrantes.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Integrantes[index]['url']),
                                  fit: BoxFit.fill),
                              color: Color.fromARGB(255, 177, 2, 2),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }



  List<Widget> _listGifs(data){
    List<Widget> gifs = [];
    for(var gif in data){
      gifs.add(
        Card(child: Column(
          children: [
            Expanded(child: Image.network(gif.url, fit: BoxFit.fitHeight),),
            Padding(padding: const EdgeInsets.all(3.0),
            child: Text(gif.correo),
            ),
            SizedBox(
              height: 0.4,
            ),
            Text(gif.name),
            SafeArea(child: Text(gif.lastname)),
            Center(
              child:  SizedBox(child: participantes(),height: 50,
            width: 270, ),
            )
           
          ],
          
        ),
        color: Color.fromARGB(56, 72, 124, 41),
        ),
        
      );
    }

    return gifs;

  }
}
