import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Video extends StatefulWidget {
  const Video({ Key? key }) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  List<String> videoIds = ["WhOrIUlrnPo","WhOrIUlrnPo","WhOrIUlrnPo","WhOrIUlrnPo","WhOrIUlrnPo","WhOrIUlrnPo","WhOrIUlrnPo"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farming Videos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: EdgeInsets.all(14.0),
            itemCount: videoIds.length, 
            separatorBuilder: (context, index) => SizedBox(height: 50,),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  child: Image.network("https://img.youtube.com/vi/"+videoIds[index]+"/0.jpg"),
                ),
                onTap: () async {
                  launch("https://www.youtube.com/watch?v="+videoIds[index]);
                }
              );
            }
          )
        )
      ),
    );
  }
}