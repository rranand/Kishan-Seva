import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyMarket extends StatefulWidget {
  final double lat;
  final double lon;
  const NearbyMarket({ Key? key, required this.lat, required this.lon }) : super(key: key);

  @override
  State<NearbyMarket> createState() => _NearbyMarketState();
}

class _NearbyMarketState extends State<NearbyMarket> {
  List<dynamic> data = [];
  
  init() async {
    data.add({
      "lat": 18.6814592,
      "lon": 73.8771786,
      "address": "Alandi - Vadgaon Rd, Thakur Vasti, Pune, Maharashtra 412105",
      "name": "Shivkrupa Market",
      "link": "https://www.google.com/maps/place/18%C2%B040'53.3%22N+73%C2%B052'37.8%22E/@18.6814592,73.8749899,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x6f9015d99149428!8m2!3d18.6814592!4d73.8771786"
    });

    data.add({
      "lat": 18.6814592,
      "lon": 73.8771786,
      "address": "Moshi - Alandi Rd, Kelgaon, Maharashtra 412105",
      "name": "Rohidas super market",
      "link": "https://www.google.com/maps/place/18%C2%B040'53.3%22N+73%C2%B052'37.8%22E/@18.6814592,73.8749899,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x6f9015d99149428!8m2!3d18.6814592!4d73.8771786https://www.google.com/maps/place/18%C2%B040'53.3%22N+73%C2%B052'37.8%22E/@18.6814592,73.8749899,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0x6f9015d99149428!8m2!3d18.6814592!4d73.8771786" 
    });

    data.add({
      "lat": 18.6831883,
      "lon": 73.8391134,
      "address": "Shop No-1,Moshi Chowk,, Pune - Nashik Hwy, Moshi, Pune, Maharashtra 412105",
      "name": "Tulsi Market",
      "link": "https://www.google.com/maps/place/18%C2%B040'59.5%22N+73%C2%B050'20.8%22E/@18.6831883,73.8369247,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0xa95aaa0566a5ef39!8m2!3d18.6831883!4d73.8391134"
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Market", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white
                    ),
                    height: 120,
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            data[index]["name"],
                            style: TextStyle(
                              fontSize: 24
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            data[index]["address"],
                            style: TextStyle(
                              fontSize: 20
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    launch(data[index]["link"]);
                  },
                );
              }, 
              separatorBuilder: (context, index) => SizedBox(height: 10,),
              itemCount: data.length
            ),
          ),
        )
      ),
    );
  }
}