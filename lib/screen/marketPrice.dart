import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kisanseva/other.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class MarketPrice extends StatefulWidget {
  const MarketPrice({ Key? key }) : super(key: key);

  @override
  State<MarketPrice> createState() => _MarketPriceState();
}

class _MarketPriceState extends State<MarketPrice> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("Mandi");
  final TextEditingController _search = TextEditingController();
  late DatabaseEvent data;
  List<dynamic> arr = [];
  List<dynamic> search = [];
  bool load = false;
  bool searchTrigger = false;
  String commodity = "Commodity";
  String district = "District";
  String modalPrice = "Modal Price";
  String state = "State";
  String variety = "Variety";
  String market = "Market";
  String mxPrice = "Max Price";
  String arrivalDate = "Arrival Date";
  String mnPrice = "Min Price";
  String searchTxt = "Search";
  String noPrice = "No Price Found";
  String noResult = "No Result Found";

  Future<String> translateLang(String txt, String nLang) async {
    final res = await txt.translate(from: 'en', to: nLang);
    return res.toString();
  }

  updateLanguage() async {
    final provider = Provider.of<LangProvider>(context, listen: false);
    commodity = await translateLang(commodity, provider.whichLang);
    district = await translateLang(district, provider.whichLang);
    modalPrice = await translateLang(modalPrice, provider.whichLang);
    state = await translateLang(state, provider.whichLang);
    variety = await translateLang(variety, provider.whichLang);
    market = await translateLang(market, provider.whichLang);
    mxPrice = await translateLang(mxPrice, provider.whichLang);
    arrivalDate = await translateLang(arrivalDate, provider.whichLang);
    mnPrice = await translateLang(mnPrice, provider.whichLang);
    searchTxt = await translateLang(searchTxt, provider.whichLang);
    noPrice = await translateLang(noPrice, provider.whichLang);
    noResult = await translateLang(noResult, provider.whichLang);
  }

  init() async {
    final provider = Provider.of<LangProvider>(context, listen: false);
    data = await ref.once();
    arr.clear();

    await updateLanguage();

    String arrival_date = "NA", commodity = "NA", district = "NA", market = "NA", max_price = "NA", min_price = "NA", modal_price = "NA", state = "NA", variety = "NA";

    data.snapshot.children.forEach((element) {
      element.children.forEach((element) {
        if (element.key.toString() == "arrival_date") {
          arrival_date = element.value.toString();
        } else if (element.key.toString() == "commodity") {
          commodity = element.value.toString();
        } else if (element.key.toString() == "district") {
          district = element.value.toString();
        } else if (element.key.toString() == "market") {
          market = element.value.toString();
        } else if (element.key.toString() == "max_price") {
          max_price = element.value.toString();
        } else if (element.key.toString() == "min_price") {
          min_price = element.value.toString();
        } else if (element.key.toString() == "modal_price") {
          modal_price = element.value.toString();
        } else if (element.key.toString() == "state") {
          state = element.value.toString();
        } else if (element.key.toString() == "variety") {  
          variety = element.value.toString();
        }

        arr.add({
          "arrival_date":arrival_date,
          "commodity":commodity,
          "district":district,
          "market":market,
          "max_price":max_price,
          "min_price":min_price,
          "modal_price":modal_price,
          "state":state,
          "variety":variety
        });
      });
    });

    load = true;

    if (this.mounted) {
      setState(() {});
    }
  }

  searchItem() async {
    if (_search.text.isNotEmpty) {
      search.clear();

      for(int i=0; i<arr.length; i++) {
        if (arr[i]["commodity"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
          search.add(arr[i]);
        } else if (arr[i]["district"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
          search.add(arr[i]);
        } else if (arr[i]["market"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
          search.add(arr[i]);
        } else if (arr[i]["state"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
          search.add(arr[i]);
        } else if (arr[i]["variety"].toString().toLowerCase().contains(_search.text.toLowerCase())) {
          search.add(arr[i]);
        }
      }

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Price", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: load?(
          arr.isEmpty?Center(child: Text(
            noPrice,
              style: TextStyle(
                fontSize: 24
              ),),):
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hoverColor: Colors.white,
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 121, 209, 124), width: 0.0),
                    ),
                    hintText:  searchTxt + " ...",
                  ),
                  onChanged: (String s) async {
                    if (s.isEmpty) {
                      searchTrigger = false;
                    } else {
                      searchTrigger = true;
                    }
                    _search.text = s;
                    setState(() {});
                    await searchItem();
                  },
                ),
                SizedBox(height: 10,),
                searchTrigger?(search.isEmpty?
                Center(
                  child: Text(
                    noResult, 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                )
                :buildCards(search))
                :buildCards(arr)
              ],
            )
          )
        ):Center(child: CircularProgressIndicator(),),
      ) 
    );
  }

  Widget buildCards(List<dynamic> arr) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height-200,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10,), 
        itemCount: arr.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              color: Colors.white
            ),
            width: MediaQuery.of(context).size.width*0.85,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commodity + ": " + arr[index]["commodity"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(district+ ": " + arr[index]["district"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(modalPrice+ ": " + arr[index]["modal_price"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(state+ ": " + arr[index]["state"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(variety+ ": " + arr[index]["variety"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(arrivalDate+ ": " + arr[index]["arrival_date"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(market+ ": " + arr[index]["market"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(mxPrice+ ": " + arr[index]["max_price"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(mnPrice+ ": " + arr[index]["min_price"], 
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                ],
              ),
            ),
          );
        }, 
      ),
    );
  }
}