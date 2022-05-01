import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class SellCrops extends StatefulWidget {
  final String uID;
  const SellCrops({ Key? key, required this.uID }) : super(key: key);

  @override
  State<SellCrops> createState() => _SellCropsState();
}

class _SellCropsState extends State<SellCrops> {
  int load = 0;
  final TextEditingController _cropName = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final DatabaseReference ref = FirebaseDatabase.instance.ref("SellCrops");
  late DatabaseEvent data;
  List<dynamic> arr = [];

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  init() async {
    data = await ref.once();
    arr.clear();
    
    final temp = data.snapshot.children.where((element) {
      bool flag = false;
      element.children.forEach((element) {
        if (element.key.toString() == "userId" && element.value.toString() == widget.uID) {
          flag = true;
        }
      });
      return flag;
    }).toList();

    for(int i=0; i<temp.length; i++) {
      String cropName = "NA", state = "NA", quantity = "NA", price = "NA", sold = "NA", key = "NA";
        final element = temp[i];
        key = element.key.toString();
        element.children.forEach((element) {
          if ("cropName" == element.key) {
            cropName = element.value.toString();
          } else if ("quantity" == element.key) {
            quantity = element.value.toString();
          } else if ("price" == element.key) {
            price = element.value.toString();
          } else if ("sold" == element.key) {
            sold = element.value.toString();
          } else if ("state" == element.key) {
            state = element.value.toString();
          } else {
          }
        },);

        arr.add({
          "cropName": cropName,
          "quantity": quantity,
          "price": price,
          "sold": sold,
          "state": state,
          "key": key
        });
    }
    
    arr = arr.reversed.toList();
    load = 1;

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  _showToast(BuildContext context, String show) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(show),
        action: SnackBarAction(label: 'Close', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  AddCropToSell() async {
    try {
      final newChild = ref.push();

      await FirebaseDatabase.instance.ref("SellCrops/"+newChild.key.toString()).set({
        "cropName": _cropName.text,
        "state": _state.text,
        "quantity": _quantity.text,
        "price": _price.text,
        "userId": widget.uID,
        "sold": false
      });

      _cropName.text = "";
      _state.text = "";
      _quantity.text = "";
      _price.text = "";
      
      Navigator.pop(context);
      _showToast(context, "Crop Added Successfully");
      await init();
    } catch(e) {
      Navigator.pop(context);
      _showToast(context, "Some Unknown Error Occurred");
    }

  }

  buildDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _cropName,
                    keyboardType: TextInputType.text,
                    maxLength: 70,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    autocorrect: false,
                    validator: (value) {
                      if (_cropName.text.length <= 2) {
                        return "Enter Valid Crop Name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: "Enter Crop Name",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  TextFormField(
                    controller: _quantity,
                    keyboardType: TextInputType.number,
                    maxLength: 70,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    autocorrect: false,
                    validator: (value) {
                      if (_quantity.text.isEmpty) {
                        return "Enter Quantity";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: "Enter Quantity (in KG)",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  TextFormField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    maxLength: 70,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    autocorrect: false,
                    validator: (value) {
                      if (_price.text.isEmpty) {
                        return "Enter Price";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: "Enter Price",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                  TextFormField(
                    controller: _state,
                    keyboardType: TextInputType.text,
                    maxLength: 70,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                    cursorColor: Colors.black,
                    autocorrect: false,
                    validator: (value) {
                      if (_state.text.length <= 2) {
                        return "Enter State";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: "Enter State",
                      errorStyle: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 100,
                height: 42,
                child: ElevatedButton(
                  onPressed: () async {
                      buildDialog(context);
                      await AddCropToSell();
                      Navigator.pop(context);
                  }, 
                  child: Text(
                    "Sell Crop",
                    style: TextStyle(
                      fontSize: 17
                    ),
                  )
                ),
              ),
              SizedBox(height: 15,)
            ],
          ),
        );
      }
    );
  }

  deleteCrop(String key) async {
    await FirebaseDatabase.instance.ref("SellCrops").child(key).remove();
    await init();
    _showToast(context, "Crop Deleted Successfully");
  }

  deleteCropWidget(BuildContext context, String key) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are You Sure?",
                  style: TextStyle(
                    fontSize: 25
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async{
                          buildShowDialog(context);
                          await deleteCrop(key);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    int cnt = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Crops", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.shade200,
        child: load==0?Center(child: CircularProgressIndicator(),):(arr.isEmpty?Center(
          child: Text(
            "No Crop Found",
            style: TextStyle(
              fontSize: 24
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
            separatorBuilder: (builder, context) => SizedBox(height: 10,),
            itemCount: arr.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(const Radius.circular(13)),
                  color: Colors.white,
                ),
                height: 170,
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
                            children: [
                              Text(arr[index]["cropName"], 
                                style: TextStyle(
                                  fontSize: 24
                                ),
                              ),
                              SizedBox(height: 5,),
                              Text("Quantity: " + arr[index]["quantity"] + " KG", 
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              SizedBox(height: 5,),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => deleteCropWidget(context, arr[index]["key"]),
                              );
                            }, 
                            icon: Icon(Icons.delete)
                          )
                        ],
                      ),
                      Text("Price: ₹ " + arr[index]["price"] + "/KG", 
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("State: " + arr[index]["state"], 
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("Sold: " + (arr[index]["sold"]=="false"?"No":"Yes"), 
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          buildDialog(context)
        },
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}