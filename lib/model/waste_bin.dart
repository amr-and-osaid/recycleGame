class WasteBin {
  int wasteBinID;
  String imagePath;
  String audioPath;

  WasteBin(this.wasteBinID) {
    imagePath = 'assets/waste_bins/$wasteBinID.png';
    audioPath = 'audio/trash_$wasteBinID.mp3';
  }

  static WasteBin electiric = WasteBin(1);
  static WasteBin glass = WasteBin(2);
  static WasteBin metal = WasteBin(3);
  static WasteBin organic = WasteBin(4);
  static WasteBin paper = WasteBin(5);
  static WasteBin plastic = WasteBin(6);

  static List<WasteBin> wasteBins = [
    electiric,
    glass,
    metal,
    organic,
    paper,
    plastic
  ];
}
