import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BuilderDataTable extends StatelessWidget {
  final DataGridSource source;
  final List<GridColumn> headerColumn;
  final double? rowHeight;

  const BuilderDataTable({
    required this.source,
    required this.headerColumn,
    this.rowHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        headerColor: Colors.lightGreen,
      ),
      child: SfDataGrid(
        source: source,
        columnWidthMode: ColumnWidthMode.fill,
        allowSorting: true,
        allowFiltering: true,
        isScrollbarAlwaysShown: true,
        rowHeight: rowHeight ?? 100,
        columns: headerColumn,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
      ),
    );
  }
}
