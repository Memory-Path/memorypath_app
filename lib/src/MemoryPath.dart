import 'package:mobile/src/MemoryPoint.dart';

class MemoryPath {
  MemoryPath(this.id, this.name, this.topic, this.memoryPoints);

  MemoryPath.fromDb() {
    //toDo: Implement
  }
  int id;
  String name;
  String topic;
  List<MemoryPoint> memoryPoints;

}
