import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';

part 'MemoryPathFile.g.dart';

@JsonSerializable()
class MemoryPathFile {
  MemoryPathFile._(this.metadata, this.memoryPathData, this.imageData);

  MemoryPathFile.fromMemoryPaths(
      MemoryPathFileMetadata metadata, List<MemoryPathDb> memoryPaths) {
    //TODO!
  }

  //UInt8List previewImage;
  MemoryPathFileMetadata metadata;
  List<MemoryPathDb> memoryPathData;
  @JsonKey(ignore: true)
  Map<String, Uint8List> imageData;

  static Future<MemoryPathFile> decode(Uint8List rawData) {
    //Decode: ZipDecoder.decodeBytes()
    //read index.json -> MemoryPathFile.fromJson
    //Datei mit gleichem Namen in Internal Storage? Prüfsummenalgorithmus über Uint8List des Images : null
    //save Images
  }

  /// encode [MemoryPathDb] to a compressed custom FileFormat for storing and sharing purposes
  Uint8List encode() {
    String name = '';
    final dynamic json = this.toJson;
    //Archive archive = Archive();
    TarEncoder tarEncoder = TarEncoder();
    ArchiveFile index = ArchiveFile('index.json', json.length, json);
    tarEncoder.add(index);
    this.imageData.forEach((key, value) {
      ArchiveFile image = ArchiveFile('assets/' + key, value.length, value);
      tarEncoder.add(image);
    });
    GZipEncoder gZipEncoder = GZipEncoder();
    return Uint8List.fromList(gZipEncoder.encode(tarEncoder));

    //ArchiveFile assets = ArchiveFile('assets', size, memoryPathData.);
    //tar ImageFiles
    //encoder.create('$name.tar');
    //   encoder.addDirectory(Directory('assets'));
    //   ArchiveFile index = ArchiveFile(...)
    //   encoder.addFile(index);
    //   encoder.close();
    //Gzip encoder
  }

  factory MemoryPathFile.fromJson(Map<String, dynamic> json) =>
      _$MemoryPathFileFromJson(json);
  Map<String, dynamic> toJson() => _$MemoryPathFileToJson(this);
}

@JsonSerializable()
class MemoryPathFileMetadata {
  //final String author
  //final int createTime
  //final int fileFormatVersion

}
