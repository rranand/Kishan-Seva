import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kisanseva/keys.dart';


class Weather extends StatefulWidget {
  final double lat;
  final double lon;

  const Weather({ Key? key, required this.lat, required this.lon }) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  var weatherData = null;
  List<String> weekDay = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  
  _init() async {

    final response = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/forecast?id=524901&lat='+widget.lat.toString()+'&lon='+widget.lon.toString()+'&units=Metric&appid='+weather_key+'&cnt=7'),
    );

    if (response.statusCode == 200) {
      weatherData = jsonDecode(response.body);
    } else {
      _showToast(context, "Some Error Occurred");
      
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  String getDate(int inc) {
    DateTime date = DateTime.now().add(Duration(days: inc));
    String ans = "";

    ans += weekDay[date.weekday-1];
    ans += " " + date.day.toString() + "-" + date.month.toString() + "-" + date.year.toString();

    return ans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
      ),
      body: weatherData==null?const Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                weatherData["city"]["name"]+", "+weatherData["city"]["country"],
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),
                              SizedBox(height: 18,),
                              Text(
                                weatherData["list"][0]["main"]["temp"].toString() + "° C",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),Text(
                                weatherData["list"][0]["weather"][0]["main"].toString(),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white
                                ),
                              ),
                            ],
                            
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.green,
                            backgroundImage: NetworkImage("https://openweathermap.org/img/wn/"+weatherData["list"][0]["weather"][0]["icon"]+"@2x.png"),
                            child: null,
                          ),
                        ]
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Humidity: " + weatherData["list"][0]["main"]["humidity"].toString() + " %",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Pressure: " + weatherData["list"][0]["main"]["pressure"].toString() + " hPa",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Wind: " + weatherData["list"][0]["wind"]["speed"].toString() + " m/s",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Temp (Min): " + weatherData["list"][0]["main"]["temp_min"].toString() + "° C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                            ),
                          ),  
                          Text(
                            "Temp (Max): " + weatherData["list"][0]["main"]["temp_max"].toString() + "° C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: MediaQuery.of(context).size.height - 400,
                width: MediaQuery.of(context).size.width*0.9,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {  
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getDate(index),
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5,),
                                    Text(
                                      weatherData["list"][index+1]["main"]["temp"].toString() + "° C",
                                      style: TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),Text(
                                      weatherData["list"][index+1]["weather"][0]["main"].toString(),
                                      style: TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage("https://openweathermap.org/img/wn/"+weatherData["list"][index+1]["weather"][0]["icon"]+"@2x.png"),
                                  child: null,
                                ),
                              ]
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Temp (Min): " + weatherData["list"][index+1]["main"]["temp_min"].toString() + "° C",
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                ),  
                                Text(
                                  "Temp (Max): " + weatherData["list"][index+1]["main"]["temp_max"].toString() + "° C",
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }, separatorBuilder: (context, index) => SizedBox(height: 10,),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}