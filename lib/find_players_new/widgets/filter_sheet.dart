import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/skill_level.dart';

/// Bottom sheet for filtering map markers
class FilterSheet extends StatefulWidget {
  final int? currentSkillLevel;
  final double currentMaxDistance;
  final String currentTimeFilter;

  const FilterSheet({
    super.key,
    this.currentSkillLevel,
    required this.currentMaxDistance,
    required this.currentTimeFilter,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late int? _selectedSkillLevel;
  late double _maxDistance;
  late String _timeFilter;

  @override
  void initState() {
    super.initState();
    _selectedSkillLevel = widget.currentSkillLevel;
    _maxDistance = widget.currentMaxDistance;
    _timeFilter = widget.currentTimeFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: FlutterFlowTheme.of(context).headlineSmall,
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset All',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Skill Level Filter
            Text(
              'Skill Level',
              style: FlutterFlowTheme.of(context).titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillChip(null, 'Any Level'),
                ...SkillLevel.values.map((level) {
                  return _buildSkillChip(level.value, level.label);
                }),
              ],
            ),
            const SizedBox(height: 24),

            // Distance Filter
            Text(
              'Maximum Distance',
              style: FlutterFlowTheme.of(context).titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: '${_maxDistance.toInt()} km',
                    onChanged: (value) {
                      setState(() => _maxDistance = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_maxDistance.toInt()} km',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Time Filter
            Text(
              'Time Range',
              style: FlutterFlowTheme.of(context).titleSmall,
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildTimeFilterOption('all', 'Any Time', Icons.all_inclusive),
                const SizedBox(height: 8),
                _buildTimeFilterOption('today', 'Today', Icons.today),
                const SizedBox(height: 8),
                _buildTimeFilterOption(
                    'this_week', 'This Week', Icons.date_range),
              ],
            ),
            const SizedBox(height: 32),

            // Apply button
            FFButtonWidget(
              onPressed: _applyFilters,
              text: 'Apply Filters',
              icon: const Icon(Icons.check, size: 20),
              options: FFButtonOptions(
                width: double.infinity,
                height: 50,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                    ),
                elevation: 2,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(int? level, String label) {
    final isSelected = _selectedSkillLevel == level;
    final skillLevel = level != null ? SkillLevel.fromValue(level) : null;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedSkillLevel = selected ? level : null);
      },
      selectedColor: skillLevel != null
          ? _hexToColor(skillLevel.hexColor).withOpacity(0.3)
          : FlutterFlowTheme.of(context).primary.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected
            ? (skillLevel != null
                ? _hexToColor(skillLevel.hexColor)
                : FlutterFlowTheme.of(context).primary)
            : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTimeFilterOption(String value, String label, IconData icon) {
    final isSelected = _timeFilter == value;
    return InkWell(
      onTap: () => setState(() => _timeFilter = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Readex Pro',
                    color: isSelected
                        ? FlutterFlowTheme.of(context).primary
                        : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: FlutterFlowTheme.of(context).primary,
              ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSkillLevel = null;
      _maxDistance = 10.0;
      _timeFilter = 'all';
    });
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'skillLevel': _selectedSkillLevel,
      'maxDistance': _maxDistance,
      'timeFilter': _timeFilter,
    });
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
