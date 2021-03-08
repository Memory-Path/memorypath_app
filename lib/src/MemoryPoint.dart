import 'package:latlong/latlong.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class MemoryPoint {
  String name;
  String image;
  String question;
  String answer;
  LatLng latlng;

  MemoryPoint({this.name, this.image, this.question, this.answer, this.latlng});

  MemoryPoint.fromDb(MemoryPointDb memoryPointDb) {
    this.name = memoryPointDb.name;
    this.image = memoryPointDb.image;
    this.answer = memoryPointDb.answer;
    this.question = memoryPointDb.question;
    this.latlng = LatLng(memoryPointDb.lat, memoryPointDb.long);
  }

  MemoryPointDb toMemoryPointDb() {
    return MemoryPointDb(
        name: this.name,
        question: this.question,
        image: this.image,
        lat: this.latlng.latitude,
        long: this.latlng.longitude);
  }
}
