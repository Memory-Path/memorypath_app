import 'package:flutter/material.dart';

class SpacingBottomNavigationBar extends StatelessWidget {
  const SpacingBottomNavigationBar(
      {Key? key, required this.items, required this.onTap})
      : super(key: key);

  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: AutomaticNotchedShape(
        const RoundedRectangleBorder(),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32 + 8),
        ),
      ),
      notchMargin: 8,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: BottomNavigationBarTheme(
              data: BottomNavigationBarTheme.of(context).copyWith(
                backgroundColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                // TODO(MemoryPath): How to navigate to specific Route?
                // -> create a `onTab` handler...
                onTap: onTap,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: items,
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: Spacer(),
          )
        ],
      ),
    );
  }
}
