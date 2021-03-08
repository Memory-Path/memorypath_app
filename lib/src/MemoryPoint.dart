import 'package:latlong/latlong.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class MemoryPoint {
  int id;
  String name;
  String image;
  String question;
  String answer;
  LatLng latlng;

  MemoryPoint(
      {this.id,
      this.name,
      this.image,
      this.question,
      this.answer,
      this.latlng});

  MemoryPoint.fromDb(MemoryPointDb memoryPointDb) {
    //this.id = memoryPointDb.id;
    this.name = memoryPointDb.name;
    this.image = memoryPointDb.image;
    this.answer = memoryPointDb.answer;
    this.question = memoryPointDb.question;
    this.latlng = LatLng(memoryPointDb.lat, memoryPointDb.long);
  }

  MemoryPointDb toMemoryPointDb() {
    return MemoryPointDb(
        //id: this.id,
        name: this.name,
        question: this.question,
        image: this.image,
        lat: this.latlng.latitude,
        long: this.latlng.longitude);
  }
}
