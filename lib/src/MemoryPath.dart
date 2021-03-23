import 'package:mobile/src/MemoryPoint.dart';

class MemoryPath {
  int id;
  String name;
  String topic;
  List<MemoryPoint> memoryPoints;

  MemoryPath(this.id, this.name, this.topic, this.memoryPoints);

  MemoryPath.fromDb() {
    //toDo: Implement
  }
}
