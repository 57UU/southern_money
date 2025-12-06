import 'package:flutter/material.dart';
import 'jewelry_page.dart';

class JewelryFilter extends StatefulWidget {
  final Set<JewelryCategory> selected;
  final ValueChanged<Set<JewelryCategory>> onChanged;

  const JewelryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<JewelryFilter> createState() => _JewelryFilterState();
}

class _JewelryFilterState extends State<JewelryFilter> {
  late Set<JewelryCategory> selected;

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
        child: SegmentedButton<JewelryCategory>(
          segments: const [
            ButtonSegment(value: JewelryCategory.rifle, label: Text("步枪")),
            ButtonSegment(value: JewelryCategory.pistol, label: Text("手枪")),
            ButtonSegment(value: JewelryCategory.knife, label: Text("刀具")),
            ButtonSegment(value: JewelryCategory.glove, label: Text("手套")),
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
