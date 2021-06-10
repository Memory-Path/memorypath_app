import 'package:latlong2/latlong.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

class MemoryPoint {
  MemoryPoint({this.name, this.image, this.question, this.answer, this.latlng});

  MemoryPoint.fromDb(MemoryPointDb memoryPointDb) {
    name = memoryPointDb.name;
    image = memoryPointDb.image;
    answer = memoryPointDb.answer;
    question = memoryPointDb.question;
    latlng = LatLng(memoryPointDb.lat!, memoryPointDb.long!);
  }
  String? name;
  String? image;
  String? question;
  String? answer;
  LatLng? latlng;

  MemoryPointDb toMemoryPointDb() {
    return MemoryPointDb(
        name: name!,
        question: question!,
        image: image!,
        lat: latlng!.latitude,
        long: latlng!.longitude);
  }
}
