import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';

class HomeSearch extends StatefulWidget {
  final String hintText;

  final Function(String)? onSearch;
  const HomeSearch({
    super.key,
    required this.hintText,
    this.onSearch,
  });

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  late TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final doctorProvider = context.watch<DoctorProvider>();
    final newText = doctorProvider.query;
    // Cập nhật controller khi query trong provider thay đổi
    if (_controller.text != newText) {
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    context.read<DoctorProvider>().setQuery(query); // Cập nhật Provider
    widget.onSearch?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearch,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[300]!
                  : Colors.white54,
              width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textInputAction: TextInputAction.search, // Cho phép nhấn Enter để search
      onSubmitted: (_) => _handleSearch(), // Khi nhấn Enter
    );
  }
}
