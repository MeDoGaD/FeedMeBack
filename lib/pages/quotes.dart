import 'package:flutter/material.dart';
import 'package:feedme/helper/authentication.dart';

class AllQuotes extends StatefulWidget {
  _AllQuotesState createState() => _AllQuotesState();
}

class _AllQuotesState extends State<AllQuotes> {
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return (Scaffold(backgroundColor: Colors.black,body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(itemCount: 7,itemBuilder: (context,index){
        return Quote("MedoGad","Love","Everything will be appreciated : )");
      },separatorBuilder:(context, index) => SizedBox(height: scheight*1/30,),),
    ),

    ));
  }
}

class Quote extends StatelessWidget{
  final String username;
  final String title;
  final String quote;
  Quote(this.username,this.title,this.quote);
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Container(height: scheight*1/5,width: scwidth*0.8,decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),border: Border.all(color: Colors.yellow[200],width: 1)),
      child: Column(children: [
          Padding(
            padding:  EdgeInsets.only(left:scwidth*0.2,top:20 ),
            child: Row(
              children: [
                Text(username,style: TextStyle(color: Colors.white,fontSize:24),),
                SizedBox(width: scwidth*0.2,),
                RaisedButton(onPressed: (){},child: Text('Follow'),),
              ],
            ),
          ),
        Text('_______________________________________',style: TextStyle(color: Colors.yellow[200],fontSize:20),),
        Text(title,style: TextStyle(color: Colors.white,fontSize:22),),
        Text(quote,style: TextStyle(color: Colors.white,fontSize:18),),
      ],),);
  }
}
