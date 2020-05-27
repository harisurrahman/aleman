import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, dynamic>> reciters = [
  {
    "status": false,
    "name": "Yassin Al-Jazaery",
    "url":
        "https://everyayah.com/data/warsh/warsh_yassin_al_jazaery_64kbps/zips/"
  },
  {
   "status": false,
    "name": "Abdul Basit Murattal",
    "url": "https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/zips/"
  },
  {
    "status": false,
    "name": "Abdullah Basfar",
    "url": "https://everyayah.com/data/Abdullah_Basfar_32kbps/zips/"
  },
  {
    "status": false,
    "name": "Alafasy",
    "url": "https://everyayah.com/data/Alafasy_64kbps/zips/"
  },
  {
    "status": false,
    "name": "Ali Jaber",
    "url": "https://everyayah.com/data/Ali_Jaber_64kbps/zips/"
  }
];

class Reciter extends StatefulWidget {
  Reciter({Key key}) : super(key: key);

  @override
  _ReciterState createState() => _ReciterState();
}

class _ReciterState extends State<Reciter> {

  SharedPreferences _pref;
  int reciter;

  _getReciter()async{
    _pref = await SharedPreferences.getInstance();
    reciter = _pref.getInt('current_reciter');
   
    if(reciter==null){
      setState(() {
        reciters[0]['status'] = true;
      });
    }else{
      setState(() {
        reciters[reciter]['status'] = true;
      });
    }
  }

  setReciter(int index){
    _pref.setInt('current_reciter', index);
    for(int i=0;i< reciters.length; i++){
      reciters[i]['status'] = false;
    }
    setState(() {
      reciters[index]['status'] = true;
    });
   
  }

  @override
  void initState() {
   _getReciter();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reciters"),
      ),
      body: ListView.builder(
          itemCount: reciters.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){
                setReciter(index);
              },
              child: Card(
                elevation: 2.0,
                color: reciters[index]['status'] == true ? Colors.grey[300]:Colors.white,
                child: ListTile(
                  leading: Text(reciters[index]['name'], style: TextStyle(fontSize: 20),),
                ),
              ),
            );
          }),
    );
  }
}
