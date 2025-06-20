import 'package:client_user/material/bilions_ui.dart';
import 'package:flutter/material.dart';

class BilionsTable extends StatelessWidget {
  final List<Widget> header;
  final List<List<Widget>> body;
  final double? bodyHeight;
  final String variant;
  final double radius;
  final double gap;
  final List<double?>? widths;

  const BilionsTable({
    Key? key,
    this.variant = 'primary',
    this.bodyHeight,
    required this.header,
    required this.body,
    this.radius = 6,
    this.widths,
    this.gap = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Table(
        columnWidths: getWidths(),
        children: [
          TableRow(
            children: header
                .map(
                  (e) => Container(
                    decoration: BoxDecoration(
                      color: BilionsTheme.getLightColor(variant),
                      borderRadius: getBorderRadius(0),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: e,
                  ),
                )
                .toList(),
          ),
          ...body.map(
            (b) {
              return TableRow(
                children: b
                    .map(
                      (e) => TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Container(
                          height: bodyHeight ?? 48,
                          padding: EdgeInsets.only(top: gap),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: getBorderRadius(1),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: e,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  BorderRadius getBorderRadius(int i) {
    return BorderRadius.only(
      topLeft: i == 0 ? const Radius.circular(5) : const Radius.circular(0),
      bottomLeft: i == 0 ? const Radius.circular(5) : const Radius.circular(0),
      topRight: i == header.length - 1
          ? const Radius.circular(5)
          : const Radius.circular(0),
      bottomRight: i == header.length - 1
          ? const Radius.circular(5)
          : const Radius.circular(0),
    );
  }

  Map<int, TableColumnWidth>? getWidths() {
    if (widths != null) {
      Map<int, TableColumnWidth>? newWidths = {};

      widths?.asMap().forEach((index, value) {
        if (value != null) {
          newWidths[index] = FractionColumnWidth(value / 100);
        }
      });

      return newWidths;
    }

    return null;
  }
}
