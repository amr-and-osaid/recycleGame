import 'package:cleanWise/model/waste_bin.dart';

class Waste {
  int wasteID;
  WasteBin wasteBin;
  String imagePath;

  Waste(this.wasteID, this.wasteBin) {
    imagePath = 'assets/wastes/' + wasteID.toString() + '.png';
  }

  static List<Waste> wastes = [
    Waste(1, WasteBin.glass),
    Waste(2, WasteBin.organic),
    Waste(3, WasteBin.paper),
    Waste(4, WasteBin.paper),
    Waste(5, WasteBin.organic),
    Waste(6, WasteBin.organic),
    Waste(7, WasteBin.plastic),
    Waste(8, WasteBin.paper),
    Waste(9, WasteBin.plastic),
    Waste(10, WasteBin.plastic),
    Waste(11, WasteBin.glass),
    Waste(12, WasteBin.glass),
    Waste(13, WasteBin.metal),
    Waste(14, WasteBin.electiric),
    Waste(15, WasteBin.metal),
    Waste(16, WasteBin.metal),
    Waste(17, WasteBin.electiric),
    Waste(18, WasteBin.electiric),
    Waste(19, WasteBin.paper),
    Waste(20, WasteBin.plastic),
    Waste(21, WasteBin.plastic),
    Waste(22, WasteBin.metal),
    Waste(23, WasteBin.metal),
    Waste(24, WasteBin.metal),
    Waste(25, WasteBin.metal),
    Waste(26, WasteBin.electiric),
    Waste(27, WasteBin.paper),
    Waste(28, WasteBin.glass),
    Waste(29, WasteBin.metal),
    Waste(30, WasteBin.paper),
    Waste(31, WasteBin.plastic),
    Waste(32, WasteBin.paper),
    Waste(33, WasteBin.metal),
  ];
}
