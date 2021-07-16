import 'package:snapping_sheet/snapping_sheet.dart';

const String defaultImagePath = 'assets/images/blurry_background.jpg';

const List<SnappingPosition> kDefaultSnappingPositions = <SnappingPosition>[
  SnappingPosition.pixels(positionPixels: 24),
  SnappingPosition.factor(positionFactor: .5),
  SnappingPosition.factor(positionFactor: .9),
];
