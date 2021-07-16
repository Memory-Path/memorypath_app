import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memorypath_db_api/memorypath_db_api.dart';
import 'package:mobile/components/grabbing_handle.dart';
import 'package:mobile/globals.dart';
import 'package:mobile/src/HeroTags.dart';
import 'package:mobile/widgets/EditMemoryPointWidget.dart';
import 'package:mobile/widgets/maps/EditableMapView.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const SnappingPosition _kInitialPosition =
    SnappingPosition.factor(positionFactor: .25);

class EditMemoryPathCard extends StatefulWidget {
  const EditMemoryPathCard({Key? key, required this.onCreated, this.path})
      : super(key: key);
  final MemoryPathCreatedCallback onCreated;
  final MemoryPathDb? path;

  @override
  _EditMemoryPathCardState createState() => _EditMemoryPathCardState();
}

class _EditMemoryPathCardState extends State<EditMemoryPathCard> {
  final TextEditingController _newMemoryPathController =
      TextEditingController();
  final TextEditingController _topicController = TextEditingController();

  List<MemoryPointDb> _points = <MemoryPointDb>[];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.path != null) {
      _newMemoryPathController.text = widget.path!.name!;
      _topicController.text = widget.path!.topic!;
      _points = widget.path!.memoryPoints!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      controller: _newMemoryPathController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Path name'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: EditableMapView(
                        initialMemoryPoints: _points,
                        onChange: (List<MemoryPointDb> memoryPoints) {
                          setState(() {
                            _points = memoryPoints;

                            if (widget.path != null)
                              widget.path!.memoryPoints = _points;
                          });
                        },
                      ),
                    ),
                    if (_points.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: widget.path != null
                            ? const Text(
                                'Tap on list item to edit point details')
                            : const Text(
                                'Save your path and come back to edit point details'),
                      )
                    else
                      const ListTile(
                        leading: Icon(Icons.touch_app),
                        title: Text('Tap on map to add Memory-Points'),
                      ),
                    TextField(
                      autofocus: true,
                      controller: _topicController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Topic'),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        OutlinedButton.icon(
                          icon: const Hero(
                              tag: HeroTags.AddPathIcon,
                              child: Icon(Icons.check)),
                          onPressed: () {
                            if (_newMemoryPathController.text.trim() == '' ||
                                _topicController.text.trim() == '' ||
                                _points.length < 2) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill in all fields and add at least 2 memory points.')));
                              return;
                            }
                            if (widget.path != null) {
                              widget.path!.name = _newMemoryPathController.text;
                              widget.path!.topic = _topicController.text;
                              //widget.path.memoryPoints = _points;
                              Navigator.of(context)
                                  .pop(); // TODO(MemoryPath): that's dirty,
                            } else
                              widget.onCreated(MemoryPathDb(
                                  name: _newMemoryPathController.text,
                                  topic: _topicController.text,
                                  memoryPoints: _points));
                          },
                          label: const Text('Save Memory-Path'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      initialSnappingPosition: _kInitialPosition,
      snappingPositions: List.from(kDefaultSnappingPositions)
        ..insert(1, _kInitialPosition),
      grabbingHeight: 48,
      grabbing: GrabbingHandle(),
      sheetBelow: SnappingSheetContent(
        childScrollController: _scrollController,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: ReorderableListView.builder(
              shrinkWrap: true,
              primary: false,
              //physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext c, int i) => MemoryPointListTile(
                    key: ValueKey<MemoryPointDb>(_points[i]),
                    point: _points[i],
                  ),
              itemCount: _points.length,
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > oldIndex) {
                  newIndex--;
                }
                final MemoryPointDb point = _points.removeAt(oldIndex);
                _points.insert(newIndex, point);
                if (widget.path != null) {
                  widget.path!.memoryPoints = _points;
                }
                setState(() {});
              }),
        ),
      ),
    );
  }
}

class MemoryPointListTile extends StatefulWidget {
  const MemoryPointListTile({Key? key, this.point, this.onHeightChange})
      : super(key: key);
  final MemoryPointDb? point;
  final HeightChangeCallback? onHeightChange;

  @override
  _MemoryPointListTileState createState() => _MemoryPointListTileState();
}

typedef HeightChangeCallback = Function(double height);

class _MemoryPointListTileState extends State<MemoryPointListTile>
    with AfterLayoutMixin<MemoryPointListTile> {
  final GlobalKey _heightKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _heightKey,
      child: ExpansionTile(
        trailing: Container(
          constraints: BoxConstraints.loose(const Size(0, 0)),
        ),
        leading: const Icon(Icons.lightbulb),
        title: Text(widget.point!.name!),
        children: <Widget>[
          EditMemoryPointWidget(
            memoryPoint: widget.point,
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final double newHeight = _heightKey.currentContext!.size!.height;
    widget.onHeightChange!(newHeight);
  }
}

typedef MemoryPathCreatedCallback = void Function(MemoryPathDb memoryPath);
