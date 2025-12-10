import 'package:flutter/material.dart';
import 'jewelry_page.dart';

class JewelryFilter extends StatefulWidget {
  final Set<JewelryCategoryType> selected;
  final ValueChanged<Set<JewelryCategoryType>> onChanged;

  const JewelryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<JewelryFilter> createState() => _JewelryFilterState();
}

class _JewelryFilterState extends State<JewelryFilter> {
  late Set<JewelryCategoryType> selected;

  @override
  void initState() {
    super.initState();
    selected = {...widget.selected};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<JewelryCategoryType>(
          segments: const [
            ButtonSegment(value: JewelryCategoryType.rifle, label: Text("步枪")),
            ButtonSegment(value: JewelryCategoryType.pistol, label: Text("手枪")),
            ButtonSegment(value: JewelryCategoryType.knife, label: Text("刀具")),
            ButtonSegment(value: JewelryCategoryType.glove, label: Text("手套")),
          ],
          selected: selected,
          multiSelectionEnabled: true,
          emptySelectionAllowed: true,
          onSelectionChanged: (s) {
            setState(() => selected = s);
            widget.onChanged(s);
          },
        ),
      ),
    );
  }
}
