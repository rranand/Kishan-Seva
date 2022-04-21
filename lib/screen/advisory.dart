import 'package:flutter/material.dart';

class Advisory extends StatefulWidget {
  const Advisory({ Key? key }) : super(key: key);

  @override
  State<Advisory> createState() => _AdvisoryState();
}

class _AdvisoryState extends State<Advisory> {
  Map<String, List<Map<String, List<String>>>> m = {};

  Future<void> init() async {
    m["Cereals"] = [{"Finger millet":["Dapoli Safed"]}, {"Maize": ["Hishell (MCH-42) (Hybrid)", "HM-12 (HKH 313) (Hybrid)", "KMH 3712 (Hybrid)", "KMH-25K60 (Hybrid)", "KMH-3426 (Hybrid)", "NMH-731 (Hybrid)", "NMH-803 (Hybrid)", "Vivek Maize hybrid  (FH 3483)", "SMH-3904"]}, {"Pearl millet": ["86M66 (MSH 226) (Hyrid)", "86M86  (MH 1684) (Hybrid)", "Kaveri Super Boss (Hybrid)  (MH 1553)", "MP-7792 (MH-1609)", "MP-7872  (MH-1610)"]}, {"Rice": ["Arize Tej (HRI 169) (IET21411) (Hybrid)", "CO 4  (IET 21449)  (TNRH 174)", "JKRH 3333 (IET 20759) (Hybrid)", "NK 5251 (IET 19738) (Hybrid)", "NPH 924-1 (IET 21255) (Hybrid)", "PNPH 24 (IET 21406)  (Hybrid)", "RH-1531 (Frontline Gold) (IET 21404) (Hybrid)", "US 382 (IET 20727) (Hybrid)"]}, {"Sorghum": ["CSH-27  (SPH-1644)", "CSH28 (NSH54) (SPH 1647) (Hybrid)", "CSV 27  (SPV 1870)", "CSV 29 R (SPV 2033)", "CSV26  (SPV 1829)", "SPH-1629 (MLSH 296 Gold/DJ 2002) (Hybrid)"]}, {"Wheat": ["PBW 644", "Pusa Pachheti (HD 3059)", "TL  2969  (Triticale)", "UAS-428 (Durum)"]}];
    m["Fibre"] = [{"Cotton": ["H-1300"]}, {"Jute": ["JROM-1 (PRADIP)"]}, {"Mesta": ["Shakti  (JBM-81)"]}, {"Sun-hemp": ["Ankur (SUIN-037)"]}];
    m["Oil Seeds"] = [{"Castor": ["DSP 222 (Hyrid)"]}, {"Mustard": ["CORAL-437  (PAC-437)""Pant Rai-19 (PR-2006-1)""RGN-229""RGN-236"]}, {"Sesame": ["DSS-9", "JLT-408"]}, {"Sun Flower": ["RSFH-130 (Bhadra)", "RSFV-901 (Kanthi)"]}];
    m["Pulses"] = [{"Black Gram": ["Vishwas (NUL-7)"]}, {"Chick Pea": ["HK-4  (HK 05-169)", "L-555 (GLK-26155)", "Raj Vijay Gram 203 (RVG 203)"]}, {"Cowpea": ["MFC-08-14 (Forage)"]}, {"Green gram (Moong)": ["HFP 529"]}, {"Horse Gram": ["Gujarat Dantiwada Horsegram-1 (GHG-5)"]}, {"Lentil": ["IPL-316"]}];
    m["Sugar Crops"] = [{"Sugar Cane": ["Co 0237", "Co 0403", "CoVSI-9805", "Karan-9  (Co-05011)", "Pratap Ganna-1  (CoPk-05191)"]}];
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
        title: const Text("Advisory", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      )
    );
  }
}