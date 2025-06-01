import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wm_doctor/core/constant/diments.dart';

class CupertinoNumberPicker extends StatefulWidget {
  final int selectedNumber;
  final ValueChanged<int> onChanged;

  const CupertinoNumberPicker(
      {super.key, required this.selectedNumber, required this.onChanged});

  @override
  State<CupertinoNumberPicker> createState() => _CupertinoNumberPickerState();
}

class _CupertinoNumberPickerState extends State<CupertinoNumberPicker> {
  // Boshlang‘ich qiymat
  int selectedNumber = 1;
  List<int> list = [for (var i = 1; i <= 30; i++) i];

  @override
  void initState() {
    selectedNumber = widget.selectedNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CupertinoPicker(
        selectionOverlay: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.space10)),
        ),
        itemExtent: 40,
        // Element balandligi
        scrollController:
            FixedExtentScrollController(initialItem: selectedNumber - 1),
        onSelectedItemChanged: (index) {
          setState(() {
            print("SelectedNumber: ${index + 1}");
            selectedNumber = index + 1;
            widget.onChanged(selectedNumber);
          });
        },
        children: list.map(
          (index) {
            return Center(
              child: Text(
                "$index",
                style: TextStyle(
                  fontSize:
                      index == selectedNumber ? Dimens.space20 : Dimens.space20,
                  fontWeight: index == selectedNumber
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: index == selectedNumber ? Colors.black : Colors.grey,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
