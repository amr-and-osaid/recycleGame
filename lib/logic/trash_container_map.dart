class TrashContainerMap {
  static bool checkMatch(int trashID, int containerID) =>
      map[trashID] == containerID ? true : false;

  static Map<int, int> map;

  static void init() {
    map = Map<int, int>();
    map.putIfAbsent(1, () => 2);
    map.putIfAbsent(2, () => 4);
    map.putIfAbsent(3, () => 5);
    map.putIfAbsent(4, () => 5);
    map.putIfAbsent(5, () => 4);
    map.putIfAbsent(6, () => 4);
    map.putIfAbsent(7, () => 6);
    map.putIfAbsent(8, () => 5);
    map.putIfAbsent(9, () => 6);
    map.putIfAbsent(10, () => 6);
    map.putIfAbsent(11, () => 2);
    map.putIfAbsent(12, () => 2);
    map.putIfAbsent(13, () => 3);
    map.putIfAbsent(14, () => 1);
    map.putIfAbsent(15, () => 3);
    map.putIfAbsent(16, () => 3);
    map.putIfAbsent(17, () => 1);
    map.putIfAbsent(18, () => 1);
    map.putIfAbsent(19, () => 5);
    map.putIfAbsent(20, () => 6);
    map.putIfAbsent(21, () => 6);
    map.putIfAbsent(22, () => 3);
    map.putIfAbsent(23, () => 3);
    map.putIfAbsent(24, () => 3);
    map.putIfAbsent(25, () => 3);
    map.putIfAbsent(26, () => 1);
    map.putIfAbsent(27, () => 5);
    map.putIfAbsent(28, () => 2);
    map.putIfAbsent(29, () => 3);
    map.putIfAbsent(30, () => 5);
    map.putIfAbsent(31, () => 6);
    map.putIfAbsent(32, () => 5);
    map.putIfAbsent(33, () => 3);
  }
}
