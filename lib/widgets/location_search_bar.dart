import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/theme/app_theme.dart';

// Mock suggestions for Hebron area
const List<_Suggestion> _suggestions = [
  _Suggestion('Hebron Mall', LatLng(31.5445, 35.0791)),
  _Suggestion('Ibrahimi Mosque', LatLng(31.5243, 35.1098)),
  _Suggestion('Hebron University', LatLng(31.5374, 35.0837)),
  _Suggestion('Al-Ahli Hospital', LatLng(31.5412, 35.0901)),
  _Suggestion('City Centre', LatLng(31.5300, 35.0980)),
  _Suggestion('Old City', LatLng(31.5260, 35.1075)),
  _Suggestion('Industrial Zone', LatLng(31.5145, 35.0702)),
  _Suggestion('Halhul', LatLng(31.5840, 35.0975)),
  _Suggestion('Dura', LatLng(31.4987, 35.0501)),
  _Suggestion('Yatta', LatLng(31.4331, 35.1049)),
  _Suggestion('Bethlehem', LatLng(31.7054, 35.2024)),
  _Suggestion('Ramallah', LatLng(31.9038, 35.2034)),
];

class _Suggestion {
  final String name;
  final LatLng position;
  const _Suggestion(this.name, this.position);
}

class LocationSearchBar extends StatefulWidget {
  final String hint;
  final String? value;
  final void Function(String name, LatLng position) onSelected;
  final IconData prefixIcon;
  final Color prefixColor;

  const LocationSearchBar({
    super.key,
    required this.hint,
    this.value,
    required this.onSelected,
    required this.prefixIcon,
    required this.prefixColor,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  List<_Suggestion> _filtered = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? '';
    _focus.addListener(() {
      if (!_focus.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  @override
  void didUpdateWidget(LocationSearchBar old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && widget.value != null) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    final lower = q.toLowerCase();
    setState(() {
      _filtered = _suggestions
          .where((s) => s.name.toLowerCase().contains(lower))
          .toList();
      _showSuggestions = q.isNotEmpty;
    });
  }

  void _select(_Suggestion s) {
    _controller.text = s.name;
    _focus.unfocus();
    setState(() => _showSuggestions = false);
    widget.onSelected(s.name, s.position);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: _onChanged,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                Icon(widget.prefixIcon, color: widget.prefixColor, size: 18),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: AppColors.textHint, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _showSuggestions = false);
                    },
                  )
                : null,
          ),
        ),
        if (_showSuggestions && _filtered.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filtered.length.clamp(0, 5),
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 16),
              itemBuilder: (_, i) {
                final s = _filtered[i];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textSecondary),
                  title: Text(s.name,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 13)),
                  onTap: () => _select(s),
                );
              },
            ),
          ),
      ],
    );
  }
}
