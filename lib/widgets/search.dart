import 'package:flutter/material.dart';

class animationSearchBar extends StatefulWidget {
  @override
  __animationSearchBarState createState() => __animationSearchBarState();
}

class __animationSearchBarState extends State<animationSearchBar> {
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(top: 40, left: 20),
      duration: Duration(milliseconds: 200),
      width: _folded ? 56 : 350,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: !_folded
                    ? TextField(
                        decoration: InputDecoration(
                            hintText: 'search',
                            hintStyle: TextStyle(
                              color: Colors.blue[300],
                            ),
                            border: InputBorder.none),
                      )
                    : null),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
