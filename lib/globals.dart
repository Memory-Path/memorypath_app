import 'package:snapping_sheet/snapping_sheet.dart';

///Configuration of the default image, that is displayed, when no image is set yet
const String defaultImagePath = 'assets/images/blurry_background.jpg';

///Configuration for the Storage-Path, where images, that are used in the App, are stored.
const String storagePath = 'images/';

const List<SnappingPosition> kDefaultSnappingPositions = <SnappingPosition>[
  SnappingPosition.pixels(positionPixels: 24),
  SnappingPosition.factor(positionFactor: .5),
  SnappingPosition.factor(positionFactor: .9),
];
