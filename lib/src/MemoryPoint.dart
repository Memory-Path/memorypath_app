import 'package:latlng/latlng.dart';
import 'package:file_picker_cross/file_picker_cross.dart';


class MemoryPoint {

  int id;
  String name;
  FilePickerCross image;
  String question;
  String answer;
  LatLng latlng;

  MemoryPoint({this.id,this.name, this.image, this.question, this.answer, this.latlng});

  MemoryPoint.fromDb(){
    //toDo: Implement
  }
}
